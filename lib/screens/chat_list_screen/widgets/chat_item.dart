import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../chat_screen/screens/chat_page.dart';

class ChatItem extends StatefulWidget {
  final String name, peerUid;
  final String messageText;
  // final String imageUrl;
  final Timestamp time;
  final int unreadMessageCount;

  const ChatItem(
      {Key? key,
      required this.name,
      required this.messageText,
      required this.time,
      required this.unreadMessageCount,
      required this.peerUid})
      : super(key: key);

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    final DateTime date = widget.time.toDate();
    final timeFormat = DateFormat.jm();
    final showTime = timeFormat.format(date);
    return GestureDetector(
      onTap: () {
        Get.to(() => const ChatPage(), arguments: {
          'peerUid': widget.peerUid,
          'peerDisplayName': widget.name
        });
      },
      child: Container(
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: Color(0xFF767676),
          width: 0.2,
        ))),
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.92,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: const Image(
                    image: NetworkImage(
                        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                    height: 43,
                    width: 43,
                    fit: BoxFit.scaleDown,
                  )),
              const SizedBox(
                width: 11,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          showTime,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.messageText,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF767676)),
                        ),
                        Visibility(
                          visible: (widget.unreadMessageCount != 0),
                          child: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            radius: 15,
                            child: Text(
                              widget.unreadMessageCount.toString(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
