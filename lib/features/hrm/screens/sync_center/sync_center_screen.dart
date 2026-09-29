import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:auth_ui_app/services/offline_storage_service.dart';
import 'package:auth_ui_app/services/sync_controller.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class SyncCenterScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const SyncCenterScreen({super.key, this.onBack});

  @override
  State<SyncCenterScreen> createState() => _SyncCenterScreenState();
}

class _SyncCenterScreenState extends State<SyncCenterScreen> {
  final syncController = SyncController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF1E293B)),
          onPressed: widget.onBack ?? () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Sync Center & Offline Health",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
      ),
      body: Obx(() {
        final isOnline = syncController.isOnline.value;
        final isSyncing = syncController.isSyncing.value;
        final pendingCount = syncController.pendingCount.value;
        final pendingActions = OfflineStorageService.instance.getPendingActions();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Sync Health Card
              _buildHealthCard(isOnline, isSyncing, pendingCount),
              const SizedBox(height: 16),

              // 2. Module Sync Breakdown
              const Text(
                "MODULE SYNCHRONIZATION STATUS",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              _buildModuleBreakdown(pendingActions),
              const SizedBox(height: 20),

              // 3. Pending / Failed Items List
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "PENDING CHANGES (${pendingActions.length})",
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5),
                  ),
                  if (pendingActions.isNotEmpty && isOnline)
                    TextButton(
                      onPressed: () => syncController.syncPendingActions(),
                      child: const Text("Sync All Now", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              if (pendingActions.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Column(
                    children: [
                      Icon(Iconsax.cloud_change, size: 36, color: Color(0xFF10B981)),
                      SizedBox(height: 8),
                      Text("All Changes Synced", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      SizedBox(height: 4),
                      Text("Your device is up to date with the server.", style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    ],
                  ),
                )
              else
                ...pendingActions.map((action) => _buildPendingActionCard(action)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHealthCard(bool isOnline, bool isSyncing, int pendingCount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    !isOnline ? Iconsax.wifi_square : Iconsax.cloud_change,
                    color: !isOnline ? const Color(0xFFDC2626) : const Color(0xFF2563EB),
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        !isOnline ? "Network Connection: Offline" : "Network Connection: Online",
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      Text(
                        "Last Synced: ${syncController.lastSyncedAt.value}",
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ],
              ),
              Switch(
                value: isOnline,
                activeColor: const Color(0xFF2563EB),
                onChanged: (val) => syncController.toggleOfflineMode(),
              ),
            ],
          ),
          const Divider(height: 20, color: Color(0xFFF1F5F9)),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isSyncing
                      ? null
                      : () {
                          if (!isOnline) {
                            THelperFunctions.showSnackBar("Switched to Online mode");
                            syncController.toggleOfflineMode();
                          } else {
                            syncController.syncPendingActions();
                          }
                        },
                  icon: isSyncing
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Iconsax.refresh, size: 16),
                  label: Text(isSyncing ? "Syncing..." : "Sync Now"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModuleBreakdown(List<OfflineAction> pendingActions) {
    final tasksPending = pendingActions.where((a) => a.actionType.contains('task')).length;
    final attPending = pendingActions.where((a) => a.actionType.contains('attendance')).length;
    final salesPending = pendingActions.where((a) => a.actionType.contains('target')).length;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          _buildModuleRow("Tasks Module", tasksPending),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          _buildModuleRow("Attendance Module", attPending),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          _buildModuleRow("Sales & Targets Module", salesPending),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          _buildModuleRow("Employee Profile & Preferences", 0),
        ],
      ),
    );
  }

  Widget _buildModuleRow(String title, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1E293B))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: count > 0 ? const Color(0xFFFEF3C7) : const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              count > 0 ? "$count Pending" : "Synced",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: count > 0 ? const Color(0xFFD97706) : const Color(0xFF16A34A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingActionCard(OfflineAction action) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Iconsax.document_upload, size: 18, color: Color(0xFF2563EB)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action.actionType.replaceAll('_', ' ').toUpperCase(),
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 2),
                Text(
                  "Created: ${action.createdAt.substring(11, 16)}",
                  style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                ),
                if (action.lastError != null)
                  Text(
                    "Reason: ${action.lastError}",
                    style: const TextStyle(fontSize: 10, color: Color(0xFFDC2626)),
                  ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {
              syncController.syncPendingActions();
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              minimumSize: Size.zero,
            ),
            child: const Text("Retry", style: TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }
}
