import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:auth_ui_app/features/hrm/screens/manager/manager_dashboard.dart';
import 'package:auth_ui_app/features/hrm/screens/staff/staff_dashboard_screen.dart';
import 'package:auth_ui_app/services/auth_service.dart';
import 'package:auth_ui_app/utils/constants/api_constants.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final hidePassword = true.obs;
  final rememberMe = true.obs;
  final isLoading = false.obs;

  /// Mode selection: 'staff' or 'manager'
  final selectedMode = 'staff'.obs;

  final email = TextEditingController();
  final password = TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _restoreRememberedEmail();
    _restoreSelectedMode();
  }

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    super.onClose();
  }

  void _restoreRememberedEmail() {
    final savedEmail = _storage.read<String>(ApiConstants.storageRememberEmailKey);
    if (savedEmail != null && savedEmail.isNotEmpty) {
      email.text = savedEmail;
      rememberMe.value = true;
    }
  }

  void _restoreSelectedMode() {
    final savedMode = _storage.read<String>(ApiConstants.storageUserModeKey);
    if (savedMode != null && savedMode.isNotEmpty) {
      selectedMode.value = savedMode;
    }
  }

  /// Toggle login mode (Staff vs Manager)
  void setMode(String mode) {
    selectedMode.value = mode;
    _storage.write(ApiConstants.storageUserModeKey, mode);
  }

  /// Sign In with Laravel HRM Backend
  Future<void> emailAndPasswordSignIn() async {
    if (!loginFormKey.currentState!.validate()) return;

    final emailInput = email.text.trim();
    final passwordInput = password.text;

    isLoading.value = true;

    try {
      final result = await AuthService.instance.login(
        email: emailInput,
        password: passwordInput,
        loginType: selectedMode.value,
        deviceName: 'Flutter-App',
      );

      isLoading.value = false;

      if (result['success'] == true) {
        // Save or clear remembered email
        if (rememberMe.value) {
          await _storage.write(ApiConstants.storageRememberEmailKey, emailInput);
        } else {
          await _storage.remove(ApiConstants.storageRememberEmailKey);
        }
        await _storage.write(ApiConstants.storageUserModeKey, selectedMode.value);

        THelperFunctions.showSnackBar(
          result['message'] ?? 'Successfully logged in.',
        );

        // Server permissions determine authorized experience
        if (selectedMode.value == 'manager' || AuthService.instance.isManager()) {
          Get.offAll(
            () => const ManagerDashboardScreen(),
            transition: Transition.fadeIn,
          );
        } else {
          Get.offAll(
            () => const HrmDashboardScreen(),
            transition: Transition.fadeIn,
          );
        }
      } else {
        // Show server message / 403 Forbidden / 401 Unauthorized / validation error
        final errorMessage = result['message'] ?? 'Authentication failed. Please check your email and password.';
        Get.snackbar(
          'Login Failed',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Connection Error',
        'Unable to connect to the server. Please check your network connection.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void googleSignIn() {
    THelperFunctions.showSnackBar('Single Sign-On (SSO) is managed by your organization.');
  }

  void facebookSignIn() {
    THelperFunctions.showSnackBar('Single Sign-On (SSO) is managed by your organization.');
  }
}
