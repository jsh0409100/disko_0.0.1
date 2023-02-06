import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/features/home/widgets/bottom_comment_field.dart';
import 'package:disko_001/features/home/widgets/comment_list.dart';
import 'package:disko_001/models/reply_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  var _PostCard = Get.arguments;
  final replyController = TextEditingController();
  CollectionReference reply = FirebaseFirestore.instance
      .collection('posts')
      .doc('7cd259c0-a368-11ed-9819-ddbd59478028')
      .collection('reply');
  List<CommentModel>? replies;
  final postId = '7cd259c0-a368-11ed-9819-ddbd59478028';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserDataByUid(FirebaseAuth.instance.currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.grey[50],
              automaticallyImplyLeading: true,
              title: Text(
                _PostCard.postCategory,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 17),
              ),
              centerTitle: true,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22, vertical: 8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        Row(
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  child: Text(
                                    _PostCard.postText,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
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
                Expanded(
                  child: CommentList(
                    postId: postId,
                  ),
                ),
                BottomCommentField(
                  profilePic: snapshot.data.profilePic,
                ),
              ],
            ),
          );
        });
  }
}
