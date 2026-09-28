import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:auth_ui_app/utils/constants/colors.dart';
import 'package:auth_ui_app/utils/constants/sizes.dart';
import 'package:auth_ui_app/utils/device/device_utility.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';
import 'package:auth_ui_app/features/authentication/controllers/onboarding_controller.dart';

class TOnBoardingDotNavigation extends StatelessWidget {
  const TOnBoardingDotNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    final dark = THelperFunctions.isDarkMode(context);

    return Positioned(
      bottom: TDeviceUtils.getBottomNavigationBarHeight() + 25,
      left: TSizes.defaultSpace,
      child: SmoothPageIndicator(
        count: 3,
        controller: controller.pageController,
        onDotClicked: controller.dotNavigationClick,
        effect: ExpandingDotsEffect(activeDotColor: dark ? TColors.white : TColors.black, dotHeight: 6),
      ),
    );
  }
}
