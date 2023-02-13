import 'package:flutter/material.dart';

import '../../../models/notification_model.dart';

class CustomLikedNotification extends StatelessWidget {
  final NotificationModel notification;
  const CustomLikedNotification({Key? key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Stack(children: const [
            CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage("assets/user.png"),
            ),
            Positioned(
              left: 35,
              child: Padding(
                padding: EdgeInsets.only(top: 35),
                child: Icon(
                  Icons.favorite,
                  size: 15,
                  color: Color(0xFFDB5D46),
                ),
              ),
            )
          ]),
          const SizedBox(width: 15),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("---가 공감을 눌럿어요!"),
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
