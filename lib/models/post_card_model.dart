import 'package:cloud_firestore/cloud_firestore.dart';

class PostCardModel {
  final String userName, postCategory, postTitle, postText, uid;
  final Timestamp time;

  PostCardModel({
    required this.time,
    required this.userName,
    required this.postCategory,
    required this.postTitle,
    required this.postText,
    required this.uid,
    //required this.postImage
  });

  PostCardModel.fromJson(Map<String, dynamic> json)
      : userName = json['userName'],
        postTitle = json['postTitle'],
        postCategory = json['category'],
        postText = json['postText'],
        uid = json['uid'],
        time = json['time'];
  //postImage = json['postImage'];

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'postTitle': postTitle,
        'category': postCategory,
        'postText': postText,
        'time': time,
        'uid': uid,
        //'postImage' : postImage
      };
}
