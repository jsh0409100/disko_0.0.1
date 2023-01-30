import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    required String username,
  }) async {
    final message = ChatMessageModel(
      senderId: auth.currentUser!.uid,
      receiverUid: receiverUid,
      text: text,
      timeSent: timeSent,
    );
    final String chatName = (receiverUid.compareTo(auth.currentUser!.uid) > 0)
        ? '$receiverUid-${auth.currentUser!.uid}'
        : '${auth.currentUser!.uid}-$receiverUid';
    final String collectionPath = 'messages/$chatName/$chatName';
    await firestore.collection(collectionPath).add(
          message.toJson(),
        );
  }

  void _saveMessageToLatestMessage({
    required String receiverUid,
    required String text,
    required Timestamp timeSent,
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

      _saveMessageToMessageSubcollection(
        receiverUid: receiverUid,
        text: text,
        timeSent: timeSent,
        username: senderUser.displayName,
      );
      _saveMessageToLatestMessage(
        receiverUid: receiverUid,
        text: text,
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
//     DateTime timeSent,
//     String recieverUserId,
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
//         .doc(recieverUserId)
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
//         .doc(recieverUserId)
//         .set(
//           senderChatContact.toMap(),
//         );
//   }

  // void sendFileMessage({
  //   required BuildContext context,
  //   required File file,
  //   required String recieverUserId,
  //   required UserModel senderUserData,
  //   required ProviderRef ref,
  //   required MessageEnum messageEnum,
  //   required bool isGroupChat,
  // }) async {
  //   try {
  //     var timeSent = DateTime.now();
  //     var messageId = const Uuid().v1();
  //
  //     String imageUrl = await ref
  //         .read(commonFirebaseStorageRepositoryProvider)
  //         .storeFileToFirebase(
  //           'chat/${messageEnum.type}/${senderUserData.uid}/$recieverUserId/$messageId',
  //           file,
  //         );
  //
  //     UserModel? recieverUserData;
  //     if (!isGroupChat) {
  //       var userDataMap =
  //           await firestore.collection('users').doc(recieverUserId).get();
  //       recieverUserData = UserModel.fromMap(userDataMap.data()!);
  //     }
  //
  //     String contactMsg;
  //
  //     switch (messageEnum) {
  //       case MessageEnum.image:
  //         contactMsg = '📷 Photo';
  //         break;
  //       case MessageEnum.video:
  //         contactMsg = '📸 Video';
  //         break;
  //       case MessageEnum.audio:
  //         contactMsg = '🎵 Audio';
  //         break;
  //       case MessageEnum.gif:
  //         contactMsg = 'GIF';
  //         break;
  //       default:
  //         contactMsg = 'GIF';
  //     }
  //     _saveDataToContactsSubcollection(
  //       senderUserData,
  //       recieverUserData,
  //       contactMsg,
  //       timeSent,
  //       recieverUserId,
  //       isGroupChat,
  //     );
  //
  //     _saveMessageToMessageSubcollection(
  //       recieverUserId: recieverUserId,
  //       text: imageUrl,
  //       timeSent: timeSent,
  //       messageId: messageId,
  //       username: senderUserData.name,
  //       messageType: messageEnum,
  //       messageReply: messageReply,
  //       recieverUserName: recieverUserData?.name,
  //       senderUsername: senderUserData.name,
  //       isGroupChat: isGroupChat,
  //     );
  //   } catch (e) {
  //     showSnackBar(context: context, content: e.toString());
  //   }
  // }

  // void sendGIFMessage({
  //   required BuildContext context,
  //   required String gifUrl,
  //   required String recieverUserId,
  //   required UserModel senderUser,
  //   required MessageReply? messageReply,
  //   required bool isGroupChat,
  // }) async {
  //   try {
  //     var timeSent = DateTime.now();
  //     UserModel? recieverUserData;
  //
  //     if (!isGroupChat) {
  //       var userDataMap =
  //           await firestore.collection('users').doc(recieverUserId).get();
  //       recieverUserData = UserModel.fromMap(userDataMap.data()!);
  //     }
  //
  //     var messageId = const Uuid().v1();
  //
  //     _saveDataToContactsSubcollection(
  //       senderUser,
  //       recieverUserData,
  //       'GIF',
  //       timeSent,
  //       recieverUserId,
  //       isGroupChat,
  //     );
  //
  //     _saveMessageToMessageSubcollection(
  //       recieverUserId: recieverUserId,
  //       text: gifUrl,
  //       timeSent: timeSent,
  //       messageType: MessageEnum.gif,
  //       messageId: messageId,
  //       username: senderUser.name,
  //       messageReply: messageReply,
  //       recieverUserName: recieverUserData?.name,
  //       senderUsername: senderUser.name,
  //       isGroupChat: isGroupChat,
  //     );
  //   } catch (e) {
  //     showSnackBar(context: context, content: e.toString());
  //   }
  // }

  // Stream<List<ChatContact>> getChatContacts() {
  //   return firestore
  //       .collection('users')
  //       .doc(auth.currentUser!.uid)
  //       .collection('chats')
  //       .snapshots()
  //       .asyncMap((event) async {
  //     List<ChatContact> contacts = [];
  //     for (var document in event.docs) {
  //       var chatContact = ChatContact.fromMap(document.data());
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
  //   String recieverUserId,
  //   String messageId,
  // ) async {
  //   try {
  //     await firestore
  //         .collection('users')
  //         .doc(auth.currentUser!.uid)
  //         .collection('chats')
  //         .doc(recieverUserId)
  //         .collection('messages')
  //         .doc(messageId)
  //         .update({'isSeen': true});
  //
  //     await firestore
  //         .collection('users')
  //         .doc(recieverUserId)
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
