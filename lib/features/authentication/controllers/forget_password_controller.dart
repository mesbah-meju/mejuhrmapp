import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:auth_ui_app/utils/helpers/helper_functions.dart';
import '../screens/password_configuration/reset_password.dart';

/// UI-only forget password controller (no Firebase / backend).
class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  void sendPasswordResetEmail() {
    if (!forgetPasswordFormKey.currentState!.validate()) return;
    Get.to(() => ResetPasswordScreen(email: email.text.trim()));
  }

  void resendPasswordResetEmail(String email) {
    THelperFunctions.showSnackBar('UI only — reset email would be resent to $email');
  }
}
