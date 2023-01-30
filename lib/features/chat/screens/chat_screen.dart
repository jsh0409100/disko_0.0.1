import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/bottom_chat_field.dart';
import '../widgets/message_list.dart';

class ChatScreen extends ConsumerStatefulWidget {
  static const String routeName = '/chat-screen';
  final String peerUid, peerDisplayName;
  const ChatScreen({
    Key? key,
    required this.peerDisplayName,
    required this.peerUid,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatScreen> {
  var currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                  widget.peerDisplayName,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700),
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
          body: Column(
            children: [
              Expanded(
                  child: ChatMessage(
                receiverUid: widget.peerUid,
              )),
              BottomChatField(
                receiverUid: widget.peerUid,
              ),
            ],
          )),
    );
  }
}
