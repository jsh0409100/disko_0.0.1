import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/common/utils/utils.dart';
import 'package:disko_001/features/profile/screens/profile_edit_page.dart';
import 'package:disko_001/features/write_post/controller/write_post_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../common/widgets/error_text.dart';
import '../../../common/widgets/loading_screen.dart';
import '../../../models/user_model.dart';
import '../../home/widgets/post.dart';
import 'other_user_profile_page.dart';

const List<Widget> follow = <Widget>[
  Text('활동내역'),
  Text('팔로우'),
  Text('스크랩'),
];

class My_ProfilePage extends ConsumerStatefulWidget {
  final String uid;
  final UserDataModel user;

  const My_ProfilePage({
    Key? key,
    required this.user,
    required this.uid,
  }) : super(key: key);

  @override
  ConsumerState<My_ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<My_ProfilePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference currUser = FirebaseFirestore.instance.collection("users");
  String test = 'test';
  File? image;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController followController = TextEditingController();
  final List<bool> _selectedbutton = <bool>[true, false, false];
  String state = '';
  bool isFollowed = false;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topWidget(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                decideWidgetBasedOnState(state, context),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget myPost(BuildContext context) {
    return ref.watch(searchMyPostProvider(widget.uid)).when(
          data: (posts) => ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                    future: getUserDataByUid(posts[index].uid),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                      } else {
                        return Post(
                          post: posts[index],
                        );
                      }
                    });
              }),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const LoadingScreen(),
        );
  }

  Widget size() {
    return SizedBox(width: MediaQuery.of(context).size.width * 0.03);
  }

  Widget topWidget() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                image == null
                    ? CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(widget.user.profilePic),
                      )
                    : CircleAvatar(
                        radius: 35,
                        backgroundImage: FileImage(
                          image!,
                        ),
                      ),
                Padding(
                  padding:
                      EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.15, left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      profileNameText(widget.user.displayName),
                      verEmailText(),
                    ],
                  ),
                ),
                widget.uid == FirebaseAuth.instance.currentUser!.uid
                    ? editChip()
                    : followChip(checkFollow())
              ],
            ),
            descriptionText(),
            // percentage(),
            activeFollow(),
          ],
        ),
      ),
    );
  }

  Widget profileText(String name) {
    return Text(
      name,
      style: const TextStyle(
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
    );
  }

  Widget verEmailText() {
    return const Text(
      '개인정보인증 완료',
      style: TextStyle(
        color: Color(0xFFC4C4C4),
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget profileNameText(String name) {
    return Text(
      name,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 17,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget descriptionText() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        widget.user.description,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget editChip() {
    return ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, ProfileEditPage.routeName, arguments: {'user': widget.user});
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white54),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ))),
        child: const Text(
          '수정',
          style: TextStyle(color: Colors.black),
        ));
  }

  void checkFollow() async {
    DocumentSnapshot documentSnapshot = await currUser.doc(auth.currentUser?.uid).get();
    List<String> currentArray = List.from(documentSnapshot.get("follow") as List<dynamic>);
    if (mounted) {
      if (currentArray.contains(widget.uid)) {
        setState(() {
          isFollowed = true;
        });
      } else {
        setState(() {
          isFollowed = false;
        });
      }
    }
  }

  Widget followChip(void checkFollow) {
    return isFollowed == false
        ? ElevatedButton(
            onPressed: () async {
              DocumentSnapshot documentSnapshot = await currUser.doc(auth.currentUser?.uid).get();
              List<String> currentArray =
                  List.from(documentSnapshot.get("follow") as List<dynamic>);
              currentArray.add(widget.uid);
              await currUser.doc(auth.currentUser?.uid).update({"follow": currentArray});
              if (mounted) {
                setState(() {
                  isFollowed = true;
                });
              }
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color(0xFFE0D9FF)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ))),
            child: const Text(
              '팔로우',
              style: TextStyle(color: Colors.black),
            ))
        : ElevatedButton(
            onPressed: () async {
              DocumentSnapshot documentSnapshot = await currUser.doc(auth.currentUser?.uid).get();
              List<String> currentArray =
                  List.from(documentSnapshot.get("follow") as List<dynamic>);
              currentArray.removeWhere((str) {
                return str == widget.uid;
              });
              await currUser.doc(auth.currentUser?.uid).update({"follow": currentArray});
              if (mounted) {
                setState(() {
                  isFollowed = false;
                });
              }
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color(0xFFE0D9FF)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ))),
            child: const Text(
              '언팔로우',
              style: TextStyle(color: Colors.black),
            ));
  }

  Widget percentage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'LV1. ',
                style: TextStyle(
                  color: Color(0xFF191919),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                widget.user.diskoPoint.toString(),
                style: const TextStyle(
                  color: Color(0xFF191919),
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        LinearPercentIndicator(
          width: MediaQuery.of(context).size.width - 60,
          lineHeight: 19,
          percent: widget.user.diskoPoint / 1000,
          progressColor: const Color(0xFFE0D9FF),
          animation: true,
          barRadius: const Radius.circular(15.0),
          backgroundColor: const Color(0x3F000000),
        ),
      ],
    );
  }

  Widget activeFollow() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ToggleButtons(
        direction: Axis.horizontal,
        onPressed: (int index) {
          if (mounted) {
            setState(() {
              for (int i = 0; i < _selectedbutton.length; i++) {
                _selectedbutton[i] = i == index;
                if (index == 0){
                  state = '';
                } else if (index == 1){
                  state = '팔로우';
                } else if (index == 2){
                  state = '스크랩';
                }
              }
            });
          }
        },
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        selectedColor: const Color(0xFF7150FF),
        fillColor: Colors.white,
        constraints: BoxConstraints(
          minHeight: 80,
          minWidth: MediaQuery.of(context).size.width - 300,
        ),
        textStyle: const TextStyle(
            //fontWeight: FontWeight.w500,
            fontSize: 14),
        isSelected: _selectedbutton,
        children: follow,
      ),
    );
  }

  Widget followList(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: widget.user.follow.length,
        itemBuilder: (context, index) {
          return FutureBuilder(
              future: getUserDataByUid(widget.user.follow[index]),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData == false) {
                  return const Text("has error");
                } else {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(
                        snapshot.data!.profilePic,
                      ),
                    ),
                    title: Text(
                      snapshot.data!.displayName,
                      style: const TextStyle(
                        color: Color(0xFF191919),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                OtherUserProfilePage(uid: widget.user.follow[index]),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  );
                }
              });
        });
  }

  Widget scrap(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: getScrapListByUid(widget.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return Text('에러 발생 : ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text('데이터 없음');
        } else {
          final documents = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: documents.map((documentSnapshot) {
                final data = documentSnapshot.data() as Map<String, dynamic>?;
                if (data == null) {
                  return const ListTile(
                    title: Text('문서 ID 없음'),
                  );
                }
                final scrapID = data['postID'];
                return ref.watch(searchMyScrapProvider(scrapID)).when(
                  data: (posts) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            return FutureBuilder(
                              future: getUserDataByUid(posts[index].uid),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const LoadingScreen();
                                } else if (snapshot.hasError) {
                                  return Text('에러 발생 : ${snapshot.error}');
                                } else if (!snapshot.hasData) {
                                  return const Text('데이터 없음');
                                } else {
                                  return Post(
                                    post: posts[index],
                                  );
                                }
                              },
                            );
                          },
                        ),
                        // 스크랩 항목과 항목 사이의 간격
                        SizedBox(height: 10),
                      ],
                    );
                  },
                  error: (error, stackTrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () => const LoadingScreen(),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }



  Future<List<String>> getScrappedPostIDs(BuildContext context) async{
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .collection('Scrap')
        .get();

    List<String> scrappedPostIDs = [];
    querySnapshot.docs.forEach((doc){
      scrappedPostIDs.add(doc['postID']);
    });

    return scrappedPostIDs;
  }

  Widget decideWidgetBasedOnState(String state, BuildContext context) {
    switch (state) {
      case '팔로우':
        return Container(
          height: MediaQuery.of(context).size.height / 2.3,
          child: followList(context),
        );
      case '스크랩':
         return Container(
          height: MediaQuery.of(context).size.height / 2.3,
          child: scrap(context),
        );
      default:
        return Container(
          height: MediaQuery.of(context).size.height / 2.3,
          child: myPost(context),
        );
    }
  }
}
