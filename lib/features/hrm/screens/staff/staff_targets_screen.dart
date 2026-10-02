import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:auth_ui_app/features/hrm/controllers/controllers.dart';
import 'package:auth_ui_app/features/hrm/models/target_model.dart';
import 'package:auth_ui_app/services/auth_service.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class TargetsScreen extends StatefulWidget {
  final VoidCallback? onBackToDashboard;

  const TargetsScreen({super.key, this.onBackToDashboard});

  @override
  State<TargetsScreen> createState() => _TargetsScreenState();
}

class _TargetsScreenState extends State<TargetsScreen> {
  final TargetController controller = TargetController.instance;
  int _activeTabIndex = 0; // 0 = Active Targets, 1 = Performance Stats, 2 = Sales Logs, 3 = Manager Review

  @override
  void initState() {
    super.initState();
    controller.refreshAll();
  }

  @override
  Widget build(BuildContext context) {
    final isManager = AuthService.instance.isManager();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showLogSaleBottomSheet(null),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, size: 20),
        label: const Text(
          "Log Sale",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshAll,
          color: const Color(0xFF2563EB),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header
                  _buildTopHeader(),
                  const SizedBox(height: 16),

                  // Segmented Tabs
                  _buildSegmentedTabs(isManager),
                  const SizedBox(height: 16),

                  // View Switcher
                  if (_activeTabIndex == 0)
                    _buildActiveTargetsView()
                  else if (_activeTabIndex == 1)
                    _buildStatsOverviewView()
                  else if (_activeTabIndex == 2)
                    _buildSalesLogsHistoryView()
                  else if (_activeTabIndex == 3 && isManager)
                    _buildManagerReviewView(),

                  const SizedBox(height: 80),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // TOP HEADER
  // =========================================================================
  Widget _buildTopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (widget.onBackToDashboard != null)
              IconButton(
                onPressed: widget.onBackToDashboard,
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF1E293B)),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              )
            else
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Iconsax.chart_21, size: 20, color: Color(0xFF2563EB)),
              ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Performly Targets",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Sales targets & performance logs",
                  style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),

        // Quick Refresh
        IconButton(
          onPressed: controller.refreshAll,
          icon: const Icon(Icons.refresh_rounded, color: Color(0xFF2563EB)),
          tooltip: "Refresh Targets",
        ),
      ],
    );
  }

  // =========================================================================
  // SEGMENTED TABS
  // =========================================================================
  Widget _buildSegmentedTabs(bool isManager) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _buildTabItem(0, "My Targets"),
          _buildTabItem(1, "Stats"),
          _buildTabItem(2, "Sales Logs"),
          if (isManager) _buildTabItem(3, "Review"),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    final isSelected = _activeTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (index == 2) controller.fetchSalesLogs();
          if (index == 3) controller.fetchManagerSalesLogs();
          setState(() => _activeTabIndex = index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // VIEW 1: ACTIVE TARGETS
  // =========================================================================
  Widget _buildActiveTargetsView() {
    final stats = controller.stats.value;
    final targets = controller.targetsList;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Performance Hero Card
        _buildPerformanceHeroCard(stats),
        const SizedBox(height: 18),

        // Section Title & Filter
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Assigned Targets (${targets.length})",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
            ),
            Row(
              children: [
                _buildStatusFilterChip("active", "Active"),
                const SizedBox(width: 6),
                _buildStatusFilterChip("completed", "Completed"),
                const SizedBox(width: 6),
                _buildStatusFilterChip("All", "All"),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (controller.isLoadingTargets.value && targets.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 60),
              child: CircularProgressIndicator(),
            ),
          )
        else if (targets.isEmpty)
          _buildEmptyTargetsState()
        else
          ...targets.map((target) => _buildTargetCard(target)),
      ],
    );
  }

  Widget _buildStatusFilterChip(String key, String label) {
    final isSelected = controller.selectedTargetStatus.value.toLowerCase() == key.toLowerCase();
    return GestureDetector(
      onTap: () => controller.setTargetStatusFilter(key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // PERFORMANCE HERO CARD
  // =========================================================================
  Widget _buildPerformanceHeroCard(PerformlyStatsModel stats) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Iconsax.award, size: 16, color: Color(0xFFFBBF24)),
                  SizedBox(width: 6),
                  Text(
                    "Overall Achievement",
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${stats.activeTargetsCount} ACTIVE",
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF93C5FD)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Main Metric Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${stats.overallAchievementPercentage.toStringAsFixed(1)}%",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  "${_formatCurrency(stats.totalAchievedAmount)} / ${_formatCurrency(stats.totalTargetAmount)}",
                  style: const TextStyle(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: stats.totalTargetAmount > 0 ? (stats.totalAchievedAmount / stats.totalTargetAmount).clamp(0.0, 1.0) : 0.0,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF34D399)),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 16),

          // Mini Stats Grid
          Row(
            children: [
              Expanded(
                child: _buildMiniHeroTile(
                  label: "Sales Logged",
                  value: _formatCurrency(stats.totalSalesLogged),
                  icon: Iconsax.money_recive,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMiniHeroTile(
                  label: "Units Sold",
                  value: stats.totalUnitsSold.toStringAsFixed(0),
                  icon: Iconsax.box,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMiniHeroTile(
                  label: "Commission",
                  value: _formatCurrency(stats.totalCommissionEarned),
                  icon: Iconsax.wallet_3,
                  isHighlight: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniHeroTile({
    required String label,
    required String value,
    required IconData icon,
    bool isHighlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlight ? const Color(0xFFFBBF24).withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: isHighlight ? const Color(0xFFFBBF24) : Colors.white70),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 9.5, color: Colors.white70, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: isHighlight ? const Color(0xFFFBBF24) : Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // TARGET ITEM CARD
  // =========================================================================
  Widget _buildTargetCard(TargetModel target) {
    final bool isAchieved = target.achievementPercentage >= 100.0;
    final progressFraction = (target.achievementPercentage / 100.0).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isAchieved ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0),
          width: isAchieved ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Tags & Percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      target.periodType.toUpperCase(),
                      style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: Color(0xFF2563EB)),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      target.targetType.replaceAll('_', ' ').toUpperCase(),
                      style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isAchieved ? const Color(0xFFDCFCE7) : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${target.achievementPercentage.toStringAsFixed(1)}%",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: isAchieved ? const Color(0xFF059669) : const Color(0xFF2563EB),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Title & Dates
          Text(
            target.title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Iconsax.calendar_1, size: 13, color: Color(0xFF94A3B8)),
              const SizedBox(width: 4),
              Text(
                "${target.startDate} to ${target.endDate}",
                style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress Metric
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Target", style: TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8))),
                  Text(
                    target.targetAmount > 0 ? _formatCurrency(target.targetAmount) : "${target.targetQuantity.toInt()} units",
                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text("Achieved", style: TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8))),
                  Text(
                    target.achievedAmount > 0 ? _formatCurrency(target.achievedAmount) : "${target.achievedQuantity.toInt()} units",
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: isAchieved ? const Color(0xFF059669) : const Color(0xFF2563EB),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progressFraction,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(
                isAchieved ? const Color(0xFF10B981) : const Color(0xFF2563EB),
              ),
              minHeight: 6,
            ),
          ),

          // KPI & Commission Plan Badges
          if (target.kpiMetric != null || target.commissionPlan != null) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                if (target.kpiMetric != null)
                  _buildTagPill(Iconsax.chart, target.kpiMetric!.name, const Color(0xFF6366F1), const Color(0xFFEEF2FF)),
                if (target.commissionPlan != null)
                  _buildTagPill(Iconsax.wallet_check, target.commissionPlan!.name, const Color(0xFF059669), const Color(0xFFECFDF5)),
              ],
            ),
          ],

          // Product Items Breakdown (if available)
          if (target.items.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 10),
            const Text(
              "Product Quota Breakdown",
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
            ),
            const SizedBox(height: 6),
            ...target.items.map((item) => _buildTargetItemRow(item)),
          ],

          const SizedBox(height: 14),

          // Action Button: Log Sale
          SizedBox(
            width: double.infinity,
            height: 38,
            child: OutlinedButton.icon(
              onPressed: () => _showLogSaleBottomSheet(target),
              icon: const Icon(Icons.add_shopping_cart_rounded, size: 15),
              label: const Text("Log Progress for this Target", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF2563EB),
                side: const BorderSide(color: Color(0xFFDBEAFE)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagPill(IconData icon, String text, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetItemRow(TargetItemModel item) {
    final progress = item.targetQuantity > 0 ? (item.achievedQuantity / item.targetQuantity).clamp(0.0, 1.0) : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${item.achievedQuantity.toInt()} / ${item.targetQuantity.toInt()} units (${_formatCurrency(item.achievedAmount)})",
                  style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: const Color(0xFFE2E8F0),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                minHeight: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // VIEW 2: STATS OVERVIEW
  // =========================================================================
  Widget _buildStatsOverviewView() {
    final stats = controller.stats.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPerformanceHeroCard(stats),
        const SizedBox(height: 18),

        const Text(
          "Performance Breakdown",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 12),

        _buildStatTile(
          title: "Total Revenue Logged",
          subtitle: "Gross value from all sales submissions",
          value: _formatCurrency(stats.totalSalesLogged),
          icon: Iconsax.dollar_circle,
          color: const Color(0xFF2563EB),
          bgColor: const Color(0xFFEFF6FF),
        ),
        _buildStatTile(
          title: "Total Units Delivered",
          subtitle: "Quantity of products & services sold",
          value: "${stats.totalUnitsSold.toInt()} Units",
          icon: Iconsax.box_add,
          color: const Color(0xFF059669),
          bgColor: const Color(0xFFECFDF5),
        ),
        _buildStatTile(
          title: "Total Commission Earned",
          subtitle: "Calculated earnings based on target plans",
          value: _formatCurrency(stats.totalCommissionEarned),
          icon: Iconsax.wallet_money,
          color: const Color(0xFFD97706),
          bgColor: const Color(0xFFFEF3C7),
        ),
        _buildStatTile(
          title: "Pending Log Approvals",
          subtitle: "Sales logs awaiting manager verification",
          value: "${stats.pendingLogsCount} Logs",
          icon: Iconsax.timer,
          color: const Color(0xFFDC2626),
          bgColor: const Color(0xFFFEF2F2),
        ),
      ],
    );
  }

  Widget _buildStatTile({
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: color),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // VIEW 3: SALES LOGS HISTORY
  // =========================================================================
  Widget _buildSalesLogsHistoryView() {
    final logs = controller.salesLogs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status Filter Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildLogFilterChip("All", "All Logs"),
              const SizedBox(width: 8),
              _buildLogFilterChip("pending", "Pending"),
              const SizedBox(width: 8),
              _buildLogFilterChip("approved", "Approved"),
              const SizedBox(width: 8),
              _buildLogFilterChip("rejected", "Rejected"),
            ],
          ),
        ),
        const SizedBox(height: 16),

        if (controller.isLoadingLogs.value && logs.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: CircularProgressIndicator(),
            ),
          )
        else if (logs.isEmpty)
          _buildEmptyLogsState()
        else
          ...logs.map((log) => _buildSalesLogCard(log)),
      ],
    );
  }

  Widget _buildLogFilterChip(String key, String label) {
    final isSelected = controller.selectedLogStatus.value.toLowerCase() == key.toLowerCase();
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => controller.setLogStatusFilter(key),
      selectedColor: const Color(0xFF2563EB),
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        fontSize: 11.5,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
        color: isSelected ? Colors.white : const Color(0xFF64748B),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0)),
      ),
    );
  }

  Widget _buildSalesLogCard(SalesLogModel log) {
    final isApproved = log.status == 'approved';
    final isRejected = log.status == 'rejected';

    final Color badgeColor = isApproved ? const Color(0xFF059669) : (isRejected ? const Color(0xFFDC2626) : const Color(0xFFD97706));
    final Color badgeBg = isApproved ? const Color(0xFFDCFCE7) : (isRejected ? const Color(0xFFFEE2E2) : const Color(0xFFFEF3C7));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isApproved ? const Color(0xFFBBF7D0) : (isRejected ? const Color(0xFFFECACA) : const Color(0xFFE2E8F0)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                log.logDate,
                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  log.status.toUpperCase(),
                  style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: badgeColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Text(
            log.productName ?? log.targetTitle ?? "Sales Entry",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Qty: ${log.quantity.toInt()} × ${_formatCurrency(log.unitPrice)}",
                style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
              ),
              Text(
                _formatCurrency(log.totalAmount),
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF2563EB)),
              ),
            ],
          ),

          if (log.customerName != null || log.invoiceNo != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(Iconsax.receipt, size: 13, color: Color(0xFF64748B)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "${log.customerName ?? 'Customer'} • Inv: ${log.invoiceNo ?? 'N/A'}",
                      style: const TextStyle(fontSize: 11, color: Color(0xFF475569), fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (log.notes != null && log.notes!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              "Note: ${log.notes!}",
              style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF64748B)),
            ),
          ],

          if (isRejected && log.rejectionReason != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 14, color: Color(0xFFDC2626)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Rejection reason: ${log.rejectionReason!}",
                      style: const TextStyle(fontSize: 11, color: Color(0xFFB91C1C), fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (isApproved && log.approvedByName != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.verified_rounded, size: 13, color: Color(0xFF059669)),
                const SizedBox(width: 4),
                Text(
                  "Approved by ${log.approvedByName!}",
                  style: const TextStyle(fontSize: 10.5, color: Color(0xFF059669), fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // =========================================================================
  // VIEW 4: MANAGER REVIEW
  // =========================================================================
  Widget _buildManagerReviewView() {
    final logs = controller.managerSalesLogs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Staff Sales Logs Pending Review",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
        ),
        const SizedBox(height: 12),

        if (logs.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Column(
              children: [
                Icon(Iconsax.task, size: 44, color: Color(0xFF94A3B8)),
                SizedBox(height: 10),
                Text(
                  "No pending submissions",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                ),
                SizedBox(height: 4),
                Text("All employee sales logs have been reviewed.", style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ],
            ),
          )
        else
          ...logs.map((log) => _buildManagerReviewCard(log)),
      ],
    );
  }

  Widget _buildManagerReviewCard(SalesLogModel log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFED7AA)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${log.userName ?? 'Employee'} • ${log.logDate}",
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(8)),
                child: const Text(
                  "NEEDS APPROVAL",
                  style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: Color(0xFFD97706)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Text(
            log.productName ?? log.targetTitle ?? "Sales Log",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 4),
          Text(
            "Qty: ${log.quantity.toInt()} | Unit Price: ${_formatCurrency(log.unitPrice)} | Total: ${_formatCurrency(log.totalAmount)}",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2563EB)),
          ),
          if (log.notes != null) ...[
            const SizedBox(height: 6),
            Text("Notes: ${log.notes!}", style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF64748B))),
          ],
          const SizedBox(height: 14),

          // Approval Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showRejectDialog(log),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFDC2626),
                    side: const BorderSide(color: Color(0xFFFCA5A5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Reject", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => controller.approveSalesLog(log.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: const Text("Approve", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(SalesLogModel log) {
    final reasonController = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Reject Sales Log", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Please state the reason for rejecting submission for ${log.productName ?? 'Sales Log'}:",
              style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: reasonController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: "e.g. Invoice number mismatch or duplicate entry...",
                hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                THelperFunctions.showSnackBar("Please provide a rejection reason.");
                return;
              }
              Get.back();
              controller.rejectSalesLog(log.id, reasonController.text.trim());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
            ),
            child: const Text("Confirm Rejection"),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // LOG SALE BOTTOM SHEET
  // =========================================================================
  void _showLogSaleBottomSheet(TargetModel? preSelectedTarget) {
    final target = preSelectedTarget ?? (controller.targetsList.isNotEmpty ? controller.targetsList.first : null);
    final targetId = target?.id;

    String entryType = 'item_wise';
    PerformlyProductModel? selectedProduct = controller.productsList.isNotEmpty ? controller.productsList.first : null;
    DateTime selectedDate = DateTime.now();

    final qtyController = TextEditingController(text: "1");
    final priceController = TextEditingController(text: selectedProduct != null ? selectedProduct.salePrice.toStringAsFixed(0) : "1000");
    final customerController = TextEditingController();
    final invoiceController = TextEditingController();
    final notesController = TextEditingController();

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setSheetState) {
          final double qty = double.tryParse(qtyController.text) ?? 1.0;
          final double unitPrice = double.tryParse(priceController.text) ?? 0.0;
          final double totalAmount = qty * unitPrice;

          return Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Log Sale / Achievement",
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                  if (target != null) ...[
                    Text(
                      "Target: ${target.title}",
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF2563EB)),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Entry Type Toggle (Item-wise vs Overall)
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setSheetState(() => entryType = 'item_wise'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: entryType == 'item_wise' ? const Color(0xFF2563EB) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Item-Wise Sale",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: entryType == 'item_wise' ? Colors.white : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setSheetState(() => entryType = 'overall'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: entryType == 'overall' ? const Color(0xFF2563EB) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Overall Revenue",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: entryType == 'overall' ? Colors.white : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Product Dropdown (if item_wise)
                  if (entryType == 'item_wise' && controller.productsList.isNotEmpty) ...[
                    const Text("Product / Service", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF334155))),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<PerformlyProductModel>(
                          value: selectedProduct,
                          isExpanded: true,
                          items: controller.productsList.map((p) {
                            return DropdownMenuItem(
                              value: p,
                              child: Text(
                                "${p.name} (${_formatCurrency(p.salePrice)})",
                                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setSheetState(() {
                                selectedProduct = val;
                                priceController.text = val.salePrice.toStringAsFixed(0);
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Quantity & Unit Price Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Quantity", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF334155))),
                            const SizedBox(height: 6),
                            TextField(
                              controller: qtyController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setSheetState(() {}),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Unit Price", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF334155))),
                            const SizedBox(height: 6),
                            TextField(
                              controller: priceController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setSheetState(() {}),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Total Calculated Amount Card
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFDBEAFE)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Computed Total Amount:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E3A8A))),
                        Text(
                          _formatCurrency(totalAmount),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF2563EB)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Customer Name & Invoice Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Customer Name", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF334155))),
                            const SizedBox(height: 6),
                            TextField(
                              controller: customerController,
                              decoration: InputDecoration(
                                hintText: "e.g. Acme Corp",
                                hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Invoice / Ref #", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF334155))),
                            const SizedBox(height: 6),
                            TextField(
                              controller: invoiceController,
                              decoration: InputDecoration(
                                hintText: "e.g. INV-2026-01",
                                hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Notes
                  const Text("Notes / Comments (Optional)", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF334155))),
                  const SizedBox(height: 6),
                  TextField(
                    controller: notesController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: "e.g. In-person meeting closed at headquarters...",
                      hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () async {
                        final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
                        final success = await controller.submitSaleLog(
                          targetId: targetId,
                          logDate: dateStr,
                          entryType: entryType,
                          productId: entryType == 'item_wise' ? selectedProduct?.id : null,
                          quantity: qty,
                          unitPrice: unitPrice,
                          totalAmount: totalAmount,
                          customerName: customerController.text.trim().isNotEmpty ? customerController.text.trim() : null,
                          invoiceNo: invoiceController.text.trim().isNotEmpty ? invoiceController.text.trim() : null,
                          notes: notesController.text.trim().isNotEmpty ? notesController.text.trim() : null,
                        );

                        if (success) {
                          Get.back();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Submit Sales Log",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildEmptyTargetsState() {
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
          Icon(Iconsax.chart_fail, size: 48, color: Color(0xFF94A3B8)),
          SizedBox(height: 12),
          Text(
            "No targets assigned",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
          SizedBox(height: 4),
          Text(
            "Contact your manager or sales lead to set your monthly targets.",
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyLogsState() {
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
          Icon(Iconsax.document_filter, size: 48, color: Color(0xFF94A3B8)),
          SizedBox(height: 12),
          Text(
            "No sales logs recorded",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
          SizedBox(height: 4),
          Text(
            "Log your daily sales and achievements using the button below.",
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  static String _formatCurrency(double val) {
    final intVal = val.toInt();
    final str = intVal.toString();
    final regex = RegExp(r'(\d+?)(?=(\d{3})+(?!\d))');
    final formatted = str.replaceAllMapped(regex, (match) => '${match[1]},');
    return "\$$formatted";
  }
}
