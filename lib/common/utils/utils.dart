import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/user_model.dart';

Future<String> getDisplayNameByUid(String Uid) async {
  var UserDoc =
      await FirebaseFirestore.instance.collection('users').doc(Uid).get();
  return UserDoc.data()!['displayName'];
}

Future<UserModel> getUserDataByUid(String Uid) async {
  var userDataMap =
      await FirebaseFirestore.instance.collection('users').doc(Uid).get();
  return UserModel.fromJson(userDataMap.data()!);
}

Stream<UserModel> getUserDataByUidStream(String Uid) async* {
  var userDataMap =
      await FirebaseFirestore.instance.collection('users').doc(Uid).get();
  yield UserModel.fromJson(userDataMap.data()!);
}

String getChatName(String receiverUid, String myUid) {
  return (receiverUid.compareTo(myUid) > 0)
      ? '$receiverUid-${myUid}'
      : '${myUid}-$receiverUid';
}

Future<void> resetUnreadMessageCount(String chatName) async {
  final currentChat =
      FirebaseFirestore.instance.collection('messages').doc(chatName);
  await currentChat.update({"unreadMessageCount": 0});
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return image;
}

Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? video;
  try {
    final pickedVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      video = File(pickedVideo.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
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
