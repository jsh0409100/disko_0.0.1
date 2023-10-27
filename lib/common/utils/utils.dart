import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/post_card_model.dart';
import '../../models/user_model.dart';
import '../enums/country_enum.dart';

Future<String> getDisplayNameByUid(String uid) async {
  var UserDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  return UserDoc.data()!['displayName'];
}

Future<UserDataModel> getUserDataByUid(String uid) async {
  var userDataMap = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  return UserDataModel.fromJson(userDataMap.data()!);
}

Future<List<String>> getFollowByUid(String uid) async{
  var userFollow = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  return userFollow.data()!['follow'];
}

Future<List<DocumentSnapshot>> getScrapListByUid(String uid) async{
  QuerySnapshot userScrap = await FirebaseFirestore.instance.collection('users').doc(uid).collection('Scrap').get();
  return userScrap.docs;
}


Stream<UserDataModel> getUserStreamByUid(String uid) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .snapshots()
      .map((snapshot) => UserDataModel.fromJson(snapshot.data()!));
}

Future<PostCardModel> getPostByPostId(UserDataModel user, String postId) async {
  var postDataMap = await FirebaseFirestore.instance.collection('posts').doc(countries[user.countryCode]).collection(countries[user.countryCode]!).doc(postId).get();
  return PostCardModel.fromJson(postDataMap.data()!);
}

Stream<UserDataModel> getUserDataByUidStream(String Uid) async* {
  var userDataMap = await FirebaseFirestore.instance.collection('users').doc(Uid).get();
  yield UserDataModel.fromJson(userDataMap.data()!);
}

String getChatName(String receiverUid, String myUid) {
  return (receiverUid.compareTo(myUid) > 0) ? '$receiverUid-${myUid}' : '${myUid}-$receiverUid';
}

Future<void> resetUnreadMessageCount(String chatName) async {
  final currentChat = FirebaseFirestore.instance.collection('messages').doc(chatName);
  await currentChat.update({"unreadMessageCount": 0});
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    // showSnackBar(context: context, content: e.toString());
  }
  return image;
}

Future<File?> pickImageFromCamera(BuildContext context) async {
  File? image;
  try {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    // showSnackBar(context: context, content: e.toString());
  }
  return image;
}

Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? video;
  try {
    final pickedVideo = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      video = File(pickedVideo.path);
    }
  } catch (e) {
    // showSnackBar(context: context, content: e.toString());
  }
  return video;
}

// Future<GiphyGif?> pickGIF(BuildContext context) async {
//   GiphyGif? gif;
//   try {
//     gif = await Giphy.getGif(
//       context: context,
//       apiKey: 'ir3MM88Ooh05qspuNR9UDkMnLeNBts3k',
//     );
//   } catch (e) {
//     showSnackBar(context: context, content: e.toString());
//   }
//   return gif;
// }

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

String readTimestamp(Timestamp time) {
  var now = DateTime.now();
  var date = time.toDate();
  var diff = now.difference(date);
  var timediff = '';
  if (diff.inDays > 7) {
    timediff = '${(diff.inDays / 7).floor().toString()}주 전';
  } else if (diff.inDays > 0 && diff.inDays < 7) {
    timediff = '${diff.inDays.toString()}일 전';
  } else if (diff.inHours > 0 && diff.inDays == 0) {
    timediff = '${diff.inHours.toString()}시간 전';
  } else if (diff.inMinutes > 0) {
    timediff = '${diff.inMinutes.toString()}분 전';
  } else {
    timediff = '${diff.inSeconds.toString()}초 전';
  }

  return timediff;
}
