import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:auth_ui_app/common/widgets/appbar/appbar.dart';
import 'package:auth_ui_app/features/authentication/controllers/forget_password_controller.dart';
import 'package:auth_ui_app/utils/constants/image_strings.dart';
import 'package:auth_ui_app/utils/validators/validation.dart';
import '../login/login.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ForgetPasswordController>()
        ? Get.find<ForgetPasswordController>()
        : Get.put(ForgetPasswordController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TAppBar(
        showBackArrow: true,
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(CupertinoIcons.clear, color: Color(0xFF64748B)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. BRAND LOGO & TAGLINE (MATCHING LOGIN HEADER)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF059669).withValues(alpha: 0.12),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        TImages.mejuHrmIcon,
                        width: 58,
                        height: 58,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Image.asset(
                      TImages.mejuHrmLogo,
                      width: 175,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "meju",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF059669),
                                  letterSpacing: -0.5,
                                ),
                              ),
                              TextSpan(
                                text: "HRM",
                                style: TextStyle(
                                  fontSize: 24,
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
                    const SizedBox(height: 4),
                    const Text(
                      "SALES • TRACK • GROWTH",
                      style: TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 3. STAFF vs MANAGER PORTAL MODE SELECTOR (MATCHING LOGIN FORM)
              Obx(
                () => Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.selectedPortal.value = 'staff',
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            decoration: BoxDecoration(
                              color: controller.selectedPortal.value == 'staff' ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: controller.selectedPortal.value == 'staff'
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.04),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Iconsax.user,
                                  size: 15,
                                  color: controller.selectedPortal.value == 'staff'
                                      ? const Color(0xFF059669)
                                      : const Color(0xFF64748B),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Staff Experience",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: controller.selectedPortal.value == 'staff'
                                        ? const Color(0xFF059669)
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.selectedPortal.value = 'manager',
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            decoration: BoxDecoration(
                              color: controller.selectedPortal.value == 'manager' ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: controller.selectedPortal.value == 'manager'
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.04),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Iconsax.user_octagon,
                                  size: 15,
                                  color: controller.selectedPortal.value == 'manager'
                                      ? const Color(0xFF059669)
                                      : const Color(0xFF64748B),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Manager Portal",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: controller.selectedPortal.value == 'manager'
                                        ? const Color(0xFF059669)
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Portal Hint Badge
              Obx(() {
                final isManager = controller.selectedPortal.value == 'manager';
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isManager ? Iconsax.shield_tick : Iconsax.info_circle,
                        size: 14,
                        color: const Color(0xFF059669),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          isManager
                              ? "Restricted to HR, Admin, or Manager accounts."
                              : "Restricted to registered Staff members.",
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              // 4. DYNAMIC ERROR BANNER (FOR DEACTIVATION, ACCESS DENIED, NOT FOUND)
              Obx(() {
                final err = controller.errorMessage.value;
                if (err.isEmpty) return const SizedBox.shrink();

                Color bg = const Color(0xFFFEF2F2);
                Color border = const Color(0xFFFECACA);
                Color text = const Color(0xFF991B1B);
                IconData icon = Iconsax.warning_2;

                if (err.contains("deactivated") || err.contains("disabled")) {
                  bg = const Color(0xFFFFFBEB);
                  border = const Color(0xFFFDE68A);
                  text = const Color(0xFF92400E);
                  icon = Iconsax.lock_circle;
                } else if (err.contains("restricted") || err.contains("denied")) {
                  bg = const Color(0xFFFAF5FF);
                  border = const Color(0xFFE9D5FF);
                  text = const Color(0xFF6B21A8);
                  icon = Iconsax.shield_cross;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: border),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(icon, color: text, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          err,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: text,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              // 5. EMAIL INPUT FORM FIELD (MATCHING LOGIN FORM THEME)
              Form(
                key: controller.forgetPasswordFormKey,
                child: TextFormField(
                  controller: controller.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: TValidator.validateEmail,
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500, color: Color(0xFF0F172A)),
                  decoration: InputDecoration(
                    labelText: "Email Address",
                    hintText: "Enter your registered email",
                    hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                    prefixIcon: const Icon(Iconsax.direct_right, color: Color(0xFF059669), size: 19),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF059669), width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 6. SUBMIT BUTTON (MATCHING LOGIN FORM THEME)
              Obx(() {
                final loading = controller.isLoading.value;
                return SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: loading ? null : controller.sendPasswordResetEmail,
                    child: loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                          )
                        : const Text(
                            "Send Reset Link",
                            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
                          ),
                  ),
                );
              }),

              const SizedBox(height: 20),

              // 7. BACK TO LOGIN BUTTON
              Center(
                child: TextButton.icon(
                  onPressed: () => Get.offAll(() => const LoginScreen()),
                  icon: const Icon(Icons.arrow_back_rounded, size: 15, color: Color(0xFF059669)),
                  label: const Text(
                    "Back to Login",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF059669),
                    ),
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
