import 'package:disko_001/condition.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
                    Text('D I S K O',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            color: Colors.purple,
                          ),
                        )),
                  ],
                ),
              ),
              Column(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.purple,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {},
                    child: const Text(
                      '로그인',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.purple[200],
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {
                      Get.to(() => const ConditionPage());
                    },
                    child: const Text(
                      '회원가입',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
