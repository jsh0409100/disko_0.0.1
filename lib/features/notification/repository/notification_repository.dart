import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/enums/notification_enum.dart';
import '../../../models/notification_model.dart';

final notificationRepositoryProvider = Provider(
  (ref) => NotificationRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class NotificationRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  NotificationRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<List<NotificationModel>> getNotificationStream() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('notification')
        .orderBy('time', descending: true)
        .snapshots()
        .map((event) {
      List<NotificationModel> notifications = [];
      for (var document in event.docs) {
        notifications.add(NotificationModel.fromJson(document.data()));
      }
      return notifications;
    });
  }

  Future<List<NotificationModel>> getNotifications() async {
    // List<NotificationModel> notifications = [];
    final documentSnapshot = await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('notification')
        .orderBy('time', descending: true)
        .get();
    return documentSnapshot.docs.map((doc) => NotificationModel.fromJson(doc.data())).toList();
  }

  void markNotificationAsSeen(NotificationModel notification) async {
    final String notificationId =
        (notification.notificationType == NotificationEnum.like) ? 'like' : notification.commentId;

    final String docName = '${notification.postId}&${notification.peerUid}&$notificationId';
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('notification')
        .doc(docName)
        .update({'seen': true});
  }
}
