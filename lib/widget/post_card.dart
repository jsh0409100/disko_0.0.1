import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/post_card_model.dart';
import '../screens/home_screen/detail_page.dart';

class PostCard extends StatelessWidget {
  final String userName, postCategory, postTitle, postText;

  const PostCard({
    Key? key,
    // required this.uid,
    required this.userName,
    required this.postCategory,
    required this.postTitle,
    required this.postText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.92),
        child: GestureDetector(
          onTap: () {
            Get.to(
              const DetailPage(),
              arguments: PostCard(
                  userName: userName,
                  postCategory: postCategory,
                  postTitle: postTitle,
                  postText: postText),
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
                                  userName,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(postCategory,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800)),
                              ],
                            )
                          ],
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.more_vert)),
                      ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          postTitle,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.92 - 29,
                          child: Text(postText),
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
  Future<List<PostCardModel>> fetchPosts(PostCardModel? post) async {
    final postsCollectionRef = FirebaseFirestore.instance.collection('posts');

    if (post == null) {
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
          .startAfter([post.postTimeStamp])
          .limit(5)
          .get();
      return documentSnapshot.docs
          .map((doc) => PostCardModel.fromJson(doc.data()))
          .toList();
    }
  }
}
