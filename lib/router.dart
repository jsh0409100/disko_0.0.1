import 'package:disko_001/app_layout_screen.dart';
import 'package:disko_001/features/home/screens/detail_page.dart';
import 'package:disko_001/features/profile/screens/setting_page.dart';
import 'package:disko_001/features/starting/landing_pages/landing_page.dart';
import 'package:disko_001/test.dart';
import 'package:flutter/material.dart';

import 'common/widgets/error_screen.dart';
import 'features/auth/screens/login_page.dart';
import 'features/auth/screens/signup_page.dart';
import 'features/chat/screens/chat_screen.dart';
import 'features/report/report_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LandingPage.routeName:
      return MaterialPageRoute(
        builder: (context) => LandingPage(),
      );
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
    case DetailPage.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final postId = arguments['postId'];
      return MaterialPageRoute(
        builder: (context) => DetailPage(postId: postId),
      );
    case TestScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final payload = arguments['postId'];
      return MaterialPageRoute(
        builder: (context) => TestScreen(payload: payload),
      );
    case ChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final peerUid = arguments['peerUid'];
      return MaterialPageRoute(
        builder: (context) => ChatScreen(
          peerUid: peerUid,
        ),
      );
    case ReportScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final reportedUid = arguments['reportedUid'];
      final reportedDisplayName = arguments['reportedDisplayName'];
      return MaterialPageRoute(
        builder: (context) => ReportScreen(
          reportedUid: reportedUid,
          reportedDisplayName: reportedDisplayName,
        ),
      );
    case SettingScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SettingScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesn\'t exist'),
        ),
      );
  }
}
