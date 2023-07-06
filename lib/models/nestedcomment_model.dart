import 'package:cloud_firestore/cloud_firestore.dart';

class NestedCommentModel {
  final String userName, text, uid, commentId, nestedcommentId;
  final List<String> likes;
  final Timestamp time;

  NestedCommentModel({
    required this.uid,
    required this.time,
    required this.userName,
    required this.text,
    required this.likes,
    required this.commentId,
    required this.nestedcommentId,
  });

  factory NestedCommentModel.fromJson(Map<String, dynamic> json) {
    var likesFromJson = json['likes'];

    List<String> parsedLikes = likesFromJson.cast<String>();

    return NestedCommentModel(
        time: json['time'],
        userName: json['userName'],
        text: json['text'],
        likes: parsedLikes,
        uid: json['uid'],
        commentId: json['commentId'],
        nestedcommentId: json['nestedcommentId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'userName': userName,
    'text': text,
    'time': time,
    'likes': likes,
    'uid': uid,
    'commentId': commentId,
    'nestedcommentId': nestedcommentId,
  };
}
