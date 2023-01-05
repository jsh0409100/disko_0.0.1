import 'package:flutter/material.dart';

import '../Widget/custom_comment_notification.dart';
import '../Widget/custom_follow_notification.dart';
import '../Widget/custom_liked_notification.dart';

class NotificationTap extends StatefulWidget {
  const NotificationTap({Key? key}) : super(key: key);

  @override
  State<NotificationTap> createState() => _NotificationTapState();
}

class _NotificationTapState extends State<NotificationTap> {
  List New = ["liked", "comment"];
  List today = ["liked", "comment", "comment"];
  List oldest = ["follow", "comment", "follow", "comment", "follow"];
  List sNew = ["liked", "follow"];
  List sToday = ["liked", "follow", "follow"];
  List sOldest = ["follow", "liked", "follow", "liked", "follow"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("알림"),
            centerTitle: true,
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Text("활동 알림"),
                ),
                Tab(
                  icon: Text("중고거래 알림"),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "New",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: New.length,
                          itemBuilder: (context, index) {
                            return New[index] == "comment"
                                ? const CustomCommentNotification()
                                : const CustomLikedNotification();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "Today",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: today.length,
                          itemBuilder: (context, index) {
                            return today[index] == "comment"
                                ? const CustomCommentNotification()
                                : CustomLikedNotification();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "Oldest",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: oldest.length,
                          itemBuilder: (context, index) {
                            return oldest[index] == "comment"
                                ? const CustomCommentNotification()
                                : CustomLikedNotification();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "New",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: sNew.length,
                          itemBuilder: (context, index) {
                            return sNew[index] == "follow"
                                ? CustomFollowNotification()
                                : CustomLikedNotification();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "Today",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: sToday.length,
                          itemBuilder: (context, index) {
                            return sToday[index] == "follow"
                                ? CustomFollowNotification()
                                : CustomLikedNotification();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "Oldest",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: sOldest.length,
                          itemBuilder: (context, index) {
                            return sOldest[index] == "follow"
                                ? CustomFollowNotification()
                                : CustomLikedNotification();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
