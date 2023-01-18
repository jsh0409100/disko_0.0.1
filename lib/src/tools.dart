import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> getPeerDisplayName(String peerUid) async {
  var peerDoc =
      await FirebaseFirestore.instance.collection('users').doc(peerUid).get();
  return peerDoc.data()!['displayName'];
}
