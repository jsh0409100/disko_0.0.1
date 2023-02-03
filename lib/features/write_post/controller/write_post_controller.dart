import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/enums/message_enum.dart';
import '../../../models/chat_message_model.dart';
import '../../../models/last_message_model.dart';
import '../../auth/controller/auth_controller.dart';

final writePostControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(writePostRepositoryProvider);
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
}
