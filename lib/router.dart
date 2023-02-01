import 'package:disko_001/app_layout_screen.dart';
import 'package:flutter/material.dart';

import 'common/widgets/error_screen.dart';
import 'features/auth/screens/login_page.dart';
import 'features/auth/screens/signup_page.dart';
import 'features/chat/screens/chat_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SignUpScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      );
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case AppLayoutScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const AppLayoutScreen(),
      );
    case ChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final peerUid = arguments['peerUid'];
      final peerDisplayName = arguments['peerDisplayName'];
      return MaterialPageRoute(
        builder: (context) => ChatScreen(
          peerUid: peerUid,
          peerDisplayName: peerDisplayName,
        ),
      );
    // case SelectContactsScreen.routeName:
    //   return MaterialPageRoute(
    //     builder: (context) => const SelectContactsScreen(),
    //   );
    // case MobileChatScreen.routeName:
    //   final arguments = settings.arguments as Map<String, dynamic>;
    //   final name = arguments['name'];
    //   final uid = arguments['uid'];
    //   final isGroupChat = arguments['isGroupChat'];
    //   final profilePic = arguments['profilePic'];
    //   return MaterialPageRoute(
    //     builder: (context) => MobileChatScreen(
    //       name: name,
    //       uid: uid,
    //       isGroupChat: isGroupChat,
    //       profilePic: profilePic,
    //     ),
    //   );
    // case ConfirmStatusScreen.routeName:
    //   final file = settings.arguments as File;
    //   return MaterialPageRoute(
    //     builder: (context) => ConfirmStatusScreen(
    //       file: file,
    //     ),
    //   );
    // case StatusScreen.routeName:
    //   final status = settings.arguments as Status;
    //   return MaterialPageRoute(
    //     builder: (context) => StatusScreen(
    //       status: status,
    //     ),
    //   );
    // case CreateGroupScreen.routeName:
    //   return MaterialPageRoute(
    //     builder: (context) => const CreateGroupScreen(),
    //   );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesn\'t exist'),
        ),
      );
  }
}
