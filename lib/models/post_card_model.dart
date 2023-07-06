import 'package:cloud_firestore/cloud_firestore.dart';

class PostCardModel {
  final String userName, postCategory, postTitle, postText, uid, postId;
  final List<String> likes, imagesUrl;
  final Timestamp time;
  final int commentCount;

  PostCardModel({
    required this.time,
    required this.userName,
    required this.postCategory,
    required this.postTitle,
    required this.postText,
    required this.uid,
    required this.likes,
    required this.imagesUrl,
    required this.postId,
    required this.commentCount,
  });

  factory PostCardModel.fromJson(Map<String, dynamic> json) {
    var likesFromJson = json['likes'];
    var iUrlFromJson = json['imagesUrl'];

    List<String> parsedLikes = likesFromJson.cast<String>();
    List<String> parsedUrl = iUrlFromJson.cast<String>();

    return PostCardModel(
      time: json['time'],
      userName: json['userName'],
      postCategory: json['category'],
      postTitle: json['postTitle'],
      postText: json['postText'],
      uid: json['uid'],
      likes: parsedLikes,
      imagesUrl: parsedUrl,
      postId: json['postId'],
      commentCount: json['commentCount'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'postTitle': postTitle,
        'category': postCategory,
        'postText': postText,
        'time': time,
        'uid': uid,
        'likes': likes,
        'imagesUrl': imagesUrl,
        'postId': postId,
        'commentCount': commentCount,
      };
  Map<String, dynamic> toUser() => {
    'postId': postId,
  };
}
