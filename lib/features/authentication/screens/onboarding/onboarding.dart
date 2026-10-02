import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:auth_ui_app/utils/constants/text_strings.dart';
import 'package:auth_ui_app/features/authentication/controllers/onboarding_controller.dart';
import 'widgets/onboarding_dot_navigation.dart';
import 'widgets/onboarding_next_button.dart';
import 'widgets/onboarding_page.dart';
import 'widgets/onboarding_skip_button.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: controller.pageController,
              onPageChanged: controller.updatePageIndicator,
              children: const [
                OnBoardingPage(
                  slideType: HrmSlideType.salesPerformance,
                  title: TTexts.onBoardingTitle1,
                  subTitle: TTexts.onBoardingSubTitle1,
                ),
                OnBoardingPage(
                  slideType: HrmSlideType.targetsProgress,
                  title: TTexts.onBoardingTitle2,
                  subTitle: TTexts.onBoardingSubTitle2,
                ),
                OnBoardingPage(
                  slideType: HrmSlideType.commissionGrowth,
                  title: TTexts.onBoardingTitle3,
                  subTitle: TTexts.onBoardingSubTitle3,
                ),
              ],
            ),
            const TOnBoardingSkipButton(),
            const TOnBoardingDotNavigation(),
            const TOnBoardingNextButton(),
          ],
        ),
      ),
    );
  }
}
