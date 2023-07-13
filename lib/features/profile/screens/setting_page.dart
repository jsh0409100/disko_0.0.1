import 'package:flutter/material.dart';

import '../../../common/utils/utils.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  static const routeName = '/setting-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('설정'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
          elevation: 0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Color(0xFFF9F9F9),
              padding: const EdgeInsets.all(8.0),
              child: Text("알림설정",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.black)),
            ),
            const SettingOption(
              option: "알림 및 소리",
              action: null,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('방해금지 시간 설정',
                    style:
                        Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.black)),
                Switch(
                  value: false,
                  onChanged: (value) {},
                  inactiveThumbColor: Theme.of(context).colorScheme.outline,
                ),
              ],
            ),
            Container(
              width: double.infinity,
              color: Color(0xFFF9F9F9),
              padding: const EdgeInsets.all(8.0),
              child: Text("계정설정",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.black)),
            ),
            const SettingOption(
              option: "계정, 정보 관리",
              action: null,
            ),
            const SettingOption(
              option: "차단 사용자 관리",
              action: null,
            ),
            Container(
              width: double.infinity,
              color: const Color(0xFFF9F9F9),
              padding: const EdgeInsets.all(8.0),
              child: Text("기타설정",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.black)),
            ),
            const SettingOption(
              option: " FAQ",
              action: null,
            ),
            const SettingOption(
              option: "국가변경",
              action: null,
            ),
            const SettingOption(
              option: "업데이트",
              action: null,
            ),
            const SettingOption(
              option: "로그아웃",
              action: null,
            ),
            const SettingOption(
              option: "탈퇴하기",
              action: null,
            ),
          ],
        ));
  }
}

class SettingOption extends StatelessWidget {
  final String option;
  final Function? action;

  const SettingOption({
    Key? key,
    required this.option,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      buttonColor: action == null ? const Color(0xFFFCFCFC) : const Color(0xFFFFFFFF),
      child: SizedBox(
          width: double.infinity,
          child: TextButton(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                option,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.black),
                textAlign: TextAlign.left,
              ),
            ),
            onPressed: () =>
                {showSnackBar(context: context, content: "로그아웃, 탈퇴하기를 제외한 모든 설정은 준비중에 있습니다.")},
          )),
    );
  }
}
