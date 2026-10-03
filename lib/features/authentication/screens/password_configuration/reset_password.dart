import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:auth_ui_app/common/widgets/appbar/appbar.dart';
import 'package:auth_ui_app/features/authentication/controllers/forget_password_controller.dart';
import 'package:auth_ui_app/utils/constants/image_strings.dart';
import 'package:auth_ui_app/utils/constants/sizes.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';
import '../login/login.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({
    super.key,
    required this.email,
    this.portal = 'staff',
  });

  final String email;
  final String portal;

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ForgetPasswordController>()
        ? Get.find<ForgetPasswordController>()
        : Get.put(ForgetPasswordController());

    final bool isManager = portal == 'manager';
    final String portalLabel = isManager ? "Manager Portal" : "Staff Experience";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TAppBar(
        actions: [
          IconButton(
            onPressed: () => Get.offAll(() => const LoginScreen()),
            icon: const Icon(CupertinoIcons.clear, color: Color(0xFF64748B)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. BRAND EMBLEM / ILLUSTRATION
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFA7F3D0), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF059669).withValues(alpha: 0.12),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      TImages.deliveredEmailIllustration,
                      width: THelperFunctions.screenWidth() * 0.4,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.mark_email_read_rounded,
                        size: 48,
                        color: Color(0xFF059669),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 2. PAGE TITLE
                const Text(
                  "Password Reset Link Sent!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),

                // 3. TARGET EMAIL & PORTAL CHIP
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.email_outlined, size: 15, color: Color(0xFF059669)),
                      const SizedBox(width: 8),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF059669),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          portalLabel,
                          style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 4. SUBTITLE & INSTRUCTIONS
                const Text(
                  "Your password reset link has been dispatched to your email. Please check your inbox and follow the instructions to secure your workplace account.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 28),

                // 5. PRIMARY RETURN BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => Get.offAll(() => const LoginScreen()),
                    child: const Text("Return to Sign In", style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),

                // 6. RESEND LINK WITH TIMER COUNTDOWN
                Obx(() {
                  final seconds = controller.resendCountdown.value;
                  final isCanResend = seconds == 0;

                  return Column(
                    children: [
                      TextButton.icon(
                        onPressed: isCanResend ? () => controller.resendPasswordResetEmail(email) : null,
                        icon: Icon(
                          Icons.refresh_rounded,
                          size: 16,
                          color: isCanResend ? const Color(0xFF059669) : const Color(0xFF94A3B8),
                        ),
                        label: Text(
                          isCanResend ? "Resend Reset Link" : "Resend Link in ${seconds}s",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isCanResend ? const Color(0xFF059669) : const Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Didn't receive the email? Check your spam folder or tap above to request a new link.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
