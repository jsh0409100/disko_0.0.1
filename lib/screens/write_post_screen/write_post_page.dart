import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/screens/write_post_screen/widgets/select_category.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/post_card_model.dart';
import '../home_screen/home.dart';

class WritePostPage extends StatefulWidget {
  const WritePostPage({Key? key}) : super(key: key);

  @override
  State<WritePostPage> createState() => _WritePostPageState();
}

class _WritePostPageState extends State<WritePostPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController postTitleController = TextEditingController();
  TextEditingController postTextController = TextEditingController();
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            shape: const Border(
                bottom: BorderSide(color: Colors.black, width: 0.5)),
            centerTitle: true,
            title: const Text(
              '글쓰기',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    categoryDialogBuilder(context);
                  },
                  child: const Text(
                    '다음',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
            ]),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Column(children: [
              TextField(
                controller: postTitleController,
                maxLength: 15,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                  hintText: '제목',
                ),
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              Expanded(
                flex: 10,
                //TODO 오버플로우 해결 방법 찾기
                child: TextField(
                  controller: postTextController,
                  expands: true,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        top: 10, left: 24, right: 24, bottom: 0),
                    hintText: '글작성',
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(
                        color: Colors.black,
                        width: 0.5,
                      ))),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add_reaction_outlined),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.photo_camera_outlined),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    )),
              )
            ]);
          },
        ));
  }

  Future<void> categoryDialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            child: AlertDialog(
              contentPadding: EdgeInsets.all(6.0),
              title: const Text('카테고리 선택'),
              content: Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: const [
                  CategoryCard(categoryIcon: "🔥", categoryName: "현지생활"),
                  CategoryCard(categoryIcon: "🛍️", categoryName: "중고거래"),
                  CategoryCard(categoryIcon: "👩🏻‍💻", categoryName: "구인구직"),
                  CategoryCard(categoryIcon: "✈️", categoryName: "여행"),
                  CategoryCard(categoryIcon: "🏠", categoryName: "한인숙박"),
                  CategoryCard(categoryIcon: "🍳", categoryName: "요리"),
                  CategoryCard(categoryIcon: "😀", categoryName: "고민상당"),
                  CategoryCard(categoryIcon: "🚖 🌤️", categoryName: "교통/날씨"),
                  CategoryCard(categoryIcon: "🎓", categoryName: "유학생활"),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('취소'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('게시'),
                  onPressed: () {
                    PostCardModel newPost = PostCardModel(
                        userName: FirebaseAuth.instance.currentUser!.uid,
                        postTitle: postTitleController.text,
                        postCategory: "요리",
                        postText: postTextController.text);
                    posts.add(newPost.toJson());
                    postTextController.clear();
                    postTitleController.clear();
                    Get.to(() => const MyHome());
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
