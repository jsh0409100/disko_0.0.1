import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/home/screens/notification.dart';
import '../../features/search/screens/search.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final AppBar appBar;
  const CommonAppBar({Key? key, required this.title, required this.appBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Get.to(() => const search());
          },
          icon: const Icon(
            Icons.search_outlined,
            color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: () {
            Get.to(() => const NotificationTap());
          },
          icon: const Icon(
            Icons.notifications_none_outlined,
            color: Colors.black,
          ),
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
