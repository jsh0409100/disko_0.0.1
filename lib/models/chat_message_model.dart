import 'package:cloud_firestore/cloud_firestore.dart';

import '../common/enums/message_enum.dart';

class ChatMessageModel {
  final String senderId, text, receiverUid, messageId;
  final Timestamp timeSent;
  final MessageEnum type;

  ChatMessageModel({
    required this.timeSent,
    required this.senderId,
    required this.text,
    required this.receiverUid,
    required this.type,
    required this.messageId,
  });

  ChatMessageModel.fromJson(Map<String, dynamic> json)
      : senderId = json['senderId'],
        text = json['text'],
        timeSent = json['timeSent'],
        type = json['type'],
        receiverUid = json['receiverUid'],
        messageId = json['messageId'];

  Map<String, dynamic> toJson() => {
        'senderId': senderId,
        'text': text,
        'timeSent': timeSent,
        'messageId': messageId,
        'type': type,
        'receiverUid': receiverUid
      };
}
