import 'dart:io';

import 'package:disko_001/features/home/widgets/comment_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/comment_controller.dart';

class BottomCommentField extends ConsumerStatefulWidget {
  BottomCommentField({
    Key? key,
    required this.profilePic,
    required this.postId,
    required this.comment_count,
  }) : super(key: key);
  final String profilePic;
  final String postId;
  int comment_count;

  @override
  ConsumerState<BottomCommentField> createState() => _BottomCommentFieldState();
}

class _BottomCommentFieldState extends ConsumerState<BottomCommentField> {
  final controller = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  var _userEnterMessage = '';

  void uploadComment() async {
    ref.read(commentControllerProvider).uploadComment(
          context,
          _userEnterMessage,
          widget.postId,
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
        Container(
          height: 36,
          width: 36,
          decoration: const BoxDecoration(
              color: Color(0xffD9D9D9), shape: BoxShape.circle),
        ),
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
                : uploadComment;
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
