import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Comment extends StatefulWidget {
  final String userName, text, uid;
  final List<String> likes;
  final Timestamp time;

  const Comment({
    Key? key,
    required this.uid,
    required this.userName,
    required this.text,
    required this.likes,
    required this.time,
  }) : super(key: key);

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    final DateTime date = widget.time.toDate();
    final timeFormat = DateFormat('yy.MM.dd aa hh:mm', 'ko');
    final showTime = timeFormat.format(date);
    return SizedBox(
      height: 100,
      child: Row(
        children: [
          const SizedBox(width: 10),
          SizedBox(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.userName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(showTime),
                  ],
                ),
                Text(
                  widget.text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                          },
                          icon: const Icon(Icons.favorite_border_outlined),
                          iconSize: 24,
                        ),
                        const Text('0'),
                      ],
                    ),
                    const SizedBox(width: 5),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.chat_outlined),
                          iconSize: 24,
                        ),
                        const Text('0'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert),
        ],
      ),
    );
  }
}
