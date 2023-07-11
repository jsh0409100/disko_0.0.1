import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/common/utils/utils.dart';
import 'package:disko_001/features/home/controller/post_controller.dart';
import 'package:disko_001/features/report/report_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../../common/enums/notification_enum.dart';
import '../../../models/post_card_model.dart';
import '../../chat/screens/chat_screen.dart';
import '../../profile/screens/other_user_profile_page.dart';

class PostCard extends ConsumerStatefulWidget {
  final PostCardModel post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference postsCollection = FirebaseFirestore.instance.collection('posts');
  bool _isLiked = false;
  Color likeColor = Colors.black;
  Icon likeIcon = const Icon(
    Icons.favorite_border,
    size: 24,
  );

  @override
  Widget build(BuildContext context) {
    if (widget.post.likes.contains(user!.uid)) {
      likeColor = Theme.of(context).colorScheme.primary;
      likeIcon = const Icon(
        Icons.favorite,
        size: 24,
      );
    } else {
      likeColor = Colors.black;
      likeIcon = const Icon(
        Icons.favorite_border,
        size: 24,
      );
    }

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (context) {
          return Builder(builder: (context) {
            final customTheme = Theme.of(context).copyWith(
              dialogTheme: const DialogTheme(
                backgroundColor: Color(0xFFFFFBFF),
              ),
            );

            return Theme(
              data: customTheme,
              child: AlertDialog(
                title: Text(
                  '정말로 이 사용자를 신고하시겠습니까?',
                  style: Theme.of(context).textTheme.bodyLarge,
                  maxLines: 2,
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          elevation: 2,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                        ),
                        child: Text('아니요',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.white)),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(ReportScreen.routeName, arguments: {
                              'reportedUid': widget.post.uid,
                              'reportedDisplayName': widget.post.userName
                            });
                          },
                          style: TextButton.styleFrom(
                            elevation: 2,
                            backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          child: Text(
                            '예, 신고할게요',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.white),
                          )),
                    ],
                  ),
                ),
              ),
            );
          });
        },
      );
    }

    void showMenu(String value) {
      switch (value) {
        case '메세지 보내기':
          Navigator.pushNamed(
            context,
            ChatScreen.routeName,
            arguments: {
              'peerUid': widget.post.uid,
            },
          );
          break;
        case '신고하기':
          _showMyDialog();
          break;
        case '글 수정':
          break;
        case '글 삭제':
          break;
      }
    }

    void saveNotification({
      required String postId,
      required String peerUid,
      required String postTitle,
      required Timestamp time,
      required NotificationEnum notificationType,
    }) {
      ref.read(postControllerProvider).saveNotification(
            postId: postId,
            peerUid: peerUid,
            postTitle: postTitle,
            time: time,
            notificationType: notificationType,
          );
    }

    return Column(
      children: [
        FutureBuilder(
            future: getUserDataByUid(widget.post.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData == false) {
                return Card(
                  color: Colors.grey.shade300,
                  child: Column(children: [
                    SizedBox(
                      height: 180,
                      width: MediaQuery.of(context).size.width * 0.9,
                    ),
                    const SizedBox(
                      height: 11,
                    )
                  ]),
                );
              }
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      width: 1,
                      color: Color(0xffE7E0EC)
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.05),
                      offset: Offset(0, 2), //(x,y)
                      blurRadius: 1.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Text(
                            widget.post.postTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0xff191919),
                            ),
                          ),
                        ),
                        widget.post.imagesUrl.isEmpty
                            ? Container()
                            : Padding(
                          padding: const EdgeInsets.fromLTRB(0,3,0,5),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 250,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.post.imagesUrl.length,
                                dragStartBehavior: DragStartBehavior.start,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Image.network(widget.post.imagesUrl[index],
                                        fit: BoxFit.cover),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.92 - 29,
                            child: Text(
                              widget.post.postText,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xff191919),
                              ),
                            ),
                          ),
                        ),
                      ]),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          GestureDetector(
                            child: Row(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image(
                                      image: NetworkImage(snapshot.data!.profilePic),
                                      height: 19,
                                      width: 19,
                                      fit: BoxFit.scaleDown,
                                    )),
                                const SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data!.displayName,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xff191919),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            onTap: () {
                              if (widget.post.uid != user!.uid) {
                                Get.to(() => const OtherUserProfilePage(), arguments: widget.post.uid);
                              }
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  FirebaseFirestore.instance
                                      .collection('posts')
                                      .doc(widget.post.postId)
                                      .get();
                                  if (widget.post.likes.contains(user!.uid)) {
                                    widget.post.likes.remove(user!.uid);
                                    setState(() {
                                      _isLiked = false;
                                    });
                                  } else {
                                    widget.post.likes.add(user!.uid);
                                    setState(() {
                                      _isLiked = true;
                                    });
                                  }
                                  await postsCollection.doc(widget.post.postId).update({
                                    'likes': widget.post.likes,
                                  });

                                  saveNotification(
                                    peerUid: widget.post.uid,
                                    postId: widget.post.postId,
                                    postTitle: widget.post.postTitle,
                                    time: Timestamp.now(),
                                    notificationType: NotificationEnum.like,
                                  );
                                },
                                icon: likeIcon,
                                color: likeColor,
                                style: IconButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                              Text(widget.post.likes.length.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.chat_outlined,
                                  color: Colors.black,
                                  size: 24,
                                ),
                                style: IconButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                              Text(widget.post.commentCount.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              );
            }),
        const SizedBox(
          height: 11,
        )
      ],
    );
  }
}
