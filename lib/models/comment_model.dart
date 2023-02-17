import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String userName, text, uid, commentId;
  final List<String> likes;
  final Timestamp time;

  CommentModel({
    required this.uid,
    required this.time,
    required this.userName,
    required this.text,
    required this.likes,
    required this.commentId,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    var likesFromJson = json['likes'];

    List<String> parsedLikes = likesFromJson.cast<String>();

    return CommentModel(
        time: json['time'],
        userName: json['userName'],
        text: json['text'],
        likes: parsedLikes,
        uid: json['uid'],
        commentId: json['commentId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'userName': userName,
    'text': text,
    'time': time,
    'likes': likes,
    'uid': uid,
    'commentId': commentId,
  };
}
