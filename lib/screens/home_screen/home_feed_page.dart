import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/models/post_card_model.dart';
import 'package:disko_001/screens/write_post_screen/write_post_page.dart';
import 'package:disko_001/widget/post_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeFeedPage extends StatelessWidget {
  const HomeFeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Stream<List<PostCardModel>> readPosts() => FirebaseFirestore.instance
        .collection('posts')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PostCardModel.fromJson(doc.data()))
            .toList());

    return Scaffold(
      body: StreamBuilder<List<PostCardModel>>(
          stream: readPosts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount: 9,
                // TOOO item count 자동 해놓기
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                itemBuilder: (context, index) {
                  final post = snapshot.data![index];
                  return PostCard(
                    userName: post.userName,
                    postTitle: post.postTitle,
                    postCategory: post.postCategory,
                    postText: post.postText,
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Get.to(() => const WritePostPage());
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        child: Icon(
          Icons.edit,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
