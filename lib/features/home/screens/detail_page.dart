import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/features/home/widgets/bottom_comment_field.dart';
import 'package:disko_001/features/home/widgets/comment_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../common/enums/notification_enum.dart';
import '../../../common/utils/utils.dart';
import '../../../models/post_card_model.dart';
import '../controller/post_controller.dart';

class DetailPage extends ConsumerStatefulWidget {
  final String postId;
  const DetailPage({
    Key? key,
    required this.postId,
  }) : super(key: key);

  static const routeName = '/detail-screen';

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  late final PostCardModel post;
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
    required String postTitle,
    required Timestamp time,
    required NotificationEnum notificationType,
  }) {
    ref.read(postControllerProvider).saveNotification(
        postId: postId,
        peerUid: peerUid,
        postTitle: postTitle,
        time: time,
        notificationType: notificationType);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getPostByPostId(widget.postId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return const Center(child: CircularProgressIndicator());
          }
          post = snapshot.data!;
          if (post.likes.contains(user!.uid)) {
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

          final DateTime date = post.time.toDate();
          final timeFormat = DateFormat('MM월 dd일', 'ko');
          final showTime = timeFormat.format(date);

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
                post.postCategory,
                style:
                    const TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 17),
              ),
              centerTitle: true,
            ),
            body: FutureBuilder(
                future: getUserDataByUid(post.uid),
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
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
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
                                        Text(post.postCategory,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.more_vert),
                                  iconSize: 24,
                                ),
                              ],
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height / 50),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  fit: BoxFit.contain,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    post.postTitle,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height / 100),
                                SizedBox(
                                  child: Text(
                                    post.postText,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                post.imagesUrl.isEmpty
                                    ? Container()
                                    : Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: SizedBox(
                                          height: MediaQuery.of(context).size.height / 3,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: post.imagesUrl.length,
                                            dragStartBehavior: DragStartBehavior.start,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Padding(
                                                padding: const EdgeInsets.all(2),
                                                child: Image.network(
                                                  post.imagesUrl[index],
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
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  showTime,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xff767676),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  FirebaseFirestore.instance
                                      .collection('posts')
                                      .doc(post.postId)
                                      .get();
                                  if (post.likes.contains(user!.uid)) {
                                    post.likes.remove(user!.uid);
                                    setState(() {
                                      _isLiked = false;
                                    });
                                  } else {
                                    post.likes.add(user!.uid);
                                    setState(() {
                                      _isLiked = true;
                                    });
                                  }
                                  await postsCollection.doc(post.postId).update({
                                    'likes': post.likes,
                                  });
                                  if (post.uid != user!.uid) {
                                    saveNotification(
                                      peerUid: post.uid,
                                      postId: post.postId,
                                      postTitle: post.postTitle,
                                      time: Timestamp.now(),
                                      notificationType: NotificationEnum.like,
                                    );
                                  }
                                },
                                icon: likeIcon,
                                color: likeColor,
                              ),
                              Text(
                                post.likes.length.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.chat_outlined,
                                  color: Colors.black,
                                  size: 24,
                                ),
                              ),
                              Text(
                                post.commentCount.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: CommentList(
                            postId: post.postId,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: BottomCommentField(
                            post: post,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          );
        });
  }
}
