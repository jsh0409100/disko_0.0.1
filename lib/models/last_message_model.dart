import 'package:cloud_firestore/cloud_firestore.dart';

class LastMessageModel {
  final bool isReceiverOnline,isSenderOnline;
  final int unreadMessageCount;
  final String senderId,
      text,
      receiverUid,
      senderDisplayName,
      receiverDisplayName,

      profilePic;
  final Timestamp timeSent;

  LastMessageModel({
    required this.isReceiverOnline,
    required this.isSenderOnline,
    required this.unreadMessageCount,
    required this.senderId,
    required this.text,
    required this.receiverUid,
    required this.receiverDisplayName,
    required this.senderDisplayName,
    required this.timeSent,
    required this.profilePic,
  });

  LastMessageModel.fromJson(Map<String, dynamic> json)
      : senderId = json['senderId'],
        text = json['text'],
        timeSent = json['timeSent'],
        receiverUid = json['receiverUid'],
        isReceiverOnline = json['isReceiverOnline'],
        isSenderOnline = json['isSenderOnline'],
        receiverDisplayName = json['receiverDisplayName'],
        senderDisplayName = json['senderDisplayName'],
        profilePic = json['profilePic'],
        unreadMessageCount = json['unreadMessageCount'];

  Map<String, dynamic> toJson() => {
        'senderId': senderId,
        'text': text,
        'timeSent': timeSent,
        'receiverUid': receiverUid,
        'receiverDisplayName': receiverDisplayName,
        'senderDisplayName': senderDisplayName,
        'profilePic': profilePic,
        'unreadMessageCount': unreadMessageCount,
        'isReceiverOnline': isReceiverOnline,
        'isSenderOnline': isSenderOnline,
      };
}
