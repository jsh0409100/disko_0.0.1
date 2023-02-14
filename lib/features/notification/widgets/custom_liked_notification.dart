import 'package:disko_001/common/utils/utils.dart';
import 'package:disko_001/models/post_card_model.dart';
import 'package:flutter/material.dart';

import '../../../models/notification_model.dart';

class CustomLikedNotification extends StatelessWidget {
  final NotificationModel notification;
  final PostCardModel post;
  const CustomLikedNotification({Key? key, required this.notification, required this.post})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserDataByUid(notification.peerUid),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return Card(
              color: Colors.grey.shade300,
              child: Column(children: [
                SizedBox(
                  height: 70,
                  width: MediaQuery.of(context).size.width * 0.9,
                ),
                const SizedBox(
                  height: 11,
                )
              ]),
            );
          }
          return Container(
            color: notification.seen
                ? Theme.of(context).colorScheme.onPrimary
                : const Color(0x0fff4eff),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Stack(children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(snapshot.data.profilePic),
                  ),
                  const Positioned(
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
                  children: [
                    RichText(
                        text: TextSpan(
                            style: const TextStyle(
                                fontSize: 17, color: Colors.black), //apply style to all
                            children: [
                          TextSpan(
                              text: '${snapshot.data.displayName}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                          const TextSpan(text: '가 '),
                          TextSpan(
                              text: post.postTitle,
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(text: '글을 좋아합니다.'),
                        ])),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      readTimestamp(notification.time),
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
