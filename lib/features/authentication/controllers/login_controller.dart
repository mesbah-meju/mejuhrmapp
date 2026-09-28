import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

/// UI-only login controller (no Firebase / backend).
class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final hidePassword = true.obs;
  final rememberMe = false.obs;
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  void emailAndPasswordSignIn() {
    if (!loginFormKey.currentState!.validate()) return;
    THelperFunctions.showSnackBar('UI only — Firebase login is not connected.');
  }

  void googleSignIn() {
    THelperFunctions.showSnackBar('UI only — Google sign-in is not connected.');
  }

  void facebookSignIn() {
    THelperFunctions.showSnackBar('UI only — Facebook sign-in is not connected.');
  }
}
