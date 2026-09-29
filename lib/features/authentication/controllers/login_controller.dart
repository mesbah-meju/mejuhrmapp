import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:auth_ui_app/features/hrm/screens/dashboard/dashboard.dart';
import 'package:auth_ui_app/features/hrm/screens/manager/manager_dashboard.dart';
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

  /// Toggle login mode
  void setMode(String mode) {
    selectedMode.value = mode;
    _storage.write(ApiConstants.storageUserModeKey, mode);
  }

  /// Quick fill demo test credentials
  void fillDemoCredentials() {
    email.text = 'admin@gmail.com';
    password.text = '1234';
  }

  /// Sign In with Laravel HRM Backend (hrm.mesbahuddin.info)
  Future<void> emailAndPasswordSignIn() async {
    if (!loginFormKey.currentState!.validate()) return;

    final emailInput = email.text.trim();
    final passwordInput = password.text;

    isLoading.value = true;

    try {
      final result = await AuthService.instance.login(
        email: emailInput,
        password: passwordInput,
      );

      isLoading.value = false;

      if (result['success'] == true) {
        // Save or clear remembered email & mode
        if (rememberMe.value) {
          await _storage.write(ApiConstants.storageRememberEmailKey, emailInput);
        } else {
          await _storage.remove(ApiConstants.storageRememberEmailKey);
        }
        await _storage.write(ApiConstants.storageUserModeKey, selectedMode.value);

        THelperFunctions.showSnackBar(
          result['message'] ?? 'Successfully logged in to Metro HRM (${selectedMode.value.toUpperCase()} Mode)!',
        );

        // Server permissions remain authoritative. Route according to selected mode
        if (selectedMode.value == 'manager') {
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
        // Show error message from Laravel API
        final errorMessage = result['message'] ?? 'Authentication failed. Please check credentials.';
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
        'Unable to connect to https://hrm.mesbahuddin.info. $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void googleSignIn() {
    THelperFunctions.showSnackBar('Google Single Sign-On (SSO) for HRM is configured via corporate portal.');
  }

  void facebookSignIn() {
    THelperFunctions.showSnackBar('Corporate SSO via OAuth.');
  }
}
