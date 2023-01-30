import 'package:cloud_firestore/cloud_firestore.dart';

class LastMessageModel {
  final bool isSeen;
  final int unreadMessageCount;
  final String senderId,
      text,
      receiverUid,
      senderDisplayName,
      receiverDisplayName;
  final Timestamp timeSent;

  LastMessageModel({
    required this.isSeen,
    required this.unreadMessageCount,
    required this.senderId,
    required this.text,
    required this.receiverUid,
    required this.receiverDisplayName,
    required this.senderDisplayName,
    required this.timeSent,
  });

  LastMessageModel.fromJson(Map<String, dynamic> json)
      : senderId = json['senderId'],
        text = json['text'],
        timeSent = json['timeSent'],
        receiverUid = json['receiverUid'],
        isSeen = json['isSeen'],
        receiverDisplayName = json['receiverDisplayName'],
        senderDisplayName = json['senderDisplayName'],
        unreadMessageCount = json['unreadMessageCount'];

  Map<String, dynamic> toJson() => {
        'senderId': senderId,
        'text': text,
        'timeSent': timeSent,
        'receiverUid': receiverUid,
        'receiverDisplayName': receiverDisplayName,
        'senderDisplayName': senderDisplayName,
        'unreadMessageCount': unreadMessageCount,
        'isSeen': isSeen,
      };
}
