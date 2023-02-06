import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/enums/message_enum.dart';
import 'display_text_image_gif.dart';

class MyChatBubble extends StatelessWidget {
  final MessageEnum type;
  final String text;
  final Timestamp timeSent;

  const MyChatBubble({
    required this.text,
    required this.timeSent,
    required this.type,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime date = timeSent.toDate();
    final timeFormat = DateFormat('aa hh:mm', 'ko');
    final showTime = timeFormat.format(date);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(showTime),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.6,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: DisplayTextImageGIF(
              message: text,
              type: type,
            ),
          ),
        ),
      ],
    );
  }
}

class PeerChatBubble extends StatelessWidget {
  final MessageEnum type;
  final String text;
  final Timestamp timeSent;

  const PeerChatBubble({
    required this.text,
    required this.timeSent,
    required this.type,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime date = timeSent.toDate();
    final timeFormat = DateFormat.jm();
    final showTime = timeFormat.format(date);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFECECEC),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: DisplayTextImageGIF(
            message: text,
            type: type,
          ),
        ),
        Text('$showTime'),
      ],
    );
  }
}
