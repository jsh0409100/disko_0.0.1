import 'package:flutter/material.dart';

class ThirdLandingPage extends StatefulWidget {
  const ThirdLandingPage({Key? key}) : super(key: key);

  @override
  State<ThirdLandingPage> createState() => _ThirdLandingPageState();
}

class _ThirdLandingPageState extends State<ThirdLandingPage> {
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
                  '신뢰하는,',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 38),
                ),
                const Text(
                  '커뮤니티',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 38),
                ),
                const SizedBox(
                  height: 100,
                ),
                Image.asset(
                  'assets/third_page_img.png',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth,
                ),
                const SizedBox(
                  height: 100,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: const Text(
                    'DISKO는 재외동포 대상, 즉 한인 디아스포라(Diaspora Korean)분들을 위한 ‘신뢰할 수 있는 앱 기반 커뮤니티 플랫폼 서비스’ 를 제공하고자 합니다.',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
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
