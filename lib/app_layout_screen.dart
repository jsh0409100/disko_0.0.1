import 'package:disko_001/features/chat/screens/chat_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  FirebaseAuth auth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  final pages = [
    HomeFeedPage(),
    const ChatListPage(),
    const MyProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}
