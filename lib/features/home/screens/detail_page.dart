import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/models/reply_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/utils/utils.dart';
import 'detail_comment_list.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var _PostCard = Get.arguments;
  final replyController = TextEditingController();
  CollectionReference reply = FirebaseFirestore.instance
      .collection('posts')
      .doc('cf6rL17wyLgX7r4u4rGA')
      .collection('reply');
  late final List<ReplyModel> replies;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDisplayNameByUid(FirebaseAuth.instance.currentUser!.uid),
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
            body: ListView(
              children: [
                Column(
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
                                      width: MediaQuery.of(context).size.width *
                                          0.89,
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
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 160,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffD9D9D9),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                const SizedBox(width: 13),
                                Container(
                                  width: 160,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffD9D9D9),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 19),
                            Center(
                              child: Container(
                                width: 345,
                                height: 278,
                                decoration: BoxDecoration(
                                  color: const Color(0xffD9D9D9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ]),
                    ),
                    const SizedBox(height: 42),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Divider(
                          color: Theme.of(context).colorScheme.outline,
                          thickness: 1),
                    ),
                    const SizedBox(height: 9),
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
                    const SizedBox(height: 41),
                    SliverList(
                        delegate:
                            SliverChildBuilderDelegate((context, index) {
                              return FutureBuilder(
                                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (snapshot.hasData == false) {
                                      return Container(
                                        width: double.infinity,
                                        height: 50,
                                      );
                                    } else {
                                      DetailCommentList(
                                        username: snapshot.data.displayName,
                                        reply: replies[index].reply,
                                        like: replies[index].likes,
                                        time: replies[index].time,
                                      );
                                    }
                                  });
                            }),
                    ),
                    const SizedBox(
                      width: 376,
                      child: Divider(color: Color(0xffD9D9D9), thickness: 1),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const SizedBox(width: 15),
                        Container(
                          height: 36,
                          width: 36,
                          decoration: const BoxDecoration(
                              color: Color(0xffD9D9D9), shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: SizedBox(
                            width: 252,
                            height: 41.5,
                            child: TextField(
                              controller: replyController,
                              decoration: InputDecoration(
                                hintText: '댓글 쓰기',
                                hintStyle: const TextStyle(fontSize: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                filled: true,
                                fillColor: const Color(0xffD9D9D9),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding: const EdgeInsets.all(10),
                            backgroundColor: const Color(0xffE4E4E4),
                            minimumSize: const Size(48, 42),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          onPressed: () async {
                            final userData = await FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .get();
                            ReplyModel newReply = ReplyModel(
                              time: Timestamp.now(),
                              userName: userData.data()!['displayName'],
                              reply: replyController.text,
                              likes: [],
                              uid: FirebaseAuth.instance.currentUser!.uid,
                            );
                            reply.add(newReply.toJson());
                            replyController.clear();
                          },
                          child: const Text(
                            '게시',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
