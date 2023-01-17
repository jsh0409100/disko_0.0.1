import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/chat_message.dart';
import '../widgets/send_message.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final String collectionPath =
      "messages/lW7UMru6UQU2HaBj6Mg67Cl3Fu63-tsaNdyJcfFY6HhUtr1ypXTC8pzB2/lW7UMru6UQU2HaBj6Mg67Cl3Fu63-tsaNdyJcfFY6HhUtr1ypXTC8pzB2";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/user.png',
                width: 28,
              ),
              const SizedBox(
                width: 6,
              ),
              const Text(
                "나는야 아창 똑순이",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
            ),
          ],
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
            child: Column(
          children: [
            Expanded(
                child: ChatMessage(
              collectionPath: collectionPath,
            )),
            SendMessage(
              collectionPath: collectionPath,
            ),
          ],
        )));
  }
}
