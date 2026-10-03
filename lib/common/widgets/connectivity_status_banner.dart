import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:auth_ui_app/services/sync_controller.dart';

class ConnectivityStatusBanner extends StatelessWidget {
  final bool compact;

  const ConnectivityStatusBanner({
    super.key,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final syncController = SyncController.instance;

    return Obx(() {
      final isOnline = syncController.isOnline.value;

      // When online, do not show any banner or syncing noise — background sync handles everything silently
      if (isOnline) {
        return const SizedBox.shrink();
      }

      const bgColor = Color(0xFFFEF2F2);
      const borderColor = Color(0xFFFCA5A5);
      const textColor = Color(0xFF991B1B);

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: const Row(
          children: [
            Icon(Iconsax.wifi_square, size: 18, color: textColor),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "You're offline. Actions are saved locally and will sync automatically when online.",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
