import 'package:disko_001/features/call/screens/call_pickup_screen.dart';
import 'package:disko_001/features/chat/controller/chat_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/utils.dart';
import '../../../common/widgets/loading_screen.dart';
import '../widgets/bottom_chat_field.dart';
import '../widgets/message_list.dart';

class ChatScreen extends ConsumerStatefulWidget {
  static const String routeName = '/chat-screen';
  final String peerUid;
  const ChatScreen({
    Key? key,
    required this.peerUid,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatScreen> {
  var currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  @override
  void dispose() {
    super.dispose();
    // print('user left chat');
    // ref.read(chatControllerProvider).toggleUserOnline(context, currentUserUid);
  }

  @override
  Widget build(BuildContext context) {
    ref.read(chatControllerProvider).setChatMessageSeen(context, widget.peerUid);
    return FutureBuilder(
        future: getUserDataByUid(widget.peerUid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LoadingScreen();
          }
          return CallPickupScreen(
            scaffold: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data!.profilePic),
                          radius: 20,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          snapshot.data!.displayName,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
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
                        profilePic: snapshot.data!.profilePic,
                        receiverDisplayName: snapshot.data!.displayName,
                      ),
                    ],
                  )),
            ),
          );
        });
  }
}
