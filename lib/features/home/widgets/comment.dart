import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    return Row(
      children: [
        const SizedBox(width: 15),
        Container(
          height: 36,
          width: 36,
          decoration: const BoxDecoration(
              color: Color(0xffD9D9D9), shape: BoxShape.circle),
        ),
        const SizedBox(width: 14),
        Column(
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
                const SizedBox(width: 5),
                Text(
                  widget.time.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              widget.text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(width: 120),
        Row(
          children: [
            Column(
              children: [
                IconButton(
                  onPressed: () {
                  },
                  icon: const Icon(Icons.chat_bubble_outline),
                  iconSize: 24,
                ),
                const Text('0'),
              ],
            ),
            const SizedBox(width: 5),
            Column(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border_outlined),
                  iconSize: 24,
                ),
                const Text('0'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
