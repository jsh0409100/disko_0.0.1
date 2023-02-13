import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/post_controller.dart';

class BottomCommentField extends ConsumerStatefulWidget {
  BottomCommentField({
    Key? key,
    required this.profilePic,
    required this.postId,
    required this.uid,
    required this.comment_count,
    required this.likes,
    required this.imagesUrl,
  }) : super(key: key);
  final String profilePic, postId, uid;
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
    ref.read(postControllerProvider).uploadComment(
          context,
          _userEnterMessage,
          widget.postId,
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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        child: Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image(
                  image: NetworkImage(widget.profilePic),
                  height: 43,
                  width: 43,
                  fit: BoxFit.scaleDown,
                )),
            const SizedBox(width: 10),
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
                  hintText: "댓글 쓰기",
                ),
                onChanged: (value) {
                  setState(() {
                    _userEnterMessage = value.trim();
                  });
                },
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.comment_count = widget.comment_count + 1;
                });
                (_userEnterMessage.trim().isEmpty || _userEnterMessage.trim() == '')
                    ? null
                    : uploadComment();
              },
              child: Text('게시'),
            ),
          ],
        ),
      ),
    );
  }
}
