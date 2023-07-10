import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/common/utils/utils.dart';
import 'package:disko_001/features/home/controller/post_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../../common/enums/notification_enum.dart';
import '../../chat/screens/chat_screen.dart';
import '../../profile/screens/other_user_profile_page.dart';

class PostCard extends ConsumerStatefulWidget {
  final String uid, postCategory, postTitle, postText, postId;
  final List<String> likes, imagesUrl;
  final Timestamp time;
  final int commentCount;

  const PostCard({
    Key? key,
    required this.uid,
    required this.postCategory,
    required this.postTitle,
    required this.postText,
    required this.likes,
    required this.imagesUrl,
    required this.postId,
    required this.time,
    required this.commentCount,
  }) : super(key: key);

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
    if (widget.likes.contains(user!.uid)) {
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

    void handleClick(String value) {
      switch (value) {
        case '메세지 보내기':
          Navigator.pushNamed(
            context,
            ChatScreen.routeName,
            arguments: {
              'peerUid': widget.uid,
            },
          );
          break;
        case '신고하기':
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
            future: getUserDataByUid(widget.uid),
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
                            widget.postTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0xff191919),
                            ),
                          ),
                        ),
                        widget.imagesUrl.isEmpty
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
                                      itemCount: widget.imagesUrl.length,
                                      dragStartBehavior: DragStartBehavior.start,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(2),
                                          child: Image.network(widget.imagesUrl[index],
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
                              widget.postText,
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
                              if (widget.uid != user!.uid) {
                                Get.to(() => const OtherUserProfilePage(), arguments: widget.uid);
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
                                      .doc(widget.postId)
                                      .get();
                                  if (widget.likes.contains(user!.uid)) {
                                    widget.likes.remove(user!.uid);
                                    setState(() {
                                      _isLiked = false;
                                    });
                                  } else {
                                    widget.likes.add(user!.uid);
                                    setState(() {
                                      _isLiked = true;
                                    });
                                  }
                                  await postsCollection.doc(widget.postId).update({
                                    'likes': widget.likes,
                                  });

                                  saveNotification(
                                    peerUid: widget.uid,
                                    postId: widget.postId,
                                    postTitle: widget.postTitle,
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
                              Text(widget.likes.length.toString(),
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
                              Text(widget.commentCount.toString(),
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
