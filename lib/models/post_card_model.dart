import 'package:cloud_firestore/cloud_firestore.dart';

class PostCardModel {
  final String userName, postTitle, postText, uid, postId, category;
  final List<String> likes, imagesUrl;
  final Timestamp time;
  final int commentCount;
  final bool isQuestion;

  PostCardModel({
    required this.time,
    required this.userName,
    required this.postTitle,
    required this.postText,
    required this.uid,
    required this.likes,
    required this.imagesUrl,
    required this.postId,
    required this.commentCount,
    required this.isQuestion,
    required this.category,
  });

  factory PostCardModel.fromJson(Map<String, dynamic> json) {
    var likesFromJson = json['likes'];
    var iUrlFromJson = json['imagesUrl'];

    List<String> parsedLikes = likesFromJson.cast<String>();
    List<String> parsedUrl = iUrlFromJson.cast<String>();

    return PostCardModel(
      time: json['time'],
      userName: json['userName'],
      postTitle: json['postTitle'],
      postText: json['postText'],
      uid: json['uid'],
      likes: parsedLikes,
      imagesUrl: parsedUrl,
      postId: json['postId'],
      commentCount: json['commentCount'],
      isQuestion: json['isQuestion'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'postTitle': postTitle,
        'postText': postText,
        'time': time,
        'uid': uid,
        'likes': likes,
        'imagesUrl': imagesUrl,
        'postId': postId,
        'isQuestion': isQuestion,
        'commentCount': commentCount,
        'category': category,
      };

  Map<String, dynamic> toUser() => {
        'postId': postId,
      };
}
