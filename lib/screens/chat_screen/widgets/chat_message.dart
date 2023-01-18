import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/screens/chat_screen/widgets/chat_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.collectionPath});
  final String collectionPath;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(collectionPath)
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = snapshot.data!.docs;
        return ListView.builder(
            reverse: true,
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              return (chatDocs[index]['senderId'].toString() == user!.uid)
                  ? MyChatBubble(
                      chatDocs[index]['message'], chatDocs[index]['time'])
                  : PeerChatBubble(
                      chatDocs[index]['message'], chatDocs[index]['time']);
            });
      },
    );
  }
}
