import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/utils.dart';
import '../../../models/call.dart';
import '../screens/call_screen.dart';

final callRepositoryProvider = Provider(
  (ref) => CallRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class CallRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  CallRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<DocumentSnapshot> get callStream =>
      firestore.collection('call').doc(auth.currentUser!.uid).snapshots();

  void makeCall(
    Call senderCallData,
    BuildContext context,
    Call receiverCallData,
  ) async {
    try {
      await firestore
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toJson());
      await firestore
          .collection('call')
          .doc(senderCallData.receiverUid)
          .set(receiverCallData.toJson());

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(
            channelId: senderCallData.callId,
            call: senderCallData,
          ),
        ),
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void endCall(
    String callerId,
    String receiverUid,
    BuildContext context,
  ) async {
    try {
      await firestore.collection('call').doc(receiverUid).delete();
      await firestore.collection('call').doc(callerId).delete();
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void setToken(String token, Call call) async {
    await firestore
        .collection('call')
        .doc(call.callerId)
        .update({'token': token});
    await firestore
        .collection('call')
        .doc(call.receiverUid)
        .update({'token': token});
  }
}
