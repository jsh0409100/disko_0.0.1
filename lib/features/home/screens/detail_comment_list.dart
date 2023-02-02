import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/material.dart';

class DetailCommentList extends StatefulWidget {
  final String username, reply;
  final List<String> like;
  final Timestamp time;

  const DetailCommentList({
    Key? key,
    // required this.uid,
    required this.username,
    required this.reply,
    required this.like,
    required this.time,
  }) : super(key: key);

  @override
  State<DetailCommentList> createState() => _DetailCommentListState();
}

class _DetailCommentListState extends State<DetailCommentList> {
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
                  widget.username,
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
              widget.reply,
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
