import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/chip_model.dart';

final profileRepositoryProvider = Provider(
  (ref) => ProfileRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ProfileRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ProfileRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<List<ChipModel>> getChipStream(List<String> chip) {
    return firestore.collection('users').snapshots().map((event) {
      List<ChipModel> tag = [];
      for (var document in event.docs) {
        tag.add(ChipModel.fromJson(document.data()));
      }
      return tag;
    });
  }

  void uploadChip({
    required BuildContext context,
    required List<String> tag,
  }) async {
    try {
      _saveChip(tag: tag);
    } catch (e) {
      // showSnackBar(context: context, content: e.toString());
    }
  }

  void _saveChip({
    required List<String> tag,
  }) async {
    final tagg = ChipModel(
      tag: tag,
    );
    final currentUser = firestore.collection('user').doc(auth.currentUser!.uid);
    final doc = await currentUser.get();

    if (doc.exists) {
      currentUser.update(tagg.toJson());
    }
  }

  void increaseDiskoPointFirebase({
    required int point,
  }) {
    final doc = firestore.collection('users').doc(auth.currentUser!.uid);

    doc.update({
      'diskoPoint': FieldValue.increment(point),
    });
  }

  void updateEmailFirebase({
    required String newEmail,
  }) {
    final doc = firestore.collection('users').doc(auth.currentUser!.uid);

    doc.update({
      'email': newEmail,
    });
  }

  void updateFolloe({required String uid}){

}
}
