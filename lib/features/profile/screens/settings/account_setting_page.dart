import 'package:disko_001/common/utils/utils.dart';
import 'package:disko_001/models/user_model.dart';
import 'package:flutter/material.dart';

import 'change_email_page.dart';

class AccountSettingScreen extends StatelessWidget {
  final UserModel user;
  const AccountSettingScreen({Key? key, required this.user}) : super(key: key);

  static const routeName = '/account-setting-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('계정/정보 관리'),
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
              child: Text("계정 정보",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.black)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '이메일',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                      if (user.email != null)
                        Text(
                          user.email!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.black, fontSize: 15),
                          textAlign: TextAlign.left,
                        ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, EmailEditPage.routeName,
                          arguments: {'user': user});
                    },
                    child: Text(
                      "변경",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '전화번호',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        user.phoneNum,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.black, fontSize: 15),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      showSnackBar(context: context, content: "전화번호 변경은 현재 가능하지 않습니다");
                    },
                    child: Text(
                      "변경",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
