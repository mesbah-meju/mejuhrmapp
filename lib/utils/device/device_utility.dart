import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TDeviceUtils {
  static double getBottomNavigationBarHeight() {
    return kBottomNavigationBarHeight;
  }

  static double getAppBarHeight() {
    return kToolbarHeight;
  }

  static void launchWebsiteUrl(String address) async {
    final Uri url = Uri.parse(address);
    if (!await launchUrl(url)) {
      if (kDebugMode) print('Could not launch $url');
    }
  }
}
