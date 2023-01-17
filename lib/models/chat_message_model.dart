import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String senderId, message;
  final Timestamp time;

  ChatMessageModel({
    required this.time,
    required this.senderId,
    required this.message,
  });

  ChatMessageModel.fromJson(Map<String, dynamic> json)
      : senderId = json['senderId'],
        message = json['message'],
        time = json['time'];

  Map<String, dynamic> toJson() => {
        'senderId': senderId,
        'message': message,
        'time': time,
      };
}
