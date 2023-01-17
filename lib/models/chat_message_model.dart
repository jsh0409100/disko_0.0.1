import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String fromId, message, toId;
  final Timestamp time;

  ChatMessageModel({
    required this.time,
    required this.fromId,
    required this.message,
    required this.toId,
  });

  ChatMessageModel.fromJson(Map<String, dynamic> json)
      : fromId = json['fromId'],
        toId = json['toId'],
        message = json['message'],
        time = json['time'];

  Map<String, dynamic> toJson() => {
        'fromId': fromId,
        'toId': toId,
        'message': message,
        'time': time,
      };
}
