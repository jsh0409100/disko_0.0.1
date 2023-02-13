import 'package:disko_001/common/enums/notification_enum.dart';
import 'package:disko_001/features/notification/widgets/custom_comment_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/utils.dart';
import '../../../common/widgets/loading_screen.dart';
import '../../../models/notification_model.dart';
import '../controller/notification_controller.dart';
import '../widgets/custom_liked_notification.dart';

class NotificationTap extends ConsumerStatefulWidget {
  const NotificationTap({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationTap> createState() => _NotificationTapState();
}

class _NotificationTapState extends ConsumerState<NotificationTap> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "알림",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            centerTitle: true,
            bottom: const TabBar(
              labelColor: Colors.black,
              indicatorColor: Color(0xFF5E38EB),
              tabs: <Widget>[
                Tab(
                  icon: Text(
                    "활동 알림",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  icon: Text(
                    "방명록 알림",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              StreamBuilder<List<NotificationModel>>(
                  stream: ref
                      .read(notificationControllerProvider)
                      .notificationStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LoadingScreen();
                    }
                    if (!snapshot.hasData) return Container();
                    final notificationDocs = snapshot.data!;
                    return ListView.builder(
                        itemCount: notificationDocs.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder(
                              future: getPostByPostId(
                                  notificationDocs[index].postId),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData == false) {
                                  return Card(
                                    color: Colors.grey.shade300,
                                    child: Column(children: [
                                      SizedBox(
                                        height: 70,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                      ),
                                      const SizedBox(
                                        height: 11,
                                      )
                                    ]),
                                  );
                                }
                                return notificationDocs[index]
                                            .notificationType ==
                                        NotificationEnum.comment
                                    ? CustomCommentNotification(
                                        notification: notificationDocs[index],
                                      )
                                    : CustomLikedNotification(
                                        notification: notificationDocs[index],
                                      );
                              });
                        });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
