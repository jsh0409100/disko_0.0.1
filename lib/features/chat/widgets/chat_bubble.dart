import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyChatBubble extends StatelessWidget {
  const MyChatBubble({
    required this.text,
    required this.timeSent,
    Key? key,
  }) : super(key: key);

  final String text;
  final Timestamp timeSent;

  @override
  Widget build(BuildContext context) {
    final DateTime date = timeSent.toDate();
    final timeFormat = DateFormat.jm();
    final showTime = timeFormat.format(date);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('$showTime'),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(
            text,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class PeerChatBubble extends StatelessWidget {
  const PeerChatBubble({
    required this.text,
    required this.timeSent,
    Key? key,
  }) : super(key: key);

  final String text;
  final Timestamp timeSent;

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
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
        Text('$showTime'),
      ],
    );
  }
}
