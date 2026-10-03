import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:auth_ui_app/features/authentication/screens/onboarding/onboarding.dart';
import 'package:auth_ui_app/features/hrm/screens/manager/manager_dashboard.dart';
import 'package:auth_ui_app/features/hrm/screens/staff/staff_dashboard_screen.dart';
import 'package:auth_ui_app/services/auth_service.dart';
import 'package:auth_ui_app/utils/constants/image_strings.dart';

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
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _animationController.forward();

    Timer(const Duration(milliseconds: 2400), () {
      if (mounted) {
        if (AuthService.instance.isLoggedIn()) {
          if (AuthService.instance.isManager()) {
            Get.off(
              () => const ManagerDashboardScreen(),
              transition: Transition.fadeIn,
              duration: const Duration(milliseconds: 500),
            );
          } else {
            Get.off(
              () => const HrmDashboardScreen(),
              transition: Transition.fadeIn,
              duration: const Duration(milliseconds: 500),
            );
          }
        } else {
          Get.off(
            () => const OnBoardingScreen(),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 500),
          );
        }
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // mejuHRM App Icon
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF059669).withValues(alpha: 0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      TImages.mejuHrmIcon,
                      width: 86,
                      height: 86,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // mejuHRM Full Logo
                  Image.asset(
                    TImages.mejuHrmLogo,
                    width: 230,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "meju",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF059669),
                                letterSpacing: -0.5,
                              ),
                            ),
                            TextSpan(
                              text: "HRM",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F172A),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 6),

                  const Text(
                    "SALES • Track • GROWTH",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.2,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
