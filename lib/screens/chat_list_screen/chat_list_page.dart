import 'package:disko_001/screens/chat_list_screen/widgets/chat_list.dart';
import 'package:flutter/material.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: const [
            Expanded(child: ChatList()),
          ],
        ),
      ),
    );
  }
}
