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
              bool currentIsSender = (chatDocs[index]['senderId'] ==
                  FirebaseAuth.instance.currentUser!.uid);
              String peerUid = (currentIsSender) ? 'receiverUid' : 'senderId';
              return FutureBuilder(
                  future: getDisplayNameByUid(chatDocs[index][peerUid]),
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
                      name: snapshot.data.toString(),
                      messageText: chatDocs[index]['message'],
                      peerUid: chatDocs[index][peerUid],
                      time: chatDocs[index]['time'],
                      unreadMessageCount: (currentIsSender)
                          ? 0
                          : chatDocs[index]['unreadMessageCount'],
                    );
                  });
            });
      },
    );
  }
}
