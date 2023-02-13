import 'package:cloud_firestore/cloud_firestore.dart';

import '../common/enums/notification_enum.dart';

class NotificationModel {
  final String peerUid, postId;
  final NotificationEnum notificationType;
  final Timestamp time;

  NotificationModel({
    required this.peerUid,
    required this.time,
    required this.notificationType,
    required this.postId,
  });

  NotificationModel.fromJson(Map<String, dynamic> json)
      : peerUid = json['peerUid'],
        postId = json['postId'],
        time = json['time'],
        notificationType = (json['notificationType'] as String).toEnum();

  Map<String, dynamic> toJson() => {
        'peerUid': peerUid,
        'postId': postId,
        'time': time,
        'notificationType': notificationType.type,
      };
}
