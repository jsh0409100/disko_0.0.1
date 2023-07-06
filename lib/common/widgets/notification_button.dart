import 'package:disko_001/features/notification/controller/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnreadNotificationCounter extends ConsumerWidget {
  const UnreadNotificationCounter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.read(notificationCounterStreamProvider.stream);
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        return snapshot.hasData && snapshot.data != 0
            ? Positioned(
                left: 23,
                top: 13,
                child: Container(
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                  width: 12.0,
                  height: 12.0,
                  child: Text(
                    snapshot.data.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 8),
                  ),
                ))
            : Container(width: 0.0);
      },
    );
  }
}
