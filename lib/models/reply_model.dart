import 'package:cloud_firestore/cloud_firestore.dart';

class ReplyModel {
  final String userName, reply, uid;
  final List<String> likes;
  final Timestamp time;

  ReplyModel({
    required this.uid,
    required this.time,
    required this.userName,
    required this.reply,
    required this.likes,
  });

  factory ReplyModel.fromJson(Map<String, dynamic> json) {
    var likesFromJson = json['likes'];

    List<String> parsedLikes = likesFromJson.cast<String>();

    return ReplyModel(
        time: json['time'],
        userName: json['userName'],
        reply: json['reply'],
        likes: parsedLikes,
        uid: json['uid'],
    );
  }


  Map<String, dynamic> toJson() => {
    'userName': userName,
    'reply': reply,
    'time': time,
    'likes': likes,
    'uid' : uid,
  };
}
