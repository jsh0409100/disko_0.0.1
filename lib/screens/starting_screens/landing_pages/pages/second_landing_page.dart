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
        padding: const EdgeInsets.all(27.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DISKO 에서',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 38),
                ),
                const Text(
                  '누릴 수 있는',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 38),
                ),
                const Text(
                  'funfun한 경험들',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 38),
                ),
                const SizedBox(
                  height: 10,
                ),
                Image.asset('assets/dancing.gif'),
                const SizedBox(height: 45),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  '함께하실 준비가 되었나요?',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
