import 'package:cloud_firestore/cloud_firestore.dart';

import '../common/enums/message_enum.dart';

class ChatMessageModel {
  final String senderId, text, receiverUid, messageId;
  final Timestamp timeSent;
  final MessageEnum type;
  final double? long, lat;

  ChatMessageModel({
    required this.timeSent,
    required this.senderId,
    required this.text,
    required this.receiverUid,
    required this.type,
    required this.messageId,
    required this.long,
    required this.lat,
  });

  ChatMessageModel.fromJson(Map<String, dynamic> json)
      : senderId = json['senderId'],
        text = json['text'],
        timeSent = json['timeSent'],
        type = (json['type'] as String).toEnum(),
        receiverUid = json['receiverUid'],
        messageId = json['messageId'],
        long = json['long'],
        lat = json['lat'];

  Map<String, dynamic> toJson() => {
        'senderId': senderId,
        'text': text,
        'timeSent': timeSent,
        'messageId': messageId,
        'type': type.type,
        'receiverUid': receiverUid,
        'long': long,
        'lat': lat,
      };
}
