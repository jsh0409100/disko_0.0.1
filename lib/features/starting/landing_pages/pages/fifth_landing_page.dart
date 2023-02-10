import 'package:flutter/material.dart';

class FifthLandingPage extends StatefulWidget {
  const FifthLandingPage({Key? key}) : super(key: key);

  @override
  State<FifthLandingPage> createState() => _FifthLandingPageState();
}

class _FifthLandingPageState extends State<FifthLandingPage> {
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
                  '조각을 모아,',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 38),
                ),
                const Text(
                  '미러볼 완성',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 38),
                ),
                const SizedBox(
                  height: 57,
                ),
                Center(
                  child: Image.asset(
                    'assets/fifth_page_img.png',
                    width: MediaQuery.of(context).size.width * 0.62,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                const SizedBox(
                  height: 57,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: const FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      'DISKO에서 활동하는 모든 경험과 순간이  모여 형성되는 신뢰의 미러볼을 완성해주세요 ! ',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
