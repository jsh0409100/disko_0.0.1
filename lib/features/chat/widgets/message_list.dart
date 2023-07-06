import 'package:disko_001/common/enums/message_enum.dart';
import 'package:disko_001/common/widgets/loading_screen.dart';
import 'package:disko_001/features/chat/widgets/locationItem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';

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
            messageController.jumpTo(messageController.position.maxScrollExtent);
          });
          DateTime? time;
          return ListView.builder(
            controller: messageController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final timeFormat = DateFormat('y년 M월 d일 EEEE', 'ko');
              final chatDocs = snapshot.data![index];
              final isDayPassed = (time == null || (chatDocs.timeSent.toDate().day > time!.day));
              time = chatDocs.timeSent.toDate();
              final DateTime date = chatDocs.timeSent.toDate();
              final showTime = timeFormat.format(date);
              if (chatDocs.senderId == FirebaseAuth.instance.currentUser!.uid) {
                if (chatDocs.type == MessageEnum.location) {
                  return BubbleWtihDayBreak(
                      showTime: showTime,
                      isDayPassed: isDayPassed,
                      chatDocs: chatDocs,
                      message: LocationItem(
                        locationImageString: chatDocs.text,
                        timeSent: chatDocs.timeSent,
                        coordinates: Coords(chatDocs.lat!, chatDocs.long!),
                      ));
                } else {
                  return BubbleWtihDayBreak(
                      showTime: showTime,
                      chatDocs: chatDocs,
                      isDayPassed: isDayPassed,
                      message: MyChatBubble(
                          text: chatDocs.text, timeSent: chatDocs.timeSent, type: chatDocs.type));
                }
              }
              return BubbleWtihDayBreak(
                  showTime: showTime,
                  chatDocs: chatDocs,
                  isDayPassed: isDayPassed,
                  message: PeerChatBubble(
                      text: chatDocs.text, timeSent: chatDocs.timeSent, type: chatDocs.type));
            },
          );
        });
  }
}

class BubbleWtihDayBreak extends StatelessWidget {
  const BubbleWtihDayBreak({
    Key? key,
    required this.showTime,
    required this.chatDocs,
    required this.message,
    required this.isDayPassed,
  }) : super(key: key);

  final String showTime;
  final ChatMessageModel chatDocs;
  final bool isDayPassed;
  final Widget message;

  @override
  Widget build(BuildContext context) {
    return isDayPassed
        ? Column(
            children: [
              const SizedBox(height: 20),
              Center(
                  child: Text(
                showTime,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              )),
              message,
            ],
          )
        : message;
  }
}
