import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/screens/chat_screen/chat_list_page.dart';
import 'package:disko_001/screens/home_screen/profile_page.dart';
import 'package:disko_001/screens/search_screen/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'home_feed_page.dart';
import 'notification.dart';

class MyHome extends ConsumerStatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  MyHomeState createState() => MyHomeState();
}

class MyHomeState extends ConsumerState<MyHome> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int _selectedIndex = 0;
  final pages = [
    HomeFeedPage(),
    const ChatListPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final _authState = ref.watch(authStateProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '이스라엘',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const search());
            },
            icon: const Icon(
              Icons.search_outlined,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => const NotificationTap());
            },
            icon: const Icon(
              Icons.notifications_none_outlined,
              color: Colors.black,
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
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
