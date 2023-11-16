import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/local_notification.dart';
import '../../../common/utils/utils.dart';
import '../../../models/post_card_model.dart';
import '../../../test.dart';
import '../controller/post_controller.dart';

class BottomCommentField extends ConsumerStatefulWidget {
  BottomCommentField({
    Key? key,
    required this.post,
  }) : super(key: key);
  final PostCardModel post;

  @override
  ConsumerState<BottomCommentField> createState() => _BottomCommentFieldState();
}

class _BottomCommentFieldState extends ConsumerState<BottomCommentField> {
  int commentCount = 0;

  late final NotificationService notificationService;
  @override
  void initState() {
    notificationService = NotificationService();
    pushToPost();
    notificationService.initializePlatformNotifications();
    super.initState();
  }

  void pushToPost() => notificationService.behaviorSubject.listen((payload) {
        print('Here');
        Navigator.pushNamed(
          context,
          TestScreen.routeName,
          arguments: {
            'postId': payload,
          },
        );
      });
  final controller = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  var _userEnterMessage = '';

  void uploadComment() {
    ref.read(postControllerProvider).uploadComment(
          context,
          _userEnterMessage,
          widget.post.postId,
          widget.post.imagesUrl,
          widget.post.likes,
        );
    notificationService.sendPostNotification(
      postTitle: widget.post.postTitle,
      postId: widget.post.postId,
      senderDisplayName: user!.displayName,
      receiverId: widget.post.uid,
      notificationBody: _userEnterMessage,
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
          if (!snapshot.hasData) {
            return Container();
          }
          return Container(
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 5.0,
                  offset: Offset(0, -0.01), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(children: [
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
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                    (_userEnterMessage.trim().isEmpty || _userEnterMessage.trim() == '')
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
              ]),
            ),
          );
        });
  }
}
