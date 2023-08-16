import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/features/home/widgets/post_card.dart';
import 'package:disko_001/models/user_model.dart';
import 'package:flutter/material.dart';

import '../../../common/utils/utils.dart';
import '../../../models/post_card_model.dart';
import '../screens/detail_page.dart';

class Post extends StatefulWidget {
  final PostCardModel post;

  const Post({Key? key, required this.post}) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: getUserDataByUid(widget.post.uid),
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
                  Navigator.pushNamed(
                    context,
                    DetailPage.routeName,
                    arguments: {
                      'post': widget.post,
                    },
                  );
                },
                child: PostCard(post: widget.post, user: snapshot.data),
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
