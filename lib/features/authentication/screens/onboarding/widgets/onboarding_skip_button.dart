import 'package:flutter/material.dart';

import 'package:auth_ui_app/features/authentication/controllers/onboarding_controller.dart';

class TOnBoardingSkipButton extends StatelessWidget {
  const TOnBoardingSkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12,
      right: 20,
      child: TextButton(
        onPressed: () => OnBoardingController.instance.skipPage(),
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF64748B),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
        child: const Text(
          'Skip',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13.5,
            color: Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}
