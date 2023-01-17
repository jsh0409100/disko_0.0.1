import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble(this.message, this.isSender, {Key? key}) : super(key: key);

  final String message;
  final bool isSender;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isSender
                ? Theme.of(context).colorScheme.primary
                : const Color(0xFFECECEC),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(
            message,
            style: TextStyle(
                color: isSender
                    ? Theme.of(context).colorScheme.onPrimary
                    : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 14),
          ),
        ),
      ],
    );
  }
}
