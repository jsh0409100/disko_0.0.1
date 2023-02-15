import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/notification_model.dart';
import '../repository/notification_repository.dart';

final notificationControllerProvider = Provider((ref) {
  final notificationRepository = ref.watch(notificationRepositoryProvider);
  return NotificationController(
    notificationRepository: notificationRepository,
    ref: ref,
  );
});

class NotificationController {
  final NotificationRepository notificationRepository;
  final ProviderRef ref;
  NotificationController({
    required this.notificationRepository,
    required this.ref,
  });

  Stream<List<NotificationModel>> notificationStream() {
    return notificationRepository.getNotificationStream();
  }

  Future<List<NotificationModel>> notifications() {
    return notificationRepository.getNotifications();
  }

  void markNotificationAsSeen(NotificationModel notification) {
    ref.read(notificationRepositoryProvider).markNotificationAsSeen(notification);
  }
}

final notificationCounterStreamProvider = StreamProvider<int>((ref) async* {
  final stream = ref.watch(notificationControllerProvider).notificationStream();
  await for (var event in stream) {
    if (event.isNotEmpty) {
      final newNotification = event.where((element) => !element.seen).toList();
      yield newNotification.length;
    }
  }
});
