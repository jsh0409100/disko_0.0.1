import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/features/chat/screens/chat_list_screen.dart';
import 'package:disko_001/features/chat/screens/chat_screen.dart';
import 'package:disko_001/features/home/screens/detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/local_notification.dart';
import 'common/widgets/error_screen.dart';
import 'common/widgets/loading_screen.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/home/screens/home_feed_page.dart';
import 'features/profile/screens/my_profile_page.dart';
import 'main.dart';

class AppLayoutScreen extends ConsumerStatefulWidget {
  static const String routeName = '/my-home';

  const AppLayoutScreen({Key? key}) : super(key: key);

  @override
  MyHomeState createState() => MyHomeState();
}

class MyHomeState extends ConsumerState<AppLayoutScreen> {
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
        arguments: {'peerUid': message.data['senderId']},
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
      const HomeFeedPage(isLoading: false, LoadingVisible: false),
      const ChatListPage(),
      const MyProfilePage(),
    ];
    // return ref.refresh(userDataAuthProvider).when(
    //       data: (user) {
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
                      icon: Icon(Icons.home_rounded),
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
          // },
          // error: (err, trace) {
          //   return ErrorScreen(
          //     error: err.toString(),
          //   );
          // },
          // loading: () => const LoadingScreen(),
        // );
  }
}
