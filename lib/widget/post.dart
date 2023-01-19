import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/widget/post_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/post_card_model.dart';
import '../screens/home_screen/detail_page.dart';
import '../src/tools.dart';

class Post extends StatefulWidget {
  final String userName, postCategory, postTitle, postText, uid;
  final List<String> likes;

  const Post({
    Key? key,
    // required this.uid,
    required this.userName,
    required this.postCategory,
    required this.postTitle,
    required this.postText,
    required this.uid,
    required this.likes,
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
            return const Center(child: CircularProgressIndicator());
          }
          return Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.92),
              child: GestureDetector(
                onTap: () {
                  Get.to(
                    const DetailPage(),
                    arguments: PostCard(
                        userName: snapshot.data.toString(),
                        postCategory: widget.postCategory,
                        postTitle: widget.postTitle,
                        postText: widget.postText,
                        uid: widget.uid,
                        likes: widget.likes),
                  );
                },
                child: PostCard(
                    userName: snapshot.data.toString(),
                    postCategory: widget.postCategory,
                    postTitle: widget.postTitle,
                    postText: widget.postText,
                    uid: widget.uid,
                    likes: widget.likes),
              ));
        });
  }
}

class PostsDatabase {
  Future<List<PostCardModel>> fetchPosts(PostCardModel? post) async {
    final postsCollectionRef = FirebaseFirestore.instance.collection('posts');

    if (post == null) {
      final documentSnapshot = await postsCollectionRef
          .orderBy('time', descending: true)
          .limit(5)
          .get();
      return documentSnapshot.docs
          .map((doc) => PostCardModel.fromJson(doc.data()))
          .toList();
    } else {
      final documentSnapshot = await postsCollectionRef
          .orderBy('time', descending: true)
          .startAfter([post.time])
          .limit(5)
          .get();
      return documentSnapshot.docs
          .map((doc) => PostCardModel.fromJson(doc.data()))
          .toList();
    }
  }
}
