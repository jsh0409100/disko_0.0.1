import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> getPeerDisplayName(String peerUid) async {
  var peerDoc =
      await FirebaseFirestore.instance.collection('users').doc(peerUid).get();
  return peerDoc.data()!['displayName'];
}

Future<void> resetUnreadMessageCount(String chatName) async {
  final currentChat =
      FirebaseFirestore.instance.collection('messages').doc(chatName);
  await currentChat.update({"unreadMessageCount": 0});
}
