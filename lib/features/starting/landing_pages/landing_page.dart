import 'package:disko_001/features/starting/landing_pages/pages/fifth_landing_page.dart';
import 'package:disko_001/features/starting/landing_pages/pages/first_landing_page.dart';
import 'package:disko_001/features/starting/landing_pages/pages/fourth_landing_page.dart';
import 'package:disko_001/features/starting/landing_pages/pages/last_landing_page.dart';
import 'package:disko_001/features/starting/landing_pages/pages/second_landing_page.dart';
import 'package:disko_001/features/starting/landing_pages/pages/third_landing_page.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../app_layout_screen.dart';

class LandingPage extends StatefulWidget {
  static const routeName = '/landing-screen';
  LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool isLastPage = false;
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: PageView(
              controller: _controller,
              children: const [
                FirstLandingPage(),
                SecondLandingPage(),
                ThirdLandingPage(),
                FourthLandingPage(),
                FifthLandingPage(),
                LastLandingPage(),
              ],
              onPageChanged: (index) {
                print(isLastPage);

                print(index);

                if (index == 5) {
                  setState(() {
                    isLastPage = true;
                  });
                } else {
                  isLastPage = false;
                }
                print(isLastPage);
              },
            ),
          ),
          (!isLastPage)
              ? SmoothPageIndicator(
                  controller: _controller,
                  count: 6,
                  effect: ColorTransitionEffect(
                    dotHeight: 13,
                    dotWidth: 13,
                    dotColor: const Color(0xFFDD9D9D9),
                    activeDotColor: Theme.of(context).colorScheme.primary,
                  ),
                )
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 51),
                      backgroundColor: Theme.of(context).colorScheme.primary),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppLayoutScreen.routeName,
                      (route) => false,
                    );
                  },
                  child: const Text(
                    '🎉 시작하기  →',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700),
                  ),
                )
        ],
      ),
    );
  }
}
