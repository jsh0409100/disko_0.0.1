import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/models/notification_model.dart';
import 'package:disko_001/models/post_card_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../common/enums/country_enum.dart';
import '../../../common/enums/notification_enum.dart';
import '../../../common/utils/utils.dart';
import '../../../models/comment_model.dart';
import '../../../models/nestedcomment_model.dart';
import '../../../models/user_model.dart';

final postRepositoryProvider = Provider(
  (ref) => PostRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    user: ref.watch(userDataProvider),
  ),
);

class PostRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final UserDataModel user;

  PostRepository({
    required this.firestore,
    required this.auth,
    required this.user,
  });

  Stream<List<CommentModel>> getCommentStream(String postId) {
    final String collectionPath =
        'posts/${countries[user.countryCode]}/${countries[user.countryCode]}/$postId/comment';

    return firestore.collection(collectionPath).orderBy('time').snapshots().map((event) {
      List<CommentModel> comment = [];
      for (var document in event.docs) {
        comment.add(CommentModel.fromJson(document.data()));
      }
      return comment;
    });
  }

  Stream<List<NestedCommentModel>> getNestedCommentStream(String postId, String commentId) {
    final String collectionPath =
        'posts/${countries[user.countryCode]}/${countries[user.countryCode]}/$postId/comment/$commentId/nestedcomment';

    return firestore.collection(collectionPath).orderBy('time').snapshots().map((event) {
      List<NestedCommentModel> nestedcomment = [];
      for (var document in event.docs) {
        nestedcomment.add(NestedCommentModel.fromJson(document.data()));
      }
      return nestedcomment;
    });
  }

  void _saveComment({
    required String userName,
    required String text,
    required Timestamp time,
    required String uid,
    required List<String> likes,
    required String commentId,
    required String postId,
  }) async {
    final comment = CommentModel(
      userName: userName,
      text: text,
      time: time,
      uid: uid,
      likes: likes,
      commentId: commentId,
      commentCount: 0,
      postId: postId,
    );
    print("댓글 올림");
    return firestore.collection('posts')
        .doc(countries[user.countryCode])
        .collection(countries[user.countryCode]!)
        .doc(postId)
        .collection('comment')
        .doc(commentId)
        .set(
          comment.toJson(),
        );
  }

  void _saveCommentCount({
    required String text,
    required Timestamp time,
    required String postId,
    required String username,
    required String postTitle,
    required List<String> imagesUrl,
    required List<String> likes,
    required String category,
    required bool isAnnouncement,
  }) async {
    final comment = PostCardModel(
      time: time,
      userName: username,
      postTitle: postTitle,
      postText: text,
      uid: auth.currentUser!.uid,
      likes: [],
      imagesUrl: [],
      postId: '',
      commentCount: 0,
      isQuestion: false,
      category: category,
      isAnnouncement: isAnnouncement,
    );

    final currentComment = firestore
        .collection('posts')
        .doc(countries[user.countryCode])
        .collection(countries[user.countryCode]!)
        .doc(postId);
    final doc = await currentComment.get();

    if (doc.exists) {
      final data = doc.get('postId');
      (data == postId)
          ? currentComment.update({
              'commentCount': FieldValue.increment(1),
            })
          : currentComment.set(comment.toJson());
    } else {
      currentComment.set(comment.toJson());
    }
  }

  void _saveNestedComment({
    required String userName,
    required String text,
    required Timestamp time,
    required String uid,
    required List<String> likes,
    required String commentId,
    required String postId,
    required String nestedcommentId,
  }) async {
    final comment = NestedCommentModel(
      userName: userName,
      text: text,
      time: time,
      uid: uid,
      likes: likes,
      commentId: commentId,
      nestedcommentId: nestedcommentId,
    );
    return firestore
        .collection('posts')
        .doc(countries[user.countryCode])
        .collection(countries[user.countryCode]!)
        .doc(postId)
        .collection('comment')
        .doc(commentId)
        .collection('nestedcomment')
        .doc(nestedcommentId)
        .set(
          comment.toJson(),
        );
  }

  void deletePost(postId) async {
    firestore.collection('posts').doc(countries[user.countryCode]).collection(countries[user.countryCode]!).doc(postId).delete();
  }

  void _saveNestedCommentCount({
    required String text,
    required Timestamp time,
    required String postId,
    required String username,
    required String postTitle,
    required List<String> likes,
    required String commentId,
    required String category,
    required bool isAnnouncement,
  }) async {
    final comment = PostCardModel(
      time: time,
      userName: username,
      postTitle: postTitle,
      postText: text,
      uid: auth.currentUser!.uid,
      likes: [],
      imagesUrl: [],
      postId: '',
      commentCount: 0,
      isQuestion: false,
      category: category,
      isAnnouncement: isAnnouncement,
    );

    final currentComment =
        firestore.collection('posts')
            .doc(countries[user.countryCode])
            .collection(countries[user.countryCode]!)
            .doc(postId)
            .collection('comment')
            .doc(commentId);
    final doc = await currentComment.get();

    if (doc.exists) {
      final data = doc.get('commentId');
      (data == commentId)
          ? currentComment.update({
              'commentCount': FieldValue.increment(1),
            })
          : currentComment.set(comment.toJson());
    } else {
      currentComment.set(comment.toJson());
    }
  }

  void uploadComment({
    required BuildContext context,
    required String text,
    required UserDataModel senderUser,
    required postId,
    required List<String> imagesUrl,
    required List<String> likes,
  }) async {
    try {
      var time = Timestamp.now();
      var commentId = const Uuid().v1();
      var post = await getPostByPostId(senderUser, postId);
      _saveComment(
        userName: senderUser.displayName,
        text: text,
        commentId: commentId,
        time: time,
        uid: auth.currentUser!.uid,
        likes: [],
        postId: postId,
      );

      _saveCommentCount(
        text: text,
        time: time,
        postId: postId,
        username: senderUser.displayName,
        postTitle: post.postTitle,
        imagesUrl: imagesUrl,
        likes: likes,
        category: post.category,
        isAnnouncement: post.isAnnouncement,
      );

      saveNotification(
          postId: postId,
          peerUid: post.uid,
          postTitle: post.postTitle,
          time: time,
          notificationType: NotificationEnum.comment,
          commentId: commentId);
    } catch (e) {
      // showSnackBar(context: context, content: e.toString());
    }
  }

  void uploadNestedComment({
    required BuildContext context,
    required String text,
    required UserDataModel senderUser,
    required postId,
    required commentId,
    required List<String> likes,
  }) async {
    try {
      var time = Timestamp.now();
      var nestedcommentId = const Uuid().v1();
      var post = await getPostByPostId(senderUser, postId);
      _saveNestedComment(
        userName: senderUser.displayName,
        text: text,
        commentId: commentId,
        time: time,
        uid: auth.currentUser!.uid,
        likes: [],
        postId: postId,
        nestedcommentId: nestedcommentId,
      );

      _saveNestedCommentCount(
        text: text,
        time: time,
        postId: postId,
        username: senderUser.displayName,
        postTitle: post.postTitle,
        likes: likes,
        commentId: commentId,
        category: post.category,
        isAnnouncement: post.isAnnouncement,
      );

      saveNotification(
          postId: postId,
          peerUid: post.uid,
          postTitle: post.postTitle,
          time: time,
          notificationType: NotificationEnum.comment,
          commentId: commentId);
    } catch (e) {
      // showSnackBar(context: context, content: e.toString());
    }
  }

  void toggleAnnouncement({required String postId}) async {
    final currentPost = firestore
        .collection('posts')
        .doc(countries[user.countryCode])
        .collection(countries[user.countryCode]!)
        .doc(postId);
    final doc = await currentPost.get();

    final data = doc.get('isAnnouncement');
    (data == true)
        ? currentPost.update({
            'isAnnouncement': false,
          })
        : currentPost.update({
            'isAnnouncement': true,
          });
  }

  void saveNotification({
    required String postId,
    required String peerUid,
    required String commentId,
    required String postTitle,
    required Timestamp time,
    required NotificationEnum notificationType,
  }) async {
    final notification = NotificationModel(
      commentId: commentId,
      peerUid: auth.currentUser!.uid,
      time: time,
      notificationType: notificationType,
      postId: postId,
      postTitle: postTitle,
      seen: false,
    );
    bool sendable = true;
    final String notificationId = (notificationType == NotificationEnum.like) ? 'like' : commentId;
    final String docName = '$postId&${auth.currentUser!.uid}&$notificationId';

    final docRef =
        firestore.collection('users').doc(peerUid).collection('notification').doc(docName);
    final doc = await docRef.get();

    if (doc.exists) {
      sendable = false;
    }

    if (sendable && peerUid != auth.currentUser!.uid) await docRef.set(notification.toJson());
  }
}
