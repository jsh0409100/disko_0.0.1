import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<String> getDisplayNameByUid(String Uid) async {
  var UserDoc =
      await FirebaseFirestore.instance.collection('users').doc(Uid).get();
  return UserDoc.data()!['displayName'];
}

Future<void> resetUnreadMessageCount(String chatName) async {
  final currentChat =
      FirebaseFirestore.instance.collection('messages').doc(chatName);
  await currentChat.update({"unreadMessageCount": 0});
}

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}
