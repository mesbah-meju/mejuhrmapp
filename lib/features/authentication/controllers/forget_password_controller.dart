import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:auth_ui_app/services/api_client.dart';
import 'package:auth_ui_app/utils/constants/api_constants.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';
import '../screens/password_configuration/reset_password.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  final email = TextEditingController();
  final GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  final RxString selectedPortal = 'staff'.obs; // 'staff' or 'manager'
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;

  final RxInt resendCountdown = 30.obs;
  Timer? _resendTimer;

  @override
  void onClose() {
    _resendTimer?.cancel();
    super.onClose();
  }

  void startResendTimer() {
    resendCountdown.value = 30;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCountdown.value > 0) {
        resendCountdown.value--;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> sendPasswordResetEmail() async {
    if (!forgetPasswordFormKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = '';
    successMessage.value = '';

    final targetEmail = email.text.trim();
    final portal = selectedPortal.value;

    final endpoint = portal == 'manager'
        ? ApiConstants.forgotPasswordManagerEndpoint
        : ApiConstants.forgotPasswordStaffEndpoint;

    final payload = {
      'email': targetEmail,
      'login_type': portal,
      'module': 'Hrm',
    };

    try {
      final response = await ApiClient.instance.post<Map<String, dynamic>>(
        endpoint,
        body: payload,
        fromJson: (json) => Map<String, dynamic>.from(json is Map ? json : {}),
      );

      isLoading.value = false;

      if (response.isSuccess) {
        final msg = response.message.isNotEmpty
            ? response.message
            : "We have emailed your password reset link!";
        successMessage.value = msg;
        startResendTimer();
        Get.to(() => ResetPasswordScreen(
              email: targetEmail,
              portal: portal,
            ));
      } else {
        String err = response.message;

        if (response.statusCode == 422 && response.errors != null) {
          if (response.errors is Map && (response.errors as Map).containsKey('email')) {
            final emailErrs = (response.errors as Map)['email'];
            if (emailErrs is List && emailErrs.isNotEmpty) {
              err = emailErrs.first.toString();
            }
          }
        }

        errorMessage.value = err;
        THelperFunctions.showSnackBar(err);
      }
    } catch (e) {
      isLoading.value = false;
      final err = "An unexpected error occurred: $e";
      errorMessage.value = err;
      THelperFunctions.showSnackBar(err);
    }
  }

  Future<void> resendPasswordResetEmail(String targetEmail) async {
    if (resendCountdown.value > 0) return;

    isLoading.value = true;
    errorMessage.value = '';

    final portal = selectedPortal.value;
    final endpoint = portal == 'manager'
        ? ApiConstants.forgotPasswordManagerEndpoint
        : ApiConstants.forgotPasswordStaffEndpoint;

    final payload = {
      'email': targetEmail,
      'login_type': portal,
      'module': 'Hrm',
    };

    try {
      final response = await ApiClient.instance.post<Map<String, dynamic>>(
        endpoint,
        body: payload,
      );

      isLoading.value = false;

      if (response.isSuccess) {
        startResendTimer();
        THelperFunctions.showSnackBar("Reset email link resent to $targetEmail!");
      } else {
        THelperFunctions.showSnackBar(response.message);
      }
    } catch (e) {
      isLoading.value = false;
      THelperFunctions.showSnackBar("Failed to resend email: $e");
    }
  }
}
