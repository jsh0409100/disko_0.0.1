import 'package:disko_001/features/auth/screens/signup_page.dart';
import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  final bool isSignUp;

  const StartPage({required this.isSignUp, Key? key}) : super(key: key);

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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => SignUpScreen(isSignUp: true)));
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
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => SignUpScreen(isSignUp: false)));
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
