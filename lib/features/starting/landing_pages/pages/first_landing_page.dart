import 'package:flutter/material.dart';

class FirstLandingPage extends StatefulWidget {
  const FirstLandingPage({Key? key}) : super(key: key);

  @override
  State<FirstLandingPage> createState() => _FirstLandingPageState();
}

class _FirstLandingPageState extends State<FirstLandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(27.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 86),
                const Text(
                  '낯선 곳에서',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 38),
                ),
                const Text(
                  '낯익은 우리',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 38),
                ),
                const Text(
                  '하나가 되는 순간!',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 38),
                ),
                const SizedBox(
                  height: 10,
                ),
                Image.asset('assets/disco-ball-shiny.gif'),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '한인 대표 커뮤니티',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary),
                ),
                Text(
                  'DISKO',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 40,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
