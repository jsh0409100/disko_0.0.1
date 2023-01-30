import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/features/write_post/screens/widgets/select_category.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app_layout_screen.dart';
import '../../../models/category_list.dart';
import '../../../models/post_card_model.dart';

class WritePostPage extends StatefulWidget {
  const WritePostPage({Key? key}) : super(key: key);

  @override
  State<WritePostPage> createState() => _WritePostPageState();
}

class _WritePostPageState extends State<WritePostPage> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFileList = [];
  List<String> _arrImageUrls = [];
  final FirebaseStorage _storageRef = FirebaseStorage.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController postTitleController = TextEditingController();
  TextEditingController postTextController = TextEditingController();
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  bool _isLoading = false;

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
            return _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(children: [
                    TextField(
                      controller: postTitleController,
                      maxLength: 15,
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                        hintText: '제목',
                      ),
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                    Expanded(
                      flex: 75,
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
                    _imageFileList == 0
                        ? Padding(
                            padding: EdgeInsets.all(10),
                            child: Text("No Images Selected"),
                          )
                        : Expanded(
                            flex: 15,
                            child: GridView.builder(
                              itemCount: _imageFileList?.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4),
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Image.file(
                                    File(_imageFileList![index].path),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                    Expanded(
                      flex: 10,
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
                                  onPressed: () {
                                    selectImage();
                                  },
                                ),
                              ],
                            ),
                          )),
                    )
                  ]);
          },
        ));
  }

  Future<void> categoryDialogBuilder(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();
    var _CategoryCards = CategoryCards(selected: 0);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            child: AlertDialog(
              contentPadding: const EdgeInsets.all(0.0),
              title: const Text('카테고리 선택'),
              content: _CategoryCards,
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
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await uploadFunction(_imageFileList!);
                    PostCardModel newPost = PostCardModel(
                      userName: userData.data()!['displayName'],
                      postTitle: postTitleController.text,
                      postCategory:
                          CategoryList.categories[_CategoryCards.selected],
                      postText: postTextController.text,
                      time: Timestamp.now(),
                      uid: currentUser.uid,
                      likes: [],
                      imagesUrl: _arrImageUrls,
                      //postImage:
                    );
                    posts.add(newPost.toJson());
                    postTextController.clear();
                    postTitleController.clear();
                    Get.to(() => const AppLayoutScreen());
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> uploadFunction(List<XFile> _images) async {
    setState(() {
      _isLoading = true;
    });
    for (int i = 0; i < _images.length; i++) {
      var imageUrl = await uploadFile(_images[i]);
      _arrImageUrls.add(imageUrl.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<String> uploadFile(XFile _image) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();
    Reference reference = _storageRef
        .ref()
        .child(userData.data()!['displayName'])
        .child(_image.name);
    UploadTask uploadTask = reference.putFile(File(_image.path));
    await uploadTask.whenComplete(() {
      print(reference.getDownloadURL());
    });

    return await reference.getDownloadURL();
  }

  Future<void> selectImage() async {
    if (_imageFileList != null) {
      _imageFileList?.clear();
    }
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        _imageFileList?.addAll(images);
      }
      print("List of selected images : " + images.length.toString());
    } catch (e) {
      print("Something Wrong." + e.toString());
    }
    setState(() {});
  }
}