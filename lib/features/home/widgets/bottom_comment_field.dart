import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/utils.dart';
import '../controller/post_controller.dart';

class BottomCommentField extends ConsumerStatefulWidget {
  BottomCommentField({
    Key? key,
    required this.postId,
    required this.commentCount,
    required this.likes,
    required this.imagesUrl,
  }) : super(key: key);
  final String postId;
  final List<String> likes, imagesUrl;
  int commentCount = 0;

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
    return FutureBuilder(
        future: getUserDataByUid(FirebaseAuth.instance.currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(!snapshot.hasData){
              return Container();
            }
            return Row(children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image(
                  image: NetworkImage(snapshot.data!.profilePic),
                  height: 43,
                  width: 43,
                  fit: BoxFit.scaleDown,
                )),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                autofocus: true,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                controller: controller,
                maxLines: null,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xffD9D9D9),
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
                (_userEnterMessage.trim().isEmpty ||
                        _userEnterMessage.trim() == '')
                    ? null
                    : uploadComment();
              },
              child: const Text(
                '게시',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ]);
        });
  }
}
