import 'package:disko_001/features/notification/screen/notification_screen.dart';
import 'package:flutter/material.dart';

import '../../features/search/screens/search.dart';
import 'notification_button.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final AppBar appBar;
  final bool showActions;
  const CommonAppBar({
    Key? key,
    required this.title,
    required this.appBar,
    required this.showActions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      actions: showActions ? [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, SearchScreen.routeName);
          },
          icon: const Icon(
            Icons.search_outlined,
            color: Colors.black,
          ),
        ),
        Stack(children: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.notifications_none_outlined,
              color: Colors.black,
            ),
          ),
          const UnreadNotificationCounter(),
        ]),
      ] : null,
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
