import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/user_model.dart';
import '../../../starting/start_page.dart';
import 'FAQPage.dart';
import 'account_setting_page.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({Key? key}) : super(key: key);

  static const routeName = '/setting-screen';

  Future<void> _showMyDialog(BuildContext context) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return Builder(builder: (context) {
          final customTheme = Theme.of(context).copyWith(
            dialogTheme: const DialogTheme(
              backgroundColor: Color(0xFFFFFBFF),
            ),
          );

          return Theme(
            data: customTheme,
            child: AlertDialog(
              title: Text(
                '정말로 로그아웃 하시겠습니까?',
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 2,
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        elevation: 2,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: Text('아니요',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.white)),
                    ),
                    TextButton(
                        onPressed: () async {
                          try {
                            print('sign out complete!');
                            await FirebaseAuth.instance.signOut();
                          } catch (e) {
                            print('sign out failed');
                            print(e.toString());
                            return null;
                          }
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => StartPage(
                                        isSignUp: false,
                                      )),
                              (route) => false);
                        },
                        style: TextButton.styleFrom(
                          elevation: 2,
                          backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        child: Text(
                          '로그아웃',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                        )),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserDataModel user = ref.watch(userDataProvider);
    bool isSnackbarDisplayed = false;
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
              child: Text("계정설정",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.black)),
            ),
            SettingOption(
              option: "계정/정보 관리",
              action: () {
                Navigator.pushNamed(context, AccountSettingScreen.routeName,
                    arguments: {'user': user});
              },
            ),
            Container(
              width: double.infinity,
              color: const Color(0xFFF9F9F9),
              padding: const EdgeInsets.all(8.0),
              child: Text("기타설정",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.black)),
            ),
            SettingOption(
              option: "FAQ",
              action: () async {
                Navigator.pushNamed(context, FAQPage.routeName);
              },
            ),
            SettingOption(
                option: "로그아웃",
                action: () async {
                  _showMyDialog(context);
                }),
            SettingOption(
              option: "탈퇴하기",
              action: () {
                if (!isSnackbarDisplayed) {
                  isSnackbarDisplayed = true;
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                        const SnackBar(
                          content: Text("아직 지원하지 않는 기능입니다"),
                          duration: Duration(seconds: 3),
                        ),
                      )
                      .closed
                      .then((reason) {
                    isSnackbarDisplayed = false;
                  });
                }
              },
            ),
          ],
        ));
  }
}

class SettingOption extends StatelessWidget {
  final String option;
  final Function action;

  const SettingOption({
    Key? key,
    required this.option,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      buttonColor: const Color(0xFFFFFFFF),
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
            onPressed: () => {
              action(),
            },
          )),
    );
  }
}
