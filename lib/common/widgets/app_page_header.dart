import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:auth_ui_app/features/hrm/screens/common/sync_center_screen.dart';
import 'package:auth_ui_app/services/sync_controller.dart';

class AppPageHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final bool showBack;
  final bool showOnlineStatus;
  final Widget? action;
  final List<Widget>? actions;
  final EdgeInsetsGeometry padding;

  const AppPageHeader({
    super.key,
    required this.title,
    this.onBack,
    this.showBack = true,
    this.showOnlineStatus = true,
    this.action,
    this.actions,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
  });

  @override
  Widget build(BuildContext context) {
    final syncController = SyncController.instance;

    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Back chevron + Title
          Expanded(
            child: Row(
              children: [
                if (showBack) ...[
                  IconButton(
                    onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: Color(0xFF0F172A),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 20,
                  ),
                  const SizedBox(width: 12),
                ],
                Flexible(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Right side: Connectivity Status + Action Badge(s)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showOnlineStatus) ...[
                Obx(() {
                  final isOnline = syncController.isOnline.value;

                  if (!isOnline) {
                    return InkWell(
                      onTap: () => Get.to(() => const SyncCenterScreen()),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFFECACA)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.wifi_off_rounded, size: 12, color: Color(0xFFDC2626)),
                            SizedBox(width: 4),
                            Text(
                              "Offline",
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF991B1B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return InkWell(
                    onTap: () => Get.to(() => const SyncCenterScreen()),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFA7F3D0)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.wifi_rounded, size: 12, color: Color(0xFF059669)),
                          SizedBox(width: 4),
                          Text(
                            "Online",
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF065F46),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
              if (action != null) ...[
                const SizedBox(width: 8),
                action!,
              ],
              if (actions != null) ...[
                for (final act in actions!) ...[
                  const SizedBox(width: 8),
                  act,
                ],
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// A stylish rounded action pill button that matches the header style (e.g. History, Filter, Add).
class AppHeaderActionBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color borderColor;
  final Color contentColor;

  const AppHeaderActionBadge({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.backgroundColor = const Color(0xFFEFF6FF),
    this.borderColor = const Color(0xFFDBEAFE),
    this.contentColor = const Color(0xFF2563EB),
  });

  /// Factory preset for History button
  factory AppHeaderActionBadge.history({required VoidCallback onTap}) {
    return AppHeaderActionBadge(
      label: "History",
      icon: Icons.history_rounded,
      onTap: onTap,
      backgroundColor: const Color(0xFFEFF6FF),
      borderColor: const Color(0xFFDBEAFE),
      contentColor: const Color(0xFF2563EB),
    );
  }

  /// Factory preset for Filter button
  factory AppHeaderActionBadge.filter({required VoidCallback onTap}) {
    return AppHeaderActionBadge(
      label: "Filter",
      icon: Icons.filter_list_rounded,
      onTap: onTap,
      backgroundColor: const Color(0xFFF1F5F9),
      borderColor: const Color(0xFFE2E8F0),
      contentColor: const Color(0xFF475569),
    );
  }

  /// Factory preset for Add button
  factory AppHeaderActionBadge.add({required String label, required VoidCallback onTap}) {
    return AppHeaderActionBadge(
      label: label,
      icon: Icons.add_rounded,
      onTap: onTap,
      backgroundColor: const Color(0xFFEFF6FF),
      borderColor: const Color(0xFFBFDBFE),
      contentColor: const Color(0xFF2563EB),
    );
  }

  /// Factory preset for Refresh button
  factory AppHeaderActionBadge.refresh({required VoidCallback onTap}) {
    return AppHeaderActionBadge(
      label: "Refresh",
      icon: Iconsax.refresh,
      onTap: onTap,
      backgroundColor: const Color(0xFFEFF6FF),
      borderColor: const Color(0xFFDBEAFE),
      contentColor: const Color(0xFF2563EB),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: contentColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: contentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
