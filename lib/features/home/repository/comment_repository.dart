import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../common/utils/utils.dart';
import '../../../models/last_message_model.dart';
import '../../../models/reply_model.dart';
import '../../../models/user_model.dart';

final commentRepositoryProvider = Provider(
  (ref) => CommentRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class CommentRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  CommentRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<List<CommentModel>> getCommentStream(String postId) {
    final String collectionPath = 'posts/$postId/comment';

    return firestore
        .collection(collectionPath)
        .orderBy('time')
        .snapshots()
        .map((event) {
      List<CommentModel> comment = [];
      for (var document in event.docs) {
        comment.add(CommentModel.fromJson(document.data()));
      }
      return comment;
    });
  }

  Stream<List<LastMessageModel>> getCommentListStream() {
    return firestore
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<LastMessageModel> comments = [];
      for (var document in event.docs) {
        if (document.get('receiverUid') == auth.currentUser!.uid ||
            document.get('senderId') == auth.currentUser!.uid) {
          comments.add(LastMessageModel.fromJson(document.data()));
        }
      }
      return comments;
    });
  }

  void _saveComment({
    required String userName,
    required String text,
    required Timestamp time,
    required String uid,
    required List<String> likes,
    required String commentId,
  }) async {
    final comment = CommentModel(
      userName: userName,
      text: text,
      time: time,
      uid: uid,
      likes: likes,
    );
    final String postId = '7cd259c0-a368-11ed-9819-ddbd59478028';
    await firestore
        .collection('posts')
        .doc(postId)
        .collection('comment')
        .doc(commentId)
        .set(
      comment.toJson(),
    );
  }

  void uploadComment({
    required BuildContext context,
    required String text,
    required UserModel senderUser,
  }) async {
    try {
      var time = Timestamp.now();
      var commentId = const Uuid().v1();

      _saveComment(
        userName: senderUser.displayName,
        text: text,
        commentId: commentId,
        time: time,
        uid: auth.currentUser!.uid,
        likes: [],
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
