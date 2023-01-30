import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../common/enums/message_enum.dart';
import '../../../common/repositories/common_firebase_storage_repository.dart';
import '../../../common/utils/utils.dart';
import '../../../models/chat_message_model.dart';
import '../../../models/last_message_model.dart';
import '../../../models/user_model.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<List<ChatMessageModel>> getChatStream(String receiverUid) {
    final String chatName = (receiverUid.compareTo(auth.currentUser!.uid) > 0)
        ? '$receiverUid-${auth.currentUser!.uid}'
        : '${auth.currentUser!.uid}-$receiverUid';
    final String collectionPath = 'messages/$chatName/$chatName';

    return firestore
        .collection(collectionPath)
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<ChatMessageModel> messages = [];
      for (var document in event.docs) {
        messages.add(ChatMessageModel.fromJson(document.data()));
      }
      return messages;
    });
  }

  Stream<List<LastMessageModel>> getChatListStream() {
    return firestore
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<LastMessageModel> chats = [];
      for (var document in event.docs) {
        print(document.get.toString());
        print('\n\n\n\n\n\n\n\n');
        if (document.get('receiverUid') == auth.currentUser!.uid ||
            document.get('senderId') == auth.currentUser!.uid) {
          chats.add(LastMessageModel.fromJson(document.data()));
        }
      }
      return chats;
    });
  }

  void _saveMessageToMessageSubcollection({
    required String receiverUid,
    required String text,
    required Timestamp timeSent,
    required MessageEnum messageType,
    required String messageId,
    required String username,
  }) async {
    final message = ChatMessageModel(
      senderId: auth.currentUser!.uid,
      receiverUid: receiverUid,
      text: text,
      type: messageType,
      messageId: messageId,
      timeSent: timeSent,
    );
    final String chatName = (receiverUid.compareTo(auth.currentUser!.uid) > 0)
        ? '$receiverUid-${auth.currentUser!.uid}'
        : '${auth.currentUser!.uid}-$receiverUid';
    await firestore
        .collection('messages')
        .doc(chatName)
        .collection(chatName)
        .doc(messageId)
        .set(
          message.toJson(),
        );
  }

  void _saveMessageToLatestMessage({
    required String receiverUid,
    required String text,
    required Timestamp timeSent,
    required MessageEnum messageType,
    required String messageId,
    required String username,
  }) async {
    String receiverDisplayName = await getDisplayNameByUid(receiverUid);
    final message = LastMessageModel(
      senderId: auth.currentUser!.uid,
      senderDisplayName: username,
      receiverDisplayName: receiverDisplayName,
      receiverUid: receiverUid,
      text: text,
      timeSent: timeSent,
      isSeen: false,
      unreadMessageCount: 1,
    );

    final String chatName = (receiverUid.compareTo(auth.currentUser!.uid) > 0)
        ? '$receiverUid-${auth.currentUser!.uid}'
        : '${auth.currentUser!.uid}-$receiverUid';
    final currentChat =
        FirebaseFirestore.instance.collection('messages').doc(chatName);
    final doc = await currentChat.get();
    (doc.exists)
        ? currentChat.update({
            'unreadMessageCount': FieldValue.increment(1),
            'timeSent': timeSent,
            'text': text,
          })
        : currentChat.set(message.toJson());
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUid,
    required UserModel senderUser,
  }) async {
    try {
      var timeSent = Timestamp.now();
      var messageId = const Uuid().v1();

      _saveMessageToMessageSubcollection(
        receiverUid: receiverUid,
        text: text,
        messageId: messageId,
        messageType: MessageEnum.text,
        timeSent: timeSent,
        username: senderUser.displayName,
      );
      _saveMessageToLatestMessage(
        receiverUid: receiverUid,
        text: text,
        messageId: messageId,
        messageType: MessageEnum.text,
        timeSent: timeSent,
        username: senderUser.displayName,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUid,
    required UserModel senderUser,
    required ProviderRef ref,
    required MessageEnum messageEnum,
  }) async {
    try {
      var timeSent = Timestamp.now();
      var messageId = const Uuid().v1();

      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            'chat/${messageEnum.type}/${auth.currentUser!.uid}/$receiverUid/$messageId',
            file,
          );

      UserModel? recieverUserData;
      var userDataMap =
          await firestore.collection('users').doc(receiverUid).get();
      recieverUserData = UserModel.fromJson(userDataMap.data()!);

      String contactMsg;

      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = '📷 사진';
          break;
        case MessageEnum.video:
          contactMsg = '📸 영상 메세지';
          break;
        case MessageEnum.audio:
          contactMsg = '🎵 오디오 메세지';
          break;
        case MessageEnum.gif:
          contactMsg = 'GIF 메세지';
          break;
        default:
          contactMsg = 'GIF 메세지';
      }
      _saveMessageToMessageSubcollection(
        receiverUid: receiverUid,
        text: imageUrl,
        messageId: messageId,
        messageType: messageEnum,
        timeSent: timeSent,
        username: senderUser.displayName,
      );
      _saveMessageToLatestMessage(
        receiverUid: receiverUid,
        text: contactMsg,
        messageId: messageId,
        messageType: messageEnum,
        timeSent: timeSent,
        username: senderUser.displayName,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String receiverUid,
    required UserModel senderUser,
  }) async {
    try {
      var timeSent = Timestamp.now();
      UserModel? recieverUserData;

      var userDataMap =
          await firestore.collection('users').doc(receiverUid).get();
      recieverUserData = UserModel.fromJson(userDataMap.data()!);

      var messageId = const Uuid().v1();

      _saveMessageToMessageSubcollection(
        receiverUid: receiverUid,
        text: gifUrl,
        messageId: messageId,
        messageType: MessageEnum.gif,
        timeSent: timeSent,
        username: senderUser.displayName,
      );
      _saveMessageToLatestMessage(
        receiverUid: receiverUid,
        text: 'GIF 메세지',
        messageId: messageId,
        messageType: MessageEnum.gif,
        timeSent: timeSent,
        username: senderUser.displayName,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

//   void _saveDataToContactsSubcollection(
//     UserModel senderUserData,
//     UserModel? recieverUserData,
//     String text,
//     Timestamp timeSent,
//     String receiverUid,
//     bool isGroupChat,
//   ) async {
// // users -> reciever user id => chats -> current user id -> set data
//     var recieverChatContact = ChatContact(
//       name: senderUserData.displayName,
//       profilePic: senderUserData.profilePic,
//       contactId: senderUserData.uid,
//       timeSent: timeSent,
//       lastMessage: text,
//     );
//     await firestore
//         .collection('users')
//         .doc(receiverUid)
//         .collection('chats')
//         .doc(auth.currentUser!.uid)
//         .set(
//           recieverChatContact.toMap(),
//         );
//     // users -> current user id  => chats -> reciever user id -> set data
//     var senderChatContact = ChatContact(
//       name: recieverUserData!.name,
//       profilePic: recieverUserData.profilePic,
//       contactId: recieverUserData.uid,
//       timeSent: timeSent,
//       lastMessage: text,
//     );
//     await firestore
//         .collection('users')
//         .doc(auth.currentUser!.uid)
//         .collection('chats')
//         .doc(receiverUid)
//         .set(
//           senderChatContact.toMap(),
//         );
//   }

  // Stream<List<ChatContact>> getChatContacts() {
  //   return firestore
  //       .collection('users')
  //       .doc(auth.currentUser!.uid)
  //       .collection('chats')
  //       .snapshots()
  //       .asyncMap((event) async {
  //     List<ChatContact> contacts = [];
  //     for (var document in event.docs) {
  //       var chatContact = ChatContact.fromJson(document.data());
  //       var userData = await firestore
  //           .collection('users')
  //           .doc(chatContact.contactId)
  //           .get();
  //       var user = UserModel.fromJson(userData.data()!);
  //
  //       contacts.add(
  //         ChatContact(
  //           name: user.displayName,
  //           profilePic: user.profilePic,
  //           contactId: chatContact.contactId,
  //           timeSent: chatContact.timeSent,
  //           lastMessage: chatContact.lastMessage,
  //         ),
  //       );
  //     }
  //     return contacts;
  //   });
  // }

  // void setChatMessageSeen(
  //   BuildContext context,
  //   String receiverUid,
  //   String messageId,
  // ) async {
  //   try {
  //     await firestore
  //         .collection('users')
  //         .doc(auth.currentUser!.uid)
  //         .collection('chats')
  //         .doc(receiverUid)
  //         .collection('messages')
  //         .doc(messageId)
  //         .update({'isSeen': true});
  //
  //     await firestore
  //         .collection('users')
  //         .doc(receiverUid)
  //         .collection('chats')
  //         .doc(auth.currentUser!.uid)
  //         .collection('messages')
  //         .doc(messageId)
  //         .update({'isSeen': true});
  //   } catch (e) {
  //     showSnackBar(context: context, content: e.toString());
  //   }
  // }
}
