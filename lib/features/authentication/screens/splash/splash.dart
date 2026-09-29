import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:auth_ui_app/features/authentication/screens/onboarding/onboarding.dart';
import 'package:auth_ui_app/utils/constants/colors.dart';
import 'package:auth_ui_app/utils/constants/sizes.dart';
import 'package:auth_ui_app/utils/constants/text_strings.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _animationController.forward();

    Timer(const Duration(milliseconds: 2800), () {
      if (mounted) {
        Get.off(
          () => const OnBoardingScreen(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 600),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: dark
                ? [
                    const Color(0xFF0F172A),
                    const Color(0xFF1E293B),
                    const Color(0xFF0F172A),
                  ]
                : [
                    const Color(0xFFF8FAFC),
                    const Color(0xFFEEF2FF),
                    const Color(0xFFE0E7FF),
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              // Animated Logo and Title
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // HRM Logo Badge
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer glow circle
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: TColors.primary.withOpacity(0.28),
                                  blurRadius: 36,
                                  spreadRadius: 8,
                                ),
                              ],
                            ),
                          ),
                          // Gradient Emblem Container
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF3B82F6),
                                  Color(0xFF1D4ED8),
                                  Color(0xFF4338CA),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF1D4ED8).withOpacity(0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Iconsax.people,
                                size: 54,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // Secondary badge overlay (Verified HR Check)
                          Positioned(
                            bottom: 10,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: dark ? const Color(0xFF0F172A) : Colors.white,
                                  width: 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF10B981).withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.spaceBtwSections),

                      // App Name
                      Text(
                        TTexts.appName,
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                              color: dark ? Colors.white : const Color(0xFF1E293B),
                            ),
                      ),
                      const SizedBox(height: TSizes.sm),

                      // Tagline
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
                        child: Text(
                          TTexts.splashSubTitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: dark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF64748B),
                                letterSpacing: 0.3,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Bottom Loading & Version Indicator
              FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: TSizes.defaultSpace),
                  child: Column(
                    children: [
                      // Elegant Mini Progress
                      SizedBox(
                        width: 48,
                        height: 3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: const LinearProgressIndicator(
                            backgroundColor: Color(0xFFCBD5E1),
                            valueColor: AlwaysStoppedAnimation<Color>(TColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                      Text(
                        "v2.4.0 • Enterprise Edition",
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: dark
                                  ? const Color(0xFF64748B)
                                  : const Color(0xFF94A3B8),
                              letterSpacing: 0.8,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
