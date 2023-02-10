import 'package:disko_001/features/chat/widgets/chat_list.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/common_app_bar.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: '채팅',
        appBar: AppBar(),
      ),
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
