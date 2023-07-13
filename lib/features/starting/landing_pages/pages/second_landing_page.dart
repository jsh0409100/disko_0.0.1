import 'package:flutter/material.dart';

class SecondLandingPage extends StatefulWidget {
  const SecondLandingPage({Key? key}) : super(key: key);

  @override
  State<SecondLandingPage> createState() => _SecondLandingPageState();
}

class _SecondLandingPageState extends State<SecondLandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 86),
                const Text(
                  '한인 커뮤니티,',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 38),
                ),
                const Text(
                  '얼마나',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 38),
                ),
                const Text(
                  '신뢰하시나요?',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 38),
                ),
                const SizedBox(
                  height: 100,
                ),
                Image.asset(
                  'assets/second_page_img.png',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth,
                ),
                const SizedBox(
                  height: 105,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
