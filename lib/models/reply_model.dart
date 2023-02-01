import 'package:cloud_firestore/cloud_firestore.dart';

class ReplyModel {
  final String userName, reply;
  final List<String> likes;
  final Timestamp time;

  ReplyModel({
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
    );
  }


  Map<String, dynamic> toJson() => {
    'userName': userName,
    'reply': reply,
    'time': time,
    'likes': likes,
  };
}
