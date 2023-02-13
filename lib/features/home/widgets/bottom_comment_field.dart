import 'dart:io';

import 'package:disko_001/features/home/screens/detail_page.dart';
import 'package:disko_001/features/home/widgets/comment_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/comment_controller.dart';

class BottomCommentField extends ConsumerStatefulWidget {
  BottomCommentField( {
    Key? key,
    required this.profilePic,
    required this.postId,
    required this.comment_count,
    required this.postCategory,
    required this.postTitle,
    required this.likes,
    required this.imagesUrl,
  }) : super(key: key);
  final String profilePic, postId, postCategory, postTitle;
  final List<String> likes, imagesUrl;
  int comment_count = 0;

  @override
  ConsumerState<BottomCommentField> createState() => _BottomCommentFieldState();
}

class _BottomCommentFieldState extends ConsumerState<BottomCommentField> {
  final controller = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  var _userEnterMessage = '';

  void uploadComment() {
    ref.read(commentControllerProvider).uploadComment(
          context,
          _userEnterMessage,
          widget.postId,
          widget.postCategory,
          widget.postTitle,
          widget.imagesUrl,
          widget.likes,
        );
    setState(() {
      controller.clear();
      _userEnterMessage = '';
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    // _soundRecorder!.closeRecorder();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image(
              image: NetworkImage(widget.profilePic),
              height: 43,
              width: 43,
              fit: BoxFit.scaleDown,
            )),
        Expanded(
          child: TextField(
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            controller: controller,
            maxLines: null,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              hintText: "댓글 달기",
            ),
            onChanged: (value) {
              setState(() {
                _userEnterMessage = value.trim();
              });
            },
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              widget.comment_count = widget.comment_count + 1;
            });
            (_userEnterMessage.trim().isEmpty || _userEnterMessage.trim() == '')
                ? null
                : uploadComment();
          },
          icon: Icon(
            Icons.send,
            color: _userEnterMessage.trim().isEmpty
                ? Theme.of(context).colorScheme.outline
                : Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
