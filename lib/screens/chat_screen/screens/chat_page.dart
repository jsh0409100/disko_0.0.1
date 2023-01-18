import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../widgets/chat_message.dart';
import '../widgets/send_message.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  var arguments = Get.arguments;
  var currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    String peerUid = arguments['peerUid'];
    String peerDisplayName = arguments['peerDisplayName'];
    final String chatName = (peerUid.compareTo(currentUserUid) > 0)
        ? peerUid + '-' + currentUserUid
        : currentUserUid + '-' + peerUid;
    final String collectionPath = 'messages/' + chatName + '/' + chatName;
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
              Text(
                peerDisplayName,
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
              chatName: chatName,
              receiverUid: peerUid,
            ),
          ],
        )));
  }
}
