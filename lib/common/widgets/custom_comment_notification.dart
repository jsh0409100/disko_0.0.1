import 'package:flutter/material.dart';

class CustomCommentNotification extends StatelessWidget {
  const CustomCommentNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Stack(children: [
            const CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage("assets/user.png"),
            ),
            Positioned(
              left: 35,
              child: Padding(
                padding: const EdgeInsets.only(top: 35),
                child: Icon(
                  Icons.chat_bubble,
                  size: 15,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            )
          ]),
          const SizedBox(width: 15),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("---가 ----에 댓글을 남겼어요!"),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "---분 전",
                style: TextStyle(color: Colors.grey, fontSize: 8),
              ),
            ],
          ),
        ],
      ),
    );
  }
}