import 'package:disko_001/features/starting/landing_pages/pages/first_landing_page.dart';
import 'package:disko_001/features/starting/landing_pages/pages/second_landing_page.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LandingPage extends StatelessWidget {
  final _controller = PageController();

  LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.95,
            child: PageView(
              controller: _controller,
              children: const [
                FirstLandingPage(),
                SecondLandingPage(),
              ],
            ),
          ),
          SmoothPageIndicator(
            controller: _controller,
            count: 2,
            effect: ColorTransitionEffect(
              dotHeight: 13,
              dotWidth: 13,
              dotColor: Color(0xFFDD9D9D9),
              activeDotColor: Theme.of(context).colorScheme.primary,
            ),
          )
        ],
      ),
    );
  }
}
