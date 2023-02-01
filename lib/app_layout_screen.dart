import 'package:disko_001/features/chat/screens/chat_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import 'features/home/screens/home_feed_page.dart';
import 'features/home/screens/notification.dart';
import 'features/profile/screens/my_profile_page.dart';
import 'features/search/screens/search.dart';

class AppLayoutScreen extends ConsumerStatefulWidget {
  static const String routeName = '/my-home';
  const AppLayoutScreen({Key? key}) : super(key: key);

  @override
  MyHomeState createState() => MyHomeState();
}

class MyHomeState extends ConsumerState<AppLayoutScreen> {
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
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
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
