import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../src/tools.dart';
import 'chat_item.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('messages').snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = snapshot.data!.docs;
        return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              return FutureBuilder(
                  future: getPeerDisplayName(chatDocs[index]['receiverUid']),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData == false) {
                      return Center(child: CircularProgressIndicator());
                    }
                    bool currentIsSender = (chatDocs[index]['senderId'] ==
                        FirebaseAuth.instance.currentUser!.uid);
                    return ChatItem(
                      name: snapshot.data.toString(),
                      messageText: chatDocs[index]['message'],
                      peerUid: (currentIsSender)
                          ? chatDocs[index]['receiverUid']
                          : chatDocs[index]['senderUid'],
                      time: chatDocs[index]['time'],
                      unreadMessageCount: (currentIsSender)
                          ? 0
                          : chatDocs[index]['unreadMessageCount'],
                    );
                  });
              // unreadMessageCount: chatDocs[index]
              // (chatDocs[index]['senderId'].toString() == user!.uid)
              //   ? MyChatBubble(
              //   chatDocs[index]['message'], chatDocs[index]['time'])
              //   : PeerChatBubble(
              //   chatDocs[index]['message'], chatDocs[index]['time']);
            });
      },
    );
  }
}
