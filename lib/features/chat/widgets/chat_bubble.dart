import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/enums/message_enum.dart';
import 'display_text_image_gif.dart';

class MyChatBubble extends StatelessWidget {
  final MessageEnum type;
  final String text;
  final Timestamp timeSent;
  // final bool isUploading;

  const MyChatBubble({
    required this.text,
    required this.timeSent,
    required this.type,
    // required this.isUploading,
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
        DisplayTextImageGIF(
          isSender: true,
          message: text,
          type: type,
          // isUploading: isUploading,
        ),
      ],
    );
  }
}

class PeerChatBubble extends StatelessWidget {
  final MessageEnum type;
  final String text;
  final Timestamp timeSent;
  // final bool isUploading;

  const PeerChatBubble({
    required this.text,
    required this.timeSent,
    required this.type,
    // required this.isUploading,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime date = timeSent.toDate();
    final timeFormat = DateFormat('aa hh:mm', 'ko');
    final showTime = timeFormat.format(date);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        DisplayTextImageGIF(
          isSender: false,
          message: text,
          type: type,
          // isUploading: isUploading,
        ),
        Text('$showTime'),
      ],
    );
  }
}
