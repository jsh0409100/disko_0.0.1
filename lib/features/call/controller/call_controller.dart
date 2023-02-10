import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../models/call.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/call_repository.dart';

final callControllerProvider = Provider((ref) {
  final callRepository = ref.read(callRepositoryProvider);
  return CallController(
    callRepository: callRepository,
    auth: FirebaseAuth.instance,
    ref: ref,
  );
});

class CallController {
  final CallRepository callRepository;
  final ProviderRef ref;
  final FirebaseAuth auth;
  CallController({
    required this.callRepository,
    required this.ref,
    required this.auth,
  });

  Stream<DocumentSnapshot> get callStream => callRepository.callStream;

  void makeCall(BuildContext context, String receiverName, String receiverUid,
      String receiverProfilePic) {
    ref.read(userDataAuthProvider).whenData((value) {
      String callId = const Uuid().v1();
      Call senderCallData = Call(
        callerId: auth.currentUser!.uid,
        callerName: value!.displayName,
        callerPic: value.profilePic,
        receiverUid: receiverUid,
        receiverName: receiverName,
        receiverPic: receiverProfilePic,
        token: '',
        callId: callId,
        hasDialed: true,
      );

      Call receiverCallData = Call(
        callerId: auth.currentUser!.uid,
        callerName: value.displayName,
        callerPic: value.profilePic,
        receiverUid: receiverUid,
        receiverName: receiverName,
        receiverPic: receiverProfilePic,
        token: '',
        callId: callId,
        hasDialed: false,
      );
      callRepository.makeCall(senderCallData, context, receiverCallData);
    });
  }

  void setToken(String token, Call call) {
    ref.read(callRepositoryProvider).setToken(token, call);
  }

  void endCall(
    String callerId,
    String receiverUid,
    BuildContext context,
  ) {
    callRepository.endCall(callerId, receiverUid, context);
  }
}
//
