import 'dart:core';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {
  final Uri EMAIL = Uri(
      scheme: 'mailto',
      path: 'letsdisko2023@gmail.com',
      queryParameters: {'subject':'문의 및 건의하기', 'body':'1.문의내용\n2.디스코메일계정:'}
  );

  void email() async {
    if(await canLaunchUrl(EMAIL)) {
      await launchUrl(EMAIL);
    } else {
      throw 'error email';
    }
  }
}