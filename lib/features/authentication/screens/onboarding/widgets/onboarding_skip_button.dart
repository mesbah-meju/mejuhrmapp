import 'package:flutter/material.dart';
import 'package:auth_ui_app/utils/constants/sizes.dart';
import 'package:auth_ui_app/features/authentication/controllers/onboarding_controller.dart';

class TOnBoardingSkipButton extends StatelessWidget {
  const TOnBoardingSkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Positioned(
      top: TSizes.defaultSpace,
      right: TSizes.defaultSpace,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => OnBoardingController.instance.skipPage(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: dark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: dark
                    ? Colors.white.withValues(alpha: 0.15)
                    : Colors.black.withValues(alpha: 0.08),
              ),
            ),
            child: Text(
              'Skip',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: dark ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
