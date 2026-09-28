import 'package:flutter/material.dart';

import 'package:auth_ui_app/utils/constants/sizes.dart';
import 'package:auth_ui_app/utils/device/device_utility.dart';
import 'package:auth_ui_app/features/authentication/controllers/onboarding_controller.dart';

class TOnBoardingSkipButton extends StatelessWidget {
  const TOnBoardingSkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;

    return Positioned(
      top: TDeviceUtils.getAppBarHeight(),
      right: TSizes.defaultSpace,
      child: TextButton(onPressed: controller.skipPage, child: const Text('Skip')),
    );
  }
}
