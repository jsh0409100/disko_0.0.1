import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disko_001/features/profile/screens/UrlLauncher.dart';
import 'package:disko_001/features/profile/screens/profile_page.dart';
import 'package:disko_001/features/profile/screens/setting_page.dart';
import 'package:disko_001/features/starting/start_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/utils/utils.dart';
import '../../../common/widgets/common_app_bar.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({Key? key}) : super(key: key);

  _launchEmail() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'letsdisko2023@gmail.com',
      queryParameters: {'subject':'문의 및 건의하기', 'body':'1.문의내용\n\n2.디스코메일계정:'},
    );

    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    } else {
      throw 'Could not launch $params';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('FAQ'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
          elevation: 0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FAQOption(
              option: "✉️문의 하기",
                action: () {
                  _launchEmail();
                }
            ),
            Container(
              width: double.infinity,
              color: Color(0xFFF9F9F9),
              padding: const EdgeInsets.all(8.0),
              child: Text("자주 묻는 질문",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: Colors.black)),
            ),
            const FAQOption(
              option: "게시판 이용규칙을 알려주세요!",
              action: null,
            ),
            const FAQOption(
              option: "조각은 무엇인가요?",
              action: null,
            ),
            const FAQOption(
              option: "조각은 어떻게 하면 얻을 수 있나요?",
              action: null,
            ),
          ],
        ));
  }
}

class FAQOption extends StatelessWidget {
  final String option;
  final Function? action;

  const FAQOption({
    Key? key,
    required this.option,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      buttonColor:
          action == null ? const Color(0xFFFCFCFC) : const Color(0xFFFFFFFF),
      child: SizedBox(
          width: double.infinity,
          child: TextButton(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                option,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: Colors.black),
                textAlign: TextAlign.left,
              ),
            ),
            onPressed: () => {
              action == null
                  ? showSnackBar(
                      context: context,
                      content: "로그아웃, 탈퇴하기를 제외한 모든 설정은 준비중에 있습니다.")
                  : action!()
            },
          )),
    );
  }
}
