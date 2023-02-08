import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../common/enums/message_enum.dart';
import '../../../models/chat_message_model.dart';
import '../../../models/last_message_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/chat_repository.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatMessageModel>> chatStream(String receiverUid) {
    return chatRepository.getChatStream(receiverUid);
  }

  Stream<List<LastMessageModel>> chatListStream() {
    return chatRepository.getChatListStream();
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String receiverUid,
  ) {
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
            context: context,
            text: text,
            receiverUid: receiverUid,
            senderUser: value!,
          ),
        );
  }

  // void toggleUserOnline(
  //   BuildContext context,
  //   String receiverUid,
  // ) {
  //   ref.read(chatRepositoryProvider).toggleUserOnline(
  //         context: context,
  //         receiverUid: receiverUid,
  //       );
  // }

  void sendFileMessage(
    BuildContext context,
    File file,
    String receiverUid,
    MessageEnum messageEnum,
  ) {
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendFileMessage(
            context: context,
            file: file,
            receiverUid: receiverUid,
            senderUser: value!,
            messageEnum: messageEnum,
            ref: ref,
          ),
        );
  }

  void sendLocationMessage(
    BuildContext context,
    Uint8List file,
    String receiverUid,
    MessageEnum messageEnum,
    LatLng coordinates,
  ) {
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendLocationMessage(
            context: context,
            imageBytes: file,
            receiverUid: receiverUid,
            senderUser: value!,
            ref: ref,
            coordinates: coordinates,
          ),
        );
  }

  void sendGIFMessage(
    BuildContext context,
    String gifUrl,
    String receiverUid,
  ) {
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newgifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';

    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendGIFMessage(
            context: context,
            gifUrl: newgifUrl,
            receiverUid: receiverUid,
            senderUser: value!,
          ),
        );
  }

  void setChatMessageSeen(
    BuildContext context,
    String receiverUid,
  ) {
    chatRepository.setChatMessageSeen(
      context,
      receiverUid,
    );
  }
}
