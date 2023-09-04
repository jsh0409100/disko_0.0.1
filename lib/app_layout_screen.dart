import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/features/chat/screens/chat_list_screen.dart';
import 'package:disko_001/features/chat/screens/chat_screen.dart';
import 'package:disko_001/features/home/screens/detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../common/utils/local_notification.dart';
import 'features/home/screens/home_feed_page.dart';
import 'features/profile/screens/my_profile_page.dart';
import 'main.dart';
import 'models/user_model.dart';

class AppLayoutScreen extends StatefulWidget {
  final UserModel user;
  static const String routeName = '/my-home';
  const AppLayoutScreen({Key? key, required this.user}) : super(key: key);
  @override
  MyHomeState createState() => MyHomeState();
}

class MyHomeState extends State<AppLayoutScreen> {
  late final NotificationService notificationService;
  String? mtoken = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  int _selectedIndex = 0;

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: android.smallIcon,
              ),
            ));
      }
    });
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'post') {
      Navigator.pushNamed(
        context,
        DetailPage.routeName,
        arguments: {'postId': message.data['postId']},
      );
    }

    if (message.data['type'] == 'chat') {
      Navigator.pushNamed(
        context,
        ChatScreen.routeName,
        arguments: {'peerUid': message.data['senderId'], 'user': widget.user},
      );
    }
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print('Token : $mtoken');
      });
      saveToken(token!);
    });
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection("userTokens")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'token': token,
    });
  }

  void listenToNotificationStream() => notificationService.behaviorSubject.listen((payload) {
        Map<String, dynamic> notification = jsonDecode(payload!);
        switch (notification['type']) {
          case 'post':
            Navigator.pushNamed(
              context,
              DetailPage.routeName,
              arguments: {'postId': notification['postId']},
            );
            break;
          case 'chat':
            Navigator.pushNamed(
              context,
              ChatScreen.routeName,
              arguments: {
                'peerUid': notification['senderId'],
                'user': widget.user,
              },
            );
        }
      });

  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    requestPermission();
    getToken();
    notificationService = NotificationService();
    listenToNotificationStream();
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeFeedPage(),
      ChatListPage(user: widget.user),
      const MyProfilePage(),
    ];
    return Scaffold(
        body: PageView(
          controller: pageController,
          children: pages,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          onTap: (index) {
            pageController.jumpToPage(index);
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined),
              label: '채팅',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: '내정보',
            ),
          ],
        ));
  }
}
