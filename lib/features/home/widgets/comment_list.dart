import 'package:disko_001/common/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/comment_model.dart';
import '../controller/comment_controller.dart';
import 'comment.dart';

class CommentList extends ConsumerStatefulWidget {
  final String postId;
  const CommentList({super.key, required this.postId});

  @override
  ConsumerState<CommentList> createState() => _CommentListState();
}

class _CommentListState extends ConsumerState<CommentList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CommentModel>>(
        stream: ref.read(commentControllerProvider).commentStream(widget.postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }
          return ListView.builder(
            controller: messageController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final commentDocs = snapshot.data![index];
              return Comment(
                userName: commentDocs.userName,
                text: commentDocs.text,
                uid: commentDocs.uid,
                likes: commentDocs.likes,
                time: commentDocs.time,
              );
            },
          );
        });
  }
}
