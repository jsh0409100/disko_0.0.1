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
import '../../../common/widgets/common_app_bar.dart';
import '../../../models/post_card_model.dart';
import '../../chat/screens/chat_screen.dart';
import '../../report/report_screen.dart';
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
                            'reportedUid': post.uid,
                            'reportedDisplayName': post.userName
                          });
                        },
                        style: TextButton.styleFrom(
                          elevation: 2,
                          backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        child: Text(
                          '예, 신고할게요',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
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
            'peerUid': post.uid,
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
            resizeToAvoidBottomInset: false,
            appBar: CommonAppBar(
              title: '',
              appBar: AppBar(),
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
                                      ],
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                PopupMenuButton<String>(
                                  onSelected: showMenu,
                                  itemBuilder: (BuildContext context) {
                                    return (post.uid != user!.uid)
                                        ? {'메세지 보내기', '신고하기'}.map((String choice) {
                                            return PopupMenuItem<String>(
                                              value: choice,
                                              child: choice == '신고하기'
                                                  ? Text(
                                                      choice,
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context).colorScheme.error),
                                                    )
                                                  : Text(choice),
                                            );
                                          }).toList()
                                        : {'글 수정', '글 삭제'}.map((String choice) {
                                            return PopupMenuItem<String>(
                                              value: choice,
                                              child: choice == '글 삭제'
                                                  ? Text(
                                                      choice,
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context).colorScheme.error),
                                                    )
                                                  : Text(choice),
                                            );
                                          }).toList();
                                  },
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
                        BottomCommentField(
                          post: post,
                        ),
                      ],
                    ),
                  );
                }),
          );
        });
  }
}
