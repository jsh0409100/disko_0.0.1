import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/features/chat/screens/chat_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'features/home/screens/home_feed_page.dart';
import 'features/profile/screens/my_profile_page.dart';

class AppLayoutScreen extends StatefulWidget {
  static const String routeName = '/my-home';
  const AppLayoutScreen({Key? key}) : super(key: key);
  @override
  MyHomeState createState() => MyHomeState();
}

class MyHomeState extends State<AppLayoutScreen> {
  String? mtoken = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  final pages = [
    HomeFeedPage(),
    const ChatListPage(),
    const MyProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    requestPermission();
    getToken();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: '???',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            label: '??????',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '?????????',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}
