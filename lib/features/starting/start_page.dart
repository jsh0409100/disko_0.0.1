import 'package:disko_001/features/auth/screens/signup_page.dart';
import 'package:flutter/material.dart';

import '../auth/screens/login_page.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.57,
            child: Column(
              children: [
                Image.asset('assets/disko_icon.png'),
                Text(
                  'DISKO',
                  style: TextStyle(
                    fontSize: 46,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(
                width: 224,
                height: 55,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              '앱의 위치 런타임 권한',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                              ),
                            ),
                            content: Container(
                              width: 300,
                              child: const Text(
                                'DISKO는 앱이 종료되었거나 사용 중이 아닐 때도 위치 데이터를 수집하여 사용자 위치 데이터를 사용한 "약속잡기" 기능을 지원합니다.',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            insetPadding: const EdgeInsets.fromLTRB(0, 80, 0, 80),
                            actions: [
                              TextButton(
                                child: const Text(
                                  '확인',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, SignUpScreen.routeName);
                                },
                              ),
                            ],
                          );
                        });
                  },
                  child: Text(
                    '🥳  회원가입  →',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 22),
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: const Size.fromHeight(51),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.routeName);
                },
                child: Text(
                  '로그인',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 17),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
