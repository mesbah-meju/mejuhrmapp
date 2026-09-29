import 'package:flutter/material.dart';
import 'package:get/get.dart';

class THelperFunctions {
  static void showSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize([BuildContext? context]) {
    final ctx = context ?? Get.context;
    if (ctx != null) {
      return MediaQuery.of(ctx).size;
    }
    return const Size(390, 844);
  }

  static double screenHeight([BuildContext? context]) {
    final ctx = context ?? Get.context;
    if (ctx != null) {
      return MediaQuery.of(ctx).size.height;
    }
    return 844.0;
  }

  static double screenWidth([BuildContext? context]) {
    final ctx = context ?? Get.context;
    if (ctx != null) {
      return MediaQuery.of(ctx).size.width;
    }
    return 390.0;
  }
}
