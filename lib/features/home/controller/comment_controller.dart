import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/enums/message_enum.dart';
import '../../../models/last_message_model.dart';
import '../../../models/reply_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../repository/comment_repository.dart';

final commentControllerProvider = Provider((ref) {
  final commentRepository = ref.watch(CommentRepositoryProvider);
  return CommentController(
    commentRepository: commentRepository,
    ref: ref,
  );
});

class CommentController {
  final CommentRepository commentRepository;
  final ProviderRef ref;
  CommentController({
    required this.commentRepository,
    required this.ref,
  });

  Stream<List<CommentModel>> commentStream(String postId) {
    return commentRepository.getCommentStream(postId);
  }

  void uploadComment(
    BuildContext context,
    String text,
  ) {
    ref.read(userDataAuthProvider).whenData(
          (value) => commentRepository.uploadComment(
            context: context,
            text: text,
            senderUser: value!,
          ),
        );
  }
}
