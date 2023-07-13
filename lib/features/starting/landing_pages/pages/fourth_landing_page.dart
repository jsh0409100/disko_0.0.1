import 'package:flutter/material.dart';

class FourthLandingPage extends StatefulWidget {
  const FourthLandingPage({Key? key}) : super(key: key);

  @override
  State<FourthLandingPage> createState() => _FourthLandingPageState();
}

class _FourthLandingPageState extends State<FourthLandingPage> {
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
                  '신뢰도,',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 38),
                ),
                const Text(
                  'UP!',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 38),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.2),
                        offset: Offset(0, 2), //(x,y)
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 16,
                          ),
                          Image.asset(
                            'assets/fourth_page_01.gif',
                            width: MediaQuery.of(context).size.width * 0.3,
                            fit: BoxFit.fitWidth,
                          ),
                          const Text(
                            '좋아요 많은 글',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 16,
                          ),
                          Image.asset(
                            'assets/fourth_page_02.gif',
                            width: MediaQuery.of(context).size.width * 0.3,
                            fit: BoxFit.fitWidth,
                          ),
                          const Text(
                            '댓글 답변',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 16,
                          ),
                          Image.asset(
                            'assets/fourth_page_03.gif',
                            width: MediaQuery.of(context).size.width * 0.3,
                            fit: BoxFit.contain,
                          ),
                          const Text(
                            '게시물 작성',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: const Text(
                    '다양한 미션들을 완수하여 조각과 신뢰도를 쌓아보세요!',
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
