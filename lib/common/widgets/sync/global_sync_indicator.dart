import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:auth_ui_app/features/hrm/screens/common/sync_center_screen.dart';
import 'package:auth_ui_app/services/sync_controller.dart';

class GlobalSyncIndicator extends StatelessWidget {
  const GlobalSyncIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final syncController = SyncController.instance;

    return Obx(() {
      final isOnline = syncController.isOnline.value;

      Color badgeBg;
      Color badgeBorder;
      Color textColor;
      IconData icon;
      String label;

      if (!isOnline) {
        badgeBg = const Color(0xFFFEF3C7);
        badgeBorder = const Color(0xFFFDE68A);
        textColor = const Color(0xFF92400E);
        icon = Icons.wifi_off_rounded;
        label = "Offline";
      } else {
        badgeBg = const Color(0xFFDCFCE7);
        badgeBorder = const Color(0xFFA7F3D0);
        textColor = const Color(0xFF065F46);
        icon = Icons.wifi_rounded;
        label = "Online";
      }

      return InkWell(
        onTap: () => Get.to(() => const SyncCenterScreen()),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
          decoration: BoxDecoration(
            color: badgeBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: badgeBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12, color: textColor),
              const SizedBox(width: 4.5),
              Text(
                label,
                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: textColor),
              ),
            ],
          ),
        ),
      );
    });
  }
}
