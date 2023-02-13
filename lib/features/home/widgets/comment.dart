import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Comment extends StatefulWidget {
  final String userName, text, uid, profilePic;
  final List<String> likes;
  final Timestamp time;

  const Comment({
    Key? key,
    required this.uid,
    required this.userName,
    required this.text,
    required this.likes,
    required this.time,
    required this.profilePic,
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
                    ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image(
                          image: NetworkImage(widget.profilePic),
                          height: 36,
                          width: 36,
                          fit: BoxFit.scaleDown,
                        )),
                    const SizedBox(width: 8),
                    Column(
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
                            const SizedBox(width: 5),
                            Text(
                              showTime,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.text,
                          style: const TextStyle(
                            fontSize: 15,
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
                                  iconSize: 20,
                                ),
                                const Text(
                                  '0',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 5),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.chat_outlined),
                                  iconSize: 20,
                                ),
                                const Text(
                                  '0',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
