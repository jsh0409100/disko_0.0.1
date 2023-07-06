import 'package:disko_001/common/widgets/loading_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/utils.dart';
import '../controller/chat_controller.dart';
import 'chat_item.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ref.read(chatControllerProvider).chatListStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        }
        if (!snapshot.hasData) return Container();
        final chatDocs = snapshot.data!;
        return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              bool currentIsSender = (chatDocs[index].senderId ==
                  FirebaseAuth.instance.currentUser!.uid);
              String peerUid = (currentIsSender)
                  ? chatDocs[index].receiverUid
                  : chatDocs[index].senderId;
              return FutureBuilder(
                  future: getUserDataByUid(peerUid),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData == false) {
                      return Card(
                        color: Colors.grey.shade300,
                        child: Column(children: [
                          SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.9,
                          ),
                          const SizedBox(
                            height: 11,
                          )
                        ]),
                      );
                    }
                    return ChatItem(
                      name: currentIsSender
                          ? snapshot.data.displayName
                          : chatDocs[index].senderDisplayName,
                      text: chatDocs[index].text,
                      profilePic: snapshot.data.profilePic,
                      peerUid: peerUid,
                      timeSent: chatDocs[index].timeSent,
                      unreadMessageCount: (currentIsSender)
                          ? 0
                          : chatDocs[index].unreadMessageCount,
                    );
                  });
            });
      },
    );
  }
}
