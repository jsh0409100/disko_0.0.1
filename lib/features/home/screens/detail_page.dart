import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/common/widgets/loading_screen.dart';
import 'package:disko_001/features/home/widgets/bottom_comment_field.dart';
import 'package:disko_001/features/home/widgets/comment_list.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../common/enums/country_enum.dart';
import '../../../common/enums/notification_enum.dart';
import '../../../common/utils/utils.dart';
import '../../../common/widgets/common_app_bar.dart';
import '../../../models/post_card_model.dart';
import '../../../models/user_model.dart';
import '../../../src/providers.dart';
import '../../chat/screens/chat_screen.dart';
import '../../profile/screens/other_user_profile_page.dart';
import '../../report/report_screen.dart';
import '../../write_post/screens/edit_post_page.dart';
import '../controller/post_controller.dart';
import '../widgets/custom_image_provider.dart';

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
  List<bool> checkboxValues = [];
  List<String> checkUser = [];
  late PostCardModel post;
  final replyController = TextEditingController();

  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  String currUid = FirebaseAuth.instance.currentUser!.uid;
  bool _isLiked = false;
  Color likeColor = Colors.black;
  Icon likeIcon = const Icon(Icons.favorite_border);
  late int size = 0;

  void initializeCheckboxList(int snap) {
    checkboxValues = List<bool>.filled(snap, false);
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
                          Navigator.of(context)
                              .pushNamed(ReportScreen.routeName, arguments: {
                            'reportedUid': post.uid,
                            'reportedDisplayName': post.userName
                          });
                        },
                        style: TextButton.styleFrom(
                          elevation: 2,
                          backgroundColor:
                              Theme.of(context).colorScheme.onSurfaceVariant,
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

  Future _shareSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<UserDataModel>(
            future: getUserDataByUid(FirebaseAuth.instance.currentUser!.uid),
            builder: (context, snapshot) {
              return StatefulBuilder(builder: (context, setState) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingScreen();
                } else if (snapshot.hasError) {
                  return const Text("Error loading data");
                } else if (!snapshot.hasData) {
                  return const Text("No data available");
                }
                checkboxValues =
                    List<bool>.filled(snapshot.data!.follow.length, false);
                return SizedBox(
                  height: 500,
                  child: Column(
                    children: [
                      const Text(
                        '공유하기',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.follow.length,
                          itemBuilder: (BuildContext context, int index) {
                            return FutureBuilder(
                              future: getUserDataByUid(
                                  snapshot.data!.follow[index]),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshots) {
                                if (snapshots.hasData == false) {
                                  return const LoadingScreen();
                                } else {
                                  return ListTile(
                                      leading: CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(
                                          snapshots.data!.profilePic,
                                        ),
                                      ),
                                      title: Text(
                                        snapshots.data!.displayName,
                                        style: const TextStyle(
                                          color: Color(0xFF191919),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      trailing: Checkbox(
                                        value: checkboxValues[index],
                                        onChanged: (bool? value) {
                                          setState(() {
                                            checkboxValues[index] = value!;
                                            if (checkboxValues[index] == true) {
                                              print(
                                                  snapshot.data!.follow[index]);
                                              checkUser.add(
                                                  snapshot.data!.follow[index]);
                                            } else {
                                              print("remove 통과");
                                              checkUser.remove(
                                                  snapshot.data!.follow[index]);
                                            }
                                          });
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        checkColor: Colors.white,
                                        activeColor: const Color(0xFF7150FF),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.padded,
                                      ));
                                }
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xFF7150FF)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9))),
                          ),
                          onPressed: () {
                            //ToDo 공유기능 이어서 만들기
                            /*
                            for (String uid in checkUser) {
                              print(uid);
                              ref.read(chatControllerProvider).sendPostMessage(
                                    context,
                                    widget.postId,
                                    uid,
                                  );
                            }

                             */
                          },
                          child: const Text(
                            '보내기',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
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
            'peerName': post.userName,
          },
        );
        break;
      case '신고하기':
        _showMyDialog();
        break;
      case '글 수정':
        Navigator.of(context)
            .pushNamed(EditPostScreen.routeName, arguments: {'post': post});
        break;
      case '글 삭제':
        ref.read(postControllerProvider).deletePost(postId: post.postId);
        Navigator.pop(context);
        ref.read(postsProvider.notifier).reloadPage();
        break;
      case '앱 내 공유':
        _shareSheet(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDataProvider);
    CollectionReference postsCollection =
    FirebaseFirestore.instance.collection('posts').doc(countries[user.countryCode]).collection(countries[user.countryCode]!);
    return FutureBuilder(
        future: getPostByPostId(user, widget.postId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return const Center(child: CircularProgressIndicator());
          }
          post = snapshot.data!;
          if (post.likes.contains(currUid)) {
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
            appBar: CommonAppBar(
              title: '',
              appBar: AppBar(),
              showActions: false,
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: FutureBuilder(
                        future: getUserDataByUid(post.uid),
                        builder: (context, snapshot) {
                          if (snapshot.hasData == false) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          return Container(
                            height: MediaQuery.of(context).size.height / 1.125,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            post.isQuestion
                                                ? const Text(
                                              "Q",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Color(0xff7150FF),
                                              ),
                                            )
                                                : SizedBox(),

                                            GestureDetector(
                                              child: Row(
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
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  OtherUserProfilePage.routeName,
                                                  arguments: {
                                                    'uid': post.uid,
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        PopupMenuButton<String>(
                                          onSelected: showMenu,
                                          itemBuilder: (BuildContext context) {
                                            return (post.uid != currUid)
                                                ? {'메세지 보내기', '신고하기'}
                                                .map((String choice) {
                                              return PopupMenuItem<String>(
                                                value: choice,
                                                child: choice == '신고하기'
                                                    ? Text(
                                                  choice,
                                                  style: TextStyle(
                                                      color:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .error),
                                                )
                                                    : Text(choice),
                                              );
                                            }).toList()
                                                : {'글 수정', '글 삭제', '앱 내 공유'}
                                                .map((String choice) {
                                              return PopupMenuItem<String>(
                                                value: choice,
                                                child: choice == '글 삭제'
                                                    ? Text(
                                                  choice,
                                                  style: TextStyle(
                                                      color:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .error),
                                                )
                                                    : Text(choice),
                                              );
                                            }).toList();
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                        MediaQuery.of(context).size.height / 50),
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
                                        SizedBox(
                                            height: MediaQuery.of(context).size.height /
                                                100),
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
                                            width: MediaQuery.of(context).size.width * 9,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: post.imagesUrl.length,
                                              dragStartBehavior: DragStartBehavior.start,
                                              itemBuilder: (BuildContext context, int index) {
                                                return GestureDetector(
                                                  onTap: () async {
                                                    CustomImageProvider customImageProvider =
                                                    CustomImageProvider(
                                                      imageUrls: post.imagesUrl.toList(),
                                                    );
                                                    showImageViewerPager(
                                                      context,
                                                      customImageProvider,
                                                      swipeDismissible: true,
                                                      doubleTapZoomable: true,
                                                    );
                                                  },
                                                  child: SizedBox(
                                                      height: 150,
                                                      child: CachedNetworkImage(
                                                        imageUrl: post.imagesUrl[index],
                                                      )),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                        MediaQuery.of(context).size.height / 50),
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
                                          if (post.likes.contains(currUid)) {
                                            post.likes.remove(currUid);
                                            setState(() {
                                              _isLiked = false;
                                            });
                                          } else {
                                            post.likes.add(currUid);
                                            setState(() {
                                              _isLiked = true;
                                            });
                                          }
                                          await postsCollection
                                              .doc(post.postId)
                                              .update({
                                            'likes': post.likes,
                                          });
                                          if (post.uid != currUid) {
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
                              ],
                            ),
                          );
                        }),
                  ),

                ),
                BottomCommentField(
                  post: post,
                ),
              ],
            )
          );
        });
  }
}
