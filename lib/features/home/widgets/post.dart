import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/features/home/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/utils/utils.dart';
import '../../../models/post_card_model.dart';
import '../screens/detail_page.dart';

class Post extends StatefulWidget {
  final String userName, postCategory, postTitle, postText, uid, profilePic, postId;
  final List<String> likes, imagesUrl;
  final Timestamp time;
  final int commentCount;

  const Post({
    Key? key,
    // required this.uid,
    required this.userName,
    required this.postCategory,
    required this.postTitle,
    required this.postText,
    required this.uid,
    required this.likes,
    required this.imagesUrl,
    required this.profilePic,
    required this.postId,
    required this.commentCount,
    required this.time,
  }) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDisplayNameByUid(widget.uid),
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
          }
          return Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.92),
              child: GestureDetector(
                onTap: () {
                  Get.to(
                    () => const DetailPage(),
                    arguments: PostCard(
                      postCategory: widget.postCategory,
                      postTitle: widget.postTitle,
                      postText: widget.postText,
                      uid: widget.uid,
                      likes: widget.likes,
                      imagesUrl: widget.imagesUrl,
                      postId: widget.postId,
                      time: widget.time,
                      commentCount: widget.commentCount,
                    ),
                  );
                },
                child: PostCard(
                  postCategory: widget.postCategory,
                  postTitle: widget.postTitle,
                  postText: widget.postText,
                  uid: widget.uid,
                  likes: widget.likes,
                  imagesUrl: widget.imagesUrl,
                  postId: widget.postId,
                  time: widget.time,
                  commentCount: widget.commentCount,
                ),
              ));
        });
  }
}

class PostsDatabase {
  Future<List<PostCardModel>> fetchPosts(PostCardModel? post) async {
    final postsCollectionRef = FirebaseFirestore.instance.collection('posts');
    if (post == null) {
      final documentSnapshot =
          await postsCollectionRef.orderBy('time', descending: true).limit(5).get();
      return documentSnapshot.docs.map((doc) => PostCardModel.fromJson(doc.data())).toList();
    } else {
      final documentSnapshot = await postsCollectionRef
          .orderBy('time', descending: true)
          .startAfter([post.time])
          .limit(5)
          .get();
      return documentSnapshot.docs.map((doc) => PostCardModel.fromJson(doc.data())).toList();
    }
  }
}
