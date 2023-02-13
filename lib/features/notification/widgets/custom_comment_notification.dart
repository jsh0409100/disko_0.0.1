import 'package:disko_001/common/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../models/notification_model.dart';

class CustomCommentNotification extends StatelessWidget {
  final NotificationModel notification;
  const CustomCommentNotification({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var time = notification.time;
    return FutureBuilder(
        future: getUserDataByUid(notification.peerUid),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Stack(children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(snapshot.data.profilePic),
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
                    Text("${snapshot.data.displayName}가 ----에 댓글을 남겼어요!"),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "분 전",
                      style: TextStyle(color: Colors.grey, fontSize: 8),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
