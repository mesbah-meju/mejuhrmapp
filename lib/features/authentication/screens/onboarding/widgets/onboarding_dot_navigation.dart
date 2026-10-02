import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:auth_ui_app/features/authentication/controllers/onboarding_controller.dart';

class TOnBoardingDotNavigation extends StatelessWidget {
  const TOnBoardingDotNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;

    return Positioned(
      bottom: 36,
      left: 24,
      child: SmoothPageIndicator(
        count: 3,
        controller: controller.pageController,
        onDotClicked: controller.dotNavigationClick,
        effect: const ExpandingDotsEffect(
          activeDotColor: Color(0xFF059669),
          dotColor: Color(0xFFE2E8F0),
          dotHeight: 6,
          dotWidth: 6,
          expansionFactor: 3.5,
          spacing: 6,
        ),
      ),
    );
  }
}
