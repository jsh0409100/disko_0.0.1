import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/features/write_post/screens/widgets/select_category.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../app_layout_screen.dart';
import '../controller/write_post_controller.dart';

class WritePostPage extends ConsumerStatefulWidget {
  const WritePostPage({Key? key}) : super(key: key);

  @override
  ConsumerState<WritePostPage> createState() => _ConsumerWritePostPageState();
}

class _ConsumerWritePostPageState extends ConsumerState<WritePostPage> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile>? _imageFileList = [];
  final List<String> _arrImageUrls = [];
  final FirebaseStorage _storageRef = FirebaseStorage.instance;
  late String postId;
  int commentCount = 0;
  bool isQuestion = false;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController postTitleController = TextEditingController();
  TextEditingController postTextController = TextEditingController();
  final posts = FirebaseFirestore.instance.collection('posts');

  bool _isLoading = false;

  Future<void> selectImageFromGallery() async {
    if (_imageFileList != null) {
      _imageFileList?.clear();
    }
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        _imageFileList?.addAll(images);
      }
      print("List of selected images : ${images.length}");
    } catch (e) {
      print("Something Wrong.$e");
    }
    setState(() {});
  }

  Future<void> selectImageFromCamera() async {
    if (_imageFileList != null) {
      _imageFileList?.clear();
    }
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        _imageFileList?.add(image);
      }
    } catch (e) {
      print("Something Wrong.$e");
    }
    setState(() {});
  }

  void _uploadPost() async {
    ref.read(writePostControllerProvider).uploadPost(
          context,
          postTextController.text,
          postTitleController.text,
          _arrImageUrls,
          postId,
          commentCount,
        );
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppLayoutScreen.routeName,
      (route) => false,
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
    Reference reference = _storageRef
        .ref()
        .child('posts')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child(postId)
        .child(_image.name);
    UploadTask uploadTask = reference.putFile(File(_image.path));
    await uploadTask.whenComplete(() {
      print(reference.getDownloadURL());
    });

    return await reference.getDownloadURL();
  }

  @override
  void dispose() {
    super.dispose();
    postTextController.dispose();
    postTitleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            shape: const Border(bottom: BorderSide(color: Colors.black, width: 0.5)),
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
                  onPressed: () async {
                    postId = const Uuid().v1();
                    await uploadFunction(_imageFileList!);
                    Navigator.of(context).pop();
                    _uploadPost();
                  },
                  child: const Text(
                    '완료',
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
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                        hintText: '제목',
                      ),
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                    Expanded(
                      flex: 70,
                      child: TextField(
                        controller: postTextController,
                        expands: true,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 10, left: 24, right: 24, bottom: 0),
                          hintText: '글작성',
                        ),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    _imageFileList == 0
                        ? const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text("No Images Selected"),
                          )
                        : Expanded(
                            flex: 15,
                            child: GridView.builder(
                              itemCount: _imageFileList?.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                      flex: 15,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                  value: isQuestion,
                                  onChanged: (value) {
                                    setState(() {
                                      isQuestion = value!;
                                    });
                                  }),
                              Text(
                                '질문할래요!',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.black),
                              )
                            ],
                          ),
                          Align(
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
                                      icon: const Icon(Icons.photo_camera_outlined),
                                      onPressed: selectImageFromCamera,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.image_outlined),
                                      onPressed: selectImageFromGallery,
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    )
                  ]);
          },
        ));
  }

  Future<void> categoryDialogBuilder(BuildContext context) async {
    final _CategoryCards = CategoryCards(selected: 0);
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
                    postId = const Uuid().v1();
                    Navigator.of(context).pop();
                    await uploadFunction(_imageFileList!);
                    _uploadPost();
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
