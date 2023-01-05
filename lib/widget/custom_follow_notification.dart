import 'package:flutter/material.dart';

class CustomFollowNotification extends StatefulWidget {
  const CustomFollowNotification({Key? key}) : super(key: key);

  @override
  State<CustomFollowNotification> createState() => _CustomFollowNotificationState();
}

class _CustomFollowNotificationState extends State<CustomFollowNotification> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Stack(children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage("assets/user.png"),
            ),
            Positioned(
              left: 35,
              child: Padding(
                padding: EdgeInsets.only(top: 35),
                child: Icon(Icons.folder, size: 15),
              ),
            )
          ]),
          const SizedBox(width: 15),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("---가 팔로우했어요!"),
              SizedBox(
                height: 10,
              ),
              Text(
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
