import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/screens/chat_screen/screens/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/post_card_model.dart';
import '../screens/home_screen/detail_page.dart';

class PostCard extends StatefulWidget {
  final String userName, postCategory, postTitle, postText, uid;

  const PostCard({
    Key? key,
    // required this.uid,
    required this.userName,
    required this.postCategory,
    required this.postTitle,
    required this.postText,
    required this.uid,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    void handleClick(String value) {
      switch (value) {
        case '메세지 보내기':
          Get.to(() => ChatPage(), arguments: widget.uid);
          break;
        case '신고하기':
          break;
      }
    }

    return Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.92),
        child: GestureDetector(
          onTap: () {
            Get.to(
              const DetailPage(),
              arguments: PostCard(
                  userName: widget.userName,
                  postCategory: widget.postCategory,
                  postTitle: widget.postTitle,
                  postText: widget.postText,
                  uid: widget.uid),
            );
          },
          child: Card(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: const Image(
                                  image: NetworkImage(
                                      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
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
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                      ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.favorite_border),
                      ),
                      const Text('5'),
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
        ));
  }
}

class PostsDatabase {
  Future<List<PostCardModel>> fetchPosts(PostCardModel? message) async {
    final postsCollectionRef = FirebaseFirestore.instance.collection('posts');

    if (message == null) {
      final documentSnapshot = await postsCollectionRef
          .orderBy('postTimeStamp', descending: true)
          .limit(5)
          .get();
      return documentSnapshot.docs
          .map((doc) => PostCardModel.fromJson(doc.data()))
          .toList();
    } else {
      final documentSnapshot = await postsCollectionRef
          .orderBy('postTimeStamp', descending: true)
          .startAfter([message.time])
          .limit(5)
          .get();
      return documentSnapshot.docs
          .map((doc) => PostCardModel.fromJson(doc.data()))
          .toList();
    }
  }
}
