import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/utils.dart';
import '../../../models/post_card_model.dart';
import '../../../models/user_model.dart';

final writePostRepositoryProvider = Provider(
  (ref) => WritePostRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class WritePostRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  WritePostRepository({
    required this.firestore,
    required this.auth,
  });

  void _savePost({
    required String text,
    required Timestamp time,
    required String postId,
    required String username,
    required String postCategory,
    required String postTitle,
    required List<String> imagesUrl,
    required List<String> likes,
    required int commentCount,
  }) async {
    final message = PostCardModel(
      uid: auth.currentUser!.uid,
      postText: text,
      time: time,
      userName: username,
      postCategory: postCategory,
      postTitle: postTitle,
      likes: likes,
      imagesUrl: imagesUrl,
      postId: postId,
      commentCount: commentCount,
    );

    await firestore.collection('posts').doc(postId).set(
          message.toJson(),
        );
  }

  void uploadPost({
    required BuildContext context,
    required String text,
    required UserModel userData,
    required String postCategory,
    required String postTitle,
    required List<String> imagesUrl,
    required String postId,
    required int commentCount,
  }) async {
    try {
      var time = Timestamp.now();

      _savePost(
        postId: postId,
        postCategory: postCategory,
        postTitle: postTitle,
        imagesUrl: imagesUrl,
        likes: [],
        text: text,
        time: time,
        username: userData.displayName,
        commentCount: commentCount,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<List<PostCardModel>> searchPost(String query) {
    return _posts
        .where(
      'postTitle',
      isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
      isLessThan: query.isEmpty
          ? null
          : query.substring(0, query.length - 1) +
          String.fromCharCode(
            query.codeUnitAt(query.length - 1) + 1,
          ),
    )
        .snapshots()
        .map((event) {
      List<PostCardModel> postcard = [];
      for (var post in event.docs) {
        postcard.add(PostCardModel.fromJson(post.data() as Map<String, dynamic>));
      }
      return postcard;
    });
  }

  Stream<List<PostCardModel>> searchMyPost(String query) {
    return _posts
        .where(
      'uid',
      isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
      isLessThan: query.isEmpty
          ? null
          : query.substring(0, query.length - 1) +
          String.fromCharCode(
            query.codeUnitAt(query.length - 1) + 1,
          ),
    )
        .snapshots()
        .map((event) {
      List<PostCardModel> postcard = [];
      for (var post in event.docs) {
        postcard.add(PostCardModel.fromJson(post.data() as Map<String, dynamic>));
      }
      return postcard;
    });
  }


  CollectionReference get _posts => firestore.collection('posts');
}
