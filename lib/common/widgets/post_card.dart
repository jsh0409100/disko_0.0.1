import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/chat/screens/chat_screen.dart';
import '../../features/profile/screens/other_user_profile_page.dart';

class PostCard extends StatefulWidget {
  final String uid, userName, postCategory, postTitle, postText;
  final List<String> likes, imagesUrl;
  const PostCard({
    Key? key,
    required this.uid,
    required this.userName,
    required this.postCategory,
    required this.postTitle,
    required this.postText,
    required this.likes,
    required this.imagesUrl,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');
  bool _isLiked = false;
  Color likeColor = Colors.black;
  Icon likeIcon = const Icon(Icons.favorite_border);

  @override
  Widget build(BuildContext context) {
    if (widget.likes.contains(user!.uid)) {
      likeColor = Theme.of(context).colorScheme.primary;
      likeIcon = const Icon(Icons.favorite);
    } else {
      likeColor = Colors.black;
      likeIcon = const Icon(Icons.favorite_border);
    }

    void handleClick(String value) {
      switch (value) {
        case '메세지 보내기':
          Navigator.pushNamed(
            context,
            ChatScreen.routeName,
            arguments: {
              'peerUid': widget.uid,
              'peerDisplayName': widget.userName
            },
          );
          break;
        case '신고하기':
          break;
      }
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                offset: Offset(0, 2), //(x,y)
                blurRadius: 5.0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: Row(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: const Image(
                                  image: AssetImage('assets/user.png'),
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
                                  widget.userName,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(widget.postCategory,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800)),
                              ],
                            )
                          ],
                        ),
                        onTap: () {
                          Get.to(() => const OtherUserProfilePage(),
                              arguments: widget.uid);
                        },
                      ),
                      PopupMenuButton<String>(
                        onSelected: handleClick,
                        itemBuilder: (BuildContext context) {
                          return {'메세지 보내기', '신고하기'}.map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: choice == '신고하기'
                                  ? Text(
                                      choice,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error),
                                    )
                                  : Text(choice),
                            );
                          }).toList();
                        },
                      ),
                    ]),
                const SizedBox(
                  height: 10,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    widget.postTitle,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.92 - 29,
                    child: Text(widget.postText),
                  ),
                  widget.imagesUrl.isEmpty
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.all(3),
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.92 - 29,
                            height: MediaQuery.of(context).size.height / 10,
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
                        )
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () async {
                        FirebaseFirestore.instance
                            .collection('posts')
                            .doc('sTnT0stHrJV5595ebfDm')
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
                        await postsCollection
                            .doc('sTnT0stHrJV5595ebfDm')
                            .update({
                          'likes': widget.likes,
                        });
                      },
                      icon: likeIcon,
                      color: likeColor,
                    ),
                    Text(widget.likes.length.toString()),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.chat_outlined,
                        color: Colors.black,
                      ),
                    ),
                    const Text('20'),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.bookmark_border,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 11,
        )
      ],
    );
  }
}