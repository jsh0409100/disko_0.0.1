import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/features/home/widgets/bottom_comment_field.dart';
import 'package:disko_001/features/home/widgets/comment_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/enums/notification_enum.dart';
import '../../../common/utils/utils.dart';
import '../controller/post_controller.dart';

class DetailPage extends ConsumerStatefulWidget {
  const DetailPage({
    Key? key,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  final _PostCard = Get.arguments;
  final replyController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference postsCollection = FirebaseFirestore.instance.collection('posts');
  bool _isLiked = false;
  Color likeColor = Colors.black;
  Icon likeIcon = const Icon(Icons.favorite_border);
  late int size = 0;

  void saveNotification({
    required String postId,
    required String peerUid,
    required Timestamp time,
    required NotificationEnum notificationType,
  }) {
    ref.read(postControllerProvider).saveNotification(
        postId: postId, peerUid: peerUid, time: time, notificationType: notificationType);
  }

  @override
  Widget build(BuildContext context) {
    if (_PostCard.likes.contains(user!.uid)) {
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

    final DateTime date = _PostCard.time.toDate();
    final timeFormat = DateFormat('MM월 dd일', 'ko');
    final showTime = timeFormat.format(date);

    return StreamBuilder(
        stream: getUserDataByUidStream(FirebaseAuth.instance.currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.grey[50],
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(4.0),
                  child: Container(
                    color: Colors.grey,
                    height: 0.5,
                  )),
              title: Text(
                _PostCard.postCategory,
                style:
                    const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 17),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: FutureBuilder(
                  future: getUserDataByUid(_PostCard.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData == false) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Container(
                      height: MediaQuery.of(context).size.height / 1.125,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image(
                                        image: NetworkImage(snapshot.data!.profilePic),
                                        height: 43,
                                        width: 43,
                                        fit: BoxFit.scaleDown,
                                      )),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data!.displayName,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(_PostCard.postCategory,
                                          style: const TextStyle(
                                            fontSize: 12,
                                          )),
                                    ],
                                  ),
                                  SizedBox(width: MediaQuery.of(context).size.width / 1.97),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.more_vert),
                                    iconSize: 24,
                                  ),
                                ],
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height / 50),
                              FittedBox(
                                fit: BoxFit.contain,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _PostCard.postTitle,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height / 100),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    child: Text(
                                      _PostCard.postText,
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  _PostCard.imagesUrl.isEmpty
                                      ? Container()
                                      : Padding(
                                          padding: const EdgeInsets.all(3),
                                          child: Container(
                                            height: MediaQuery.of(context).size.height / 3,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: _PostCard.imagesUrl.length,
                                              dragStartBehavior: DragStartBehavior.start,
                                              itemBuilder: (BuildContext context, int index) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(2),
                                                  child: Image.network(
                                                    _PostCard.imagesUrl[index],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height / 50),
                              Row(
                                children: [
                                  SizedBox(width: MediaQuery.of(context).size.width / 1.35),
                                  Text(
                                    showTime,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff767676),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  FirebaseFirestore.instance
                                      .collection('posts')
                                      .doc(_PostCard.postId)
                                      .get();
                                  if (_PostCard.likes.contains(user!.uid)) {
                                    _PostCard.likes.remove(user!.uid);
                                    setState(() {
                                      _isLiked = false;
                                    });
                                  } else {
                                    _PostCard.likes.add(user!.uid);
                                    setState(() {
                                      _isLiked = true;
                                    });
                                  }
                                  await postsCollection.doc(_PostCard.postId).update({
                                    'likes': _PostCard.likes,
                                  });
                                  saveNotification(
                                    peerUid: _PostCard.uid,
                                    postId: _PostCard.postId,
                                    time: Timestamp.now(),
                                    notificationType: NotificationEnum.like,
                                  );
                                },
                                icon: likeIcon,
                                color: likeColor,
                              ),
                              Text(
                                _PostCard.likes.length.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 5),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.chat_outlined,
                                  color: Colors.black,
                                  size: 24,
                                ),
                              ),
                              Text(
                                _PostCard.commentCount.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: CommentList(
                              profilePic: snapshot.data!.profilePic,
                              postId: _PostCard.postId,
                            ),
                          ),
                          BottomCommentField(
                            profilePic: snapshot.data!.profilePic,
                            postId: _PostCard.postId,
                            uid: _PostCard.uid,
                            commentCount: _PostCard.commentCount,
                            likes: _PostCard.likes,
                            imagesUrl: _PostCard.imagesUrl,
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          );
        });
  }
}
