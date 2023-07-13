import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/enums/notification_enum.dart';
import '../../../models/comment_model.dart';
import '../../../models/nestedcomment_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/post_repository.dart';

final postControllerProvider = Provider((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  return PostController(
    postRepository: postRepository,
    ref: ref,
  );
});

class PostController {
  final PostRepository postRepository;
  final ProviderRef ref;
  PostController({
    required this.postRepository,
    required this.ref,
  });

  Stream<List<CommentModel>> commentStream(String postId) {
    return postRepository.getCommentStream(postId);
  }

  Stream<List<NestedCommentModel>> nestedcommentStream(String postId, String commentId) {
    return postRepository.getNestedCommentStream(postId, commentId);
  }

  void uploadComment(
    BuildContext context,
    String text,
    postId,
    List<String> imagesUrl,
    likes,
  ) {
    ref.read(userDataAuthProvider).whenData(
          (value) => postRepository.uploadComment(
            context: context,
            text: text,
            senderUser: value!,
            imagesUrl: imagesUrl,
            likes: likes,
            postId: postId,
          ),
        );
  }

  void uploadNestedComment(
    BuildContext context,
    String text,
    postId,
    commentId,
    likes,
  ) {
    ref.read(userDataAuthProvider).whenData(
          (value) => postRepository.uploadNestedComment(
            context: context,
            text: text,
            senderUser: value!,
            likes: likes,
            postId: postId,
            commentId: commentId,
          ),
        );
  }

  void saveNotification({
    required String postId,
    required String peerUid,
    required String postTitle,
    required Timestamp time,
    required NotificationEnum notificationType,
  }) {
    ref.read(userDataAuthProvider).whenData(
          (value) => postRepository.saveNotification(
            postTitle: postTitle,
            postId: postId,
            peerUid: peerUid,
            time: time,
            notificationType: notificationType,
            commentId: '',
          ),
        );
  }

  void deletePost({
    required String postId,
  }) {
    ref.read(userDataAuthProvider).whenData(
          (value) => postRepository.deletePost(postId),
        );
  }
}
