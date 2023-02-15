import 'package:cloud_firestore/cloud_firestore.dart';

import '../common/enums/notification_enum.dart';

class NotificationModel {
  final String peerUid, postId, commentId, postTitle;
  final NotificationEnum notificationType;
  final Timestamp time;
  final bool seen;

  NotificationModel({
    required this.peerUid,
    required this.time,
    required this.postTitle,
    required this.notificationType,
    required this.postId,
    required this.seen,
    required this.commentId,
  });

  NotificationModel.fromJson(Map<String, dynamic> json)
      : peerUid = json['peerUid'],
        postId = json['postId'],
        time = json['time'],
        postTitle = json['postTitle'],
        commentId = json['commentId'],
        seen = json['seen'],
        notificationType = (json['notificationType'] as String).toEnum();

  Map<String, dynamic> toJson() => {
        'peerUid': peerUid,
        'postId': postId,
        'seen': seen,
        'commentId': commentId,
        'time': time,
        'postTitle': postTitle,
        'notificationType': notificationType.type,
      };
}
