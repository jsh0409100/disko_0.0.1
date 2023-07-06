import 'package:disko_001/app_layout_screen.dart';
import 'package:disko_001/features/starting/landing_pages/landing_page.dart';
import 'package:disko_001/features/starting/start_page.dart';
import 'package:flutter/material.dart';

import 'common/widgets/error_screen.dart';
import 'features/auth/screens/login_page.dart';
import 'features/auth/screens/signup_page.dart';
import 'features/chat/screens/chat_screen.dart';

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
    case ChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final peerUid = arguments['peerUid'];
      return MaterialPageRoute(
        builder: (context) => ChatScreen(
          peerUid: peerUid,
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesn\'t exist'),
        ),
      );
  }
}
