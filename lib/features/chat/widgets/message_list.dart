import 'package:disko_001/common/widgets/loading_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/chat_message_model.dart';
import '../controller/chat_controller.dart';
import 'chat_bubble.dart';

class ChatMessage extends ConsumerStatefulWidget {
  final String receiverUid;
  const ChatMessage({super.key, required this.receiverUid});

  @override
  ConsumerState<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends ConsumerState<ChatMessage> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ChatMessageModel>>(
        stream: ref.read(chatControllerProvider).chatStream(widget.receiverUid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }

          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageController
                .jumpTo(messageController.position.maxScrollExtent);
          });

          return ListView.builder(
            controller: messageController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final chatDocs = snapshot.data![index];
              if (chatDocs.senderId == FirebaseAuth.instance.currentUser!.uid) {
                return MyChatBubble(
                    text: chatDocs.text,
                    timeSent: chatDocs.timeSent,
                    type: chatDocs.type);
              }
              return PeerChatBubble(
                  text: chatDocs.text,
                  timeSent: chatDocs.timeSent,
                  type: chatDocs.type);
            },
          );
        });
  }
}
