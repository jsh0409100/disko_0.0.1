import 'package:cloud_firestore/cloud_firestore.dart';

class PostCardModel {
  final String userName, postCategory, postTitle, postText, uid;
  final List<String> likes;
  final Timestamp time;

  PostCardModel({
    required this.time,
    required this.userName,
    required this.postCategory,
    required this.postTitle,
    required this.postText,
    required this.uid,
    required this.likes,
    //required this.postImage
  });

  factory PostCardModel.fromJson(Map<String, dynamic> json) {
    var likesFromJson = json['likes'];
    List<String> parsedLikes = likesFromJson.cast<String>();

    return PostCardModel(
        time: json['time'],
        userName: json['userName'],
        postCategory: json['category'],
        postTitle: json['postTitle'],
        postText: json['postText'],
        uid: json['uid'],
        likes: parsedLikes);
  }

  //postImage = json['postImage'];

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'postTitle': postTitle,
        'category': postCategory,
        'postText': postText,
        'time': time,
        'uid': uid,
        'likes': likes,
        //'postImage' : postImage
      };
}
