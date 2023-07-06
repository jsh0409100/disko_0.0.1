import 'package:disko_001/common/utils/utils.dart';
import 'package:disko_001/features/notification/controller/notification_controller.dart';
import 'package:disko_001/models/post_card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../../models/notification_model.dart';
import '../../home/screens/detail_page.dart';
import '../../home/widgets/post_card.dart';

class CustomCommentNotification extends ConsumerWidget {
  final NotificationModel notification;
  final PostCardModel post;
  const CustomCommentNotification({Key? key, required this.notification, required this.post})
      : super(key: key);

  void checkNotification(PostCardModel post, WidgetRef ref) {
    Get.to(
      () => const DetailPage(),
      arguments: PostCard(
        postCategory: post.postCategory,
        postTitle: post.postTitle,
        postText: post.postText,
        uid: post.uid,
        likes: post.likes,
        imagesUrl: post.imagesUrl,
        postId: post.postId,
        time: post.time,
        commentCount: post.commentCount,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!notification.seen) {
      ref.read(notificationControllerProvider).markNotificationAsSeen(notification);
    }
    return GestureDetector(
      onTap: () => checkNotification(post, ref),
      child: FutureBuilder(
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
              padding: const EdgeInsets.all(14),
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.76,
                        child: RichText(
                            text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.black), //apply style to all
                                children: [
                              TextSpan(
                                  text: '${snapshot.data.displayName}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                              const TextSpan(text: '님이 '),
                              TextSpan(
                                  text: notification.postTitle,
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                              const TextSpan(text: '글에 댓글을 남겼습니다.'),
                            ])),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        readTimestamp(notification.time),
                        style: const TextStyle(color: Colors.grey, fontSize: 8),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
