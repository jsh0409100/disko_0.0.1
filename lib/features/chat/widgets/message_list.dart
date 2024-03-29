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
  // final bool isUploading;

  const ChatMessage({
    super.key,
    required this.receiverUid,
    // required this.isUploading,
  });

  @override
  ConsumerState<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends ConsumerState<ChatMessage> with AutomaticKeepAliveClientMixin{
  final ScrollController messageController = ScrollController();

  void scrollToBottom() {
    if (messageController.hasClients) {
      messageController.animateTo(
        messageController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
            cacheExtent: 100000,
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
                      scrollToBottom: scrollToBottom,
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
                      scrollToBottom: scrollToBottom,
                      message: MyChatBubble(
                        text: chatDocs.text,
                        timeSent: chatDocs.timeSent,
                        type: chatDocs.type,
                        // isUploading: widget.isUploading,
                      ));
                }
              }
              return BubbleWtihDayBreak(
                  showTime: showTime,
                  chatDocs: chatDocs,
                  isDayPassed: isDayPassed,
                  scrollToBottom: scrollToBottom,
                  message: PeerChatBubble(
                    text: chatDocs.text,
                    timeSent: chatDocs.timeSent,
                    type: chatDocs.type,
                    // isUploading: widget.isUploading,
                  ));
              },
          );
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class BubbleWtihDayBreak extends StatelessWidget {
  const BubbleWtihDayBreak({
    Key? key,
    required this.showTime,
    required this.chatDocs,
    required this.message,
    required this.isDayPassed,
    required this.scrollToBottom,
  }) : super(key: key);

  final String showTime;
  final ChatMessageModel chatDocs;
  final bool isDayPassed;
  final Widget message;
  final Function() scrollToBottom;

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
