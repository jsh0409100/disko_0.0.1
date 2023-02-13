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
}
