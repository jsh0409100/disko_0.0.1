import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String senderId, message, receiverUid;
  final Timestamp time;

  ChatMessageModel({
    required this.time,
    required this.senderId,
    required this.message,
    required this.receiverUid,
  });

  ChatMessageModel.fromJson(Map<String, dynamic> json)
      : senderId = json['senderId'],
        message = json['message'],
        time = json['time'],
        receiverUid = json['receiverUid'];

  Map<String, dynamic> toJson() => {
        'senderId': senderId,
        'message': message,
        'time': time,
        'receiverUid': receiverUid
      };
}
