import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String senderId, text, receiverUid;
  final Timestamp timeSent;

  ChatMessageModel({
    required this.timeSent,
    required this.senderId,
    required this.text,
    required this.receiverUid,
  });

  ChatMessageModel.fromJson(Map<String, dynamic> json)
      : senderId = json['senderId'],
        text = json['text'],
        timeSent = json['timeSent'],
        receiverUid = json['receiverUid'];

  Map<String, dynamic> toJson() => {
        'senderId': senderId,
        'text': text,
        'timeSent': timeSent,
        'receiverUid': receiverUid
      };
}
