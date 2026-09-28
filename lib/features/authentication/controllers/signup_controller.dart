import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:auth_ui_app/utils/helpers/helper_functions.dart';
import '../screens/signup/verify_email.dart';

/// UI-only signup controller (no Firebase / backend).
class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final email = TextEditingController();
  final lastName = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final phoneNumber = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  void signup() {
    if (!signupFormKey.currentState!.validate()) return;

    if (!privacyPolicy.value) {
      THelperFunctions.showSnackBar('Please accept Privacy Policy & Terms of Use.');
      return;
    }

    Get.to(() => VerifyEmailScreen(email: email.text.trim()));
  }
}
