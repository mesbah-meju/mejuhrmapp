import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:auth_ui_app/common/widgets/app_page_header.dart';
import 'package:auth_ui_app/core/database/app_database.dart';
import 'package:auth_ui_app/services/connectivity_service.dart';
import 'package:auth_ui_app/services/sync_controller.dart';

class SyncCenterScreen extends StatefulWidget {
  const SyncCenterScreen({super.key});

  @override
  State<SyncCenterScreen> createState() => _SyncCenterScreenState();
}

class _SyncCenterScreenState extends State<SyncCenterScreen> {
  final SyncController syncController = SyncController.instance;
  String _selectedFilter = 'All'; // 'All', 'Pending', 'Syncing', 'Failed', 'Blocked', 'Synced'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            AppPageHeader(
              title: "Sync Center",
              onBack: () => Get.back(),
              action: AppHeaderActionBadge.refresh(
                onTap: () => syncController.checkConnectivityAndSync(),
              ),
            ),
            Expanded(
              child: Obx(() {
          final ops = syncController.allOperations;
          final isOnline = syncController.isOnline.value;
          final isSyncing = syncController.isSyncing.value;

          final pendingCount = ops.where((o) => o.status == 'pending').length;
          final syncingCount = ops.where((o) => o.status == 'syncing').length;
          final retryWaitingCount = ops.where((o) => o.status == 'retryWaiting').length;
          final failedCount = ops.where((o) => o.status == 'failed').length;
          final blockedCount = ops.where((o) => o.status == 'blocked').length;
          final syncedCount = ops.where((o) => o.status == 'synced').length;

          List<OfflineOperation> filteredOps = ops;
          if (_selectedFilter == 'Pending') {
            filteredOps = ops.where((o) => o.status == 'pending' || o.status == 'retryWaiting').toList();
          } else if (_selectedFilter == 'Syncing') {
            filteredOps = ops.where((o) => o.status == 'syncing').toList();
          } else if (_selectedFilter == 'Failed') {
            filteredOps = ops.where((o) => o.status == 'failed').toList();
          } else if (_selectedFilter == 'Blocked') {
            filteredOps = ops.where((o) => o.status == 'blocked').toList();
          } else if (_selectedFilter == 'Synced') {
            filteredOps = ops.where((o) => o.status == 'synced').toList();
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Connectivity & Sync Status Card
                _buildStatusSummaryCard(isOnline: isOnline, isSyncing: isSyncing),
                const SizedBox(height: 16),

                // Metrics Counters Row
                _buildMetricsGrid(
                  pending: pendingCount + retryWaitingCount,
                  syncing: syncingCount,
                  failed: failedCount,
                  blocked: blockedCount,
                  synced: syncedCount,
                ),
                const SizedBox(height: 16),

                // Action Buttons Bar (Sync Now, Retry All Failed)
                _buildActionButtons(failedCount: failedCount, isSyncing: isSyncing, isOnline: isOnline),
                const SizedBox(height: 16),

                // Filter Tabs
                _buildFilterChips(),
                const SizedBox(height: 14),

                // Queue Operation List Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Operations Queue (${filteredOps.length})",
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                    ),
                    if (ops.isNotEmpty)
                      Text(
                        "Last Synced: ${syncController.lastSyncedAt.value}",
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                      ),
                  ],
                ),
                const SizedBox(height: 10),

                // Operations Cards
                if (filteredOps.isEmpty)
                  _buildEmptyState()
                else
                  ...filteredOps.map((op) => _buildOperationCard(op)),

                const SizedBox(height: 30),
              ],
            ),
          );
        }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSummaryCard({required bool isOnline, required bool isSyncing}) {
    final hasInterface = ConnectivityService.instance.hasNetworkInterface;
    final isManualOffline = ConnectivityService.instance.isManualOffline;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isOnline
                      ? const Color(0xFFDCFCE7)
                      : (isManualOffline ? const Color(0xFFFEF3C7) : const Color(0xFFFEE2E2)),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isOnline ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                  color: isOnline
                      ? const Color(0xFF059669)
                      : (isManualOffline ? const Color(0xFFD97706) : const Color(0xFFDC2626)),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isOnline
                          ? "Online — Live Cloud Connected"
                          : (isManualOffline ? "Manual Offline Simulation" : "Offline — No Internet Connection"),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isOnline
                          ? "All writes will synchronize immediately with Laravel server."
                          : "Changes are securely written to local SQLite and will auto-sync.",
                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Network Interface: ${hasInterface ? 'Active' : 'Disconnected'}",
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
              ),
              InkWell(
                onTap: () => syncController.toggleOfflineMode(),
                child: Text(
                  isManualOffline ? "Disable Offline Mode" : "Simulate Offline",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isManualOffline ? const Color(0xFF059669) : const Color(0xFF2563EB),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid({
    required int pending,
    required int syncing,
    required int failed,
    required int blocked,
    required int synced,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricItem(
                label: "Pending",
                count: "$pending",
                color: const Color(0xFFD97706),
                bgColor: const Color(0xFFFEF3C7),
                icon: Iconsax.clock,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricItem(
                label: "Syncing",
                count: "$syncing",
                color: const Color(0xFF2563EB),
                bgColor: const Color(0xFFDBEAFE),
                icon: Iconsax.refresh,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricItem(
                label: "Failed",
                count: "$failed",
                color: const Color(0xFFDC2626),
                bgColor: const Color(0xFFFEE2E2),
                icon: Icons.error_outline_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildMetricItem(
                label: "Blocked",
                count: "$blocked",
                color: const Color(0xFFEA580C),
                bgColor: const Color(0xFFFFEDD5),
                icon: Icons.block_rounded,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricItem(
                label: "Synced (7d)",
                count: "$synced",
                color: const Color(0xFF059669),
                bgColor: const Color(0xFFDCFCE7),
                icon: Icons.check_circle_outline_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricItem({
    required String label,
    required String count,
    required Color color,
    required Color bgColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(count, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color)),
              Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons({required int failedCount, required bool isSyncing, required bool isOnline}) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ).buildButton(
            onPressed: isSyncing || !isOnline ? null : () => syncController.syncPendingActions(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isSyncing)
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                else
                  const Icon(Iconsax.refresh, size: 16, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  isSyncing ? "Syncing..." : "Sync Queue Now",
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        if (failedCount > 0) ...[
          const SizedBox(width: 10),
          Expanded(
            child: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              side: const BorderSide(color: Color(0xFFDC2626)),
            ).buildButton(
              onPressed: () => syncController.retryAllFailed(),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.replay_rounded, size: 16, color: Color(0xFFDC2626)),
                  SizedBox(width: 6),
                  Text(
                    "Retry Failed",
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Color(0xFFDC2626)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Pending', 'Syncing', 'Failed', 'Blocked', 'Synced'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: filters.map((f) {
          final isSelected = _selectedFilter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: ChoiceChip(
              label: Text(f),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedFilter = f),
              selectedColor: const Color(0xFF2563EB),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOperationCard(OfflineOperation op) {
    Color badgeColor = const Color(0xFFD97706);
    Color badgeBg = const Color(0xFFFEF3C7);

    switch (op.status) {
      case 'synced':
        badgeColor = const Color(0xFF059669);
        badgeBg = const Color(0xFFDCFCE7);
        break;
      case 'syncing':
        badgeColor = const Color(0xFF2563EB);
        badgeBg = const Color(0xFFDBEAFE);
        break;
      case 'failed':
        badgeColor = const Color(0xFFDC2626);
        badgeBg = const Color(0xFFFEE2E2);
        break;
      case 'blocked':
        badgeColor = const Color(0xFFEA580C);
        badgeBg = const Color(0xFFFFEDD5);
        break;
      case 'retryWaiting':
        badgeColor = const Color(0xFF9333EA);
        badgeBg = const Color(0xFFF3E8FF);
        break;
    }

    final createdAtFormatted = DateFormat('dd MMM, hh:mm a').format(op.createdAt);
    final opDisplayName = op.operationType.replaceAll('_', ' ').capitalizeFirst ?? op.operationType;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    opDisplayName,
                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(4)),
                    child: Text(
                      op.entityType.toUpperCase(),
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(6)),
                child: Text(
                  op.status.toUpperCase(),
                  style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: badgeColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Created: $createdAtFormatted",
                style: const TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8)),
              ),
              if (op.retryCount > 0)
                Text(
                  "Retries: ${op.retryCount}/${op.maxRetries}",
                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Color(0xFFD97706)),
                ),
            ],
          ),
          if (op.lastError != null && op.lastError!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFECDD3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 13, color: Color(0xFFE11D48)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      op.lastError!,
                      style: const TextStyle(fontSize: 10.5, color: Color(0xFF9F1239), fontWeight: FontWeight.w500),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Column(
        children: [
          Icon(Iconsax.tick_circle, size: 48, color: Color(0xFF059669)),
          SizedBox(height: 12),
          Text(
            "All Operations Synced",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
          SizedBox(height: 4),
          Text(
            "There are no pending offline mutations in the SQLite queue.",
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

extension ButtonExtension on ButtonStyle {
  Widget buildButton({required VoidCallback? onPressed, required Widget child}) {
    return ElevatedButton(
      style: this,
      onPressed: onPressed,
      child: child,
    );
  }
}
