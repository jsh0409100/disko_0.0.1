import 'package:disko_001/common/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/comment_model.dart';
import '../../../models/nestedcomment_model.dart';
import '../controller/post_controller.dart';
import 'nestedcomment.dart';

class NestedCommentList extends ConsumerStatefulWidget {
  final String postId, commentId;
  const NestedCommentList({super.key, required this.postId, required this.commentId});

  @override
  ConsumerState<NestedCommentList> createState() => _NestedCommentListState();
}

class _NestedCommentListState extends ConsumerState<NestedCommentList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<NestedCommentModel>>(
        stream: ref.read(postControllerProvider).nestedcommentStream(widget.postId, widget.commentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }
          return ListView.builder(
            controller: messageController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final nestedcommentDocs = snapshot.data![index];
              return NestedComment(
                userName: nestedcommentDocs.userName,
                text: nestedcommentDocs.text,
                uid: nestedcommentDocs.uid,
                likes: nestedcommentDocs.likes,
                time: nestedcommentDocs.time,
                postId: widget.postId,
                commentId: widget.commentId,
                nestedcommentId: nestedcommentDocs.nestedcommentId,
              );
            },
          );
        });
  }
}
