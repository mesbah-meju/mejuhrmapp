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
      final isSyncing = syncController.isSyncing.value;
      final pendingCount = syncController.pendingCount.value;

      // If online and nothing is pending/syncing, show optional compact online badge or nothing
      if (isOnline && pendingCount == 0 && !isSyncing && compact) {
        return const SizedBox.shrink();
      }

      final bgColor = !isOnline
          ? const Color(0xFFFEF2F2)
          : isSyncing
              ? const Color(0xFFEFF6FF)
              : pendingCount > 0
                  ? const Color(0xFFFFFBEB)
                  : const Color(0xFFF0FDF4);

      final borderColor = !isOnline
          ? const Color(0xFFFCA5A5)
          : isSyncing
              ? const Color(0xFF93C5FD)
              : pendingCount > 0
                  ? const Color(0xFFFDE68A)
                  : const Color(0xFF86EFAC);

      final textColor = !isOnline
          ? const Color(0xFF991B1B)
          : isSyncing
              ? const Color(0xFF1E40AF)
              : pendingCount > 0
                  ? const Color(0xFF92400E)
                  : const Color(0xFF166534);

      final icon = !isOnline
          ? Iconsax.wifi_square
          : isSyncing
              ? Iconsax.refresh
              : pendingCount > 0
                  ? Iconsax.cloud_cross
                  : Iconsax.cloud_change;

      final titleText = !isOnline
          ? "Offline Mode (${pendingCount} queued)"
          : isSyncing
              ? "Syncing data with server..."
              : pendingCount > 0
                  ? "$pendingCount items pending sync"
                  : "Connected (All synced)";

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          children: [
            if (isSyncing)
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            else
              Icon(icon, size: 18, color: textColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                titleText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            // Action button
            InkWell(
              onTap: () {
                if (!isOnline) {
                  syncController.toggleOfflineMode();
                } else if (pendingCount > 0) {
                  syncController.syncPendingActions();
                } else {
                  syncController.toggleOfflineMode();
                }
              },
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: textColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  !isOnline
                      ? "Go Online"
                      : pendingCount > 0
                          ? "Sync Now"
                          : "Simulate Offline",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
