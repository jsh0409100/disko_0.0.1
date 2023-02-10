import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/features/home/widgets/bottom_comment_field.dart';
import 'package:disko_001/features/home/widgets/comment_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../../common/utils/utils.dart';

class DetailPage extends ConsumerStatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  final _PostCard = Get.arguments;
  final replyController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');
  bool _isLiked = false;
  Color likeColor = Colors.black;
  Icon likeIcon = const Icon(Icons.favorite_border);

  @override
  Widget build(BuildContext context) {
    if (_PostCard.likes.contains(user!.uid)) {
      likeColor = Theme.of(context).colorScheme.primary;
      likeIcon = const Icon(Icons.favorite);
    } else {
      likeColor = Colors.black;
      likeIcon = const Icon(Icons.favorite_border);
    }

    return FutureBuilder(
        future: getUserDataByUid(FirebaseAuth.instance.currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.grey[50],
              title: Text(
                _PostCard.postCategory,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 17),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height / 1.125,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 22, vertical: 8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image(
                                      image: NetworkImage(_PostCard.profilePic),
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
                                      _PostCard.userName,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(_PostCard.postCategory,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800)),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 23,
                            ),
                            FittedBox(
                              fit: BoxFit.contain,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _PostCard.postTitle,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 20),
                              ),
                            ),
                            const SizedBox(height: 13),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  child: Text(
                                    _PostCard.postText,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                _PostCard.imagesUrl.isEmpty
                                    ? Container()
                                    : Padding(
                                        padding: const EdgeInsets.all(3),
                                        child: Container(
                                          height:
                                              MediaQuery.of(context).size.height / 3,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: _PostCard.imagesUrl.length,
                                            dragStartBehavior: DragStartBehavior.start,
                                            itemBuilder:
                                                (BuildContext context, int index) {
                                              return Padding(
                                                padding: const EdgeInsets.all(2),
                                                child: Image.network(
                                                    _PostCard.imagesUrl[index],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ]),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Divider(
                          color: Theme.of(context).colorScheme.outline,
                          thickness: 1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () async {
                            FirebaseFirestore.instance
                                .collection('posts')
                                .doc(_PostCard.postId)
                                .get();
                            if (_PostCard.likes.contains(user!.uid)) {
                              _PostCard.likes.remove(user!.uid);
                              setState(() {
                                _isLiked = false;
                              });
                            } else {
                              _PostCard.likes.add(user!.uid);
                              setState(() {
                                _isLiked = true;
                              });
                            }
                            await postsCollection.doc(_PostCard.postId).update({
                              'likes': _PostCard.likes,
                            });
                          },
                          icon: likeIcon,
                          color: likeColor,
                        ),
                        Text(_PostCard.likes.length.toString()),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.chat_outlined,
                            color: Colors.black,
                          ),
                        ),
                        Text(_PostCard.comment_count.toString()),
                        const SizedBox(width: 8),
                      ],
                    ),
                    Expanded(
                      child: CommentList(
                        postId: _PostCard.postId,
                      ),
                    ),
                    BottomCommentField(
                      profilePic: snapshot.data.profilePic,
                      postId: _PostCard.postId,
                      comment_count: _PostCard.comment_count,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
