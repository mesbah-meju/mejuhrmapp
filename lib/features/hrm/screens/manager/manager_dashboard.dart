import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:auth_ui_app/features/hrm/controllers/controllers.dart';
import 'package:auth_ui_app/features/hrm/screens/manager/manager_approvals_screen.dart';
import 'package:auth_ui_app/features/hrm/screens/manager/manager_attendance_screen.dart';
import 'package:auth_ui_app/features/hrm/screens/manager/manager_payroll_screen.dart';
import 'package:auth_ui_app/features/hrm/screens/manager/manager_targets_screen.dart';
import 'package:auth_ui_app/features/hrm/screens/manager/manager_tasks_screen.dart';
import 'package:auth_ui_app/features/hrm/screens/manager/manager_team_screen.dart';
import 'package:auth_ui_app/services/auth_service.dart';
import 'package:auth_ui_app/services/notification_engine_service.dart';
import 'package:auth_ui_app/services/payroll_service.dart';

class ManagerDashboardScreen extends StatefulWidget {
  final VoidCallback? onSwitchToStaffMode;

  const ManagerDashboardScreen({
    super.key,
    this.onSwitchToStaffMode,
  });

  @override
  State<ManagerDashboardScreen> createState() => _ManagerDashboardScreenState();
}

class _ManagerDashboardScreenState extends State<ManagerDashboardScreen> {
  int _currentNavIndex = 0;
  final ManagerDashboardController dashboardController = ManagerDashboardController.instance;
  final PayrollService _payrollService = PayrollService.instance;

  @override
  void initState() {
    super.initState();
    dashboardController.refreshAllDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    Widget activeBody;
    switch (_currentNavIndex) {
      case 1:
        activeBody = ManagerTeamScreen(onBack: () => setState(() => _currentNavIndex = 0));
        break;
      case 2:
        activeBody = ManagerAttendanceScreen(onBack: () => setState(() => _currentNavIndex = 0));
        break;
      case 3:
        activeBody = ManagerApprovalsScreen(onBack: () => setState(() => _currentNavIndex = 0));
        break;
      case 4:
        activeBody = ManagerTasksScreen(onBack: () => setState(() => _currentNavIndex = 0));
        break;
      case 5:
        activeBody = ManagerTargetsScreen(onBack: () => setState(() => _currentNavIndex = 0));
        break;
      case 6:
        activeBody = ManagerPayrollScreen(onBack: () => setState(() => _currentNavIndex = 0));
        break;
      case 0:
      default:
        activeBody = _buildProfessionalManagerDashboard();
        break;
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: activeBody,
        ),
        bottomNavigationBar: _buildManagerBottomNav(),
      ),
    );
  }

  // ============================================================================
  // PROFESSIONAL EXECUTIVE MANAGER DASHBOARD HOME
  // ============================================================================
  Widget _buildProfessionalManagerDashboard() {
    final unreadNotifs = NotificationEngineService.instance.getUnreadCount();
    final todayDateStr = DateFormat('EEEE, dd MMM yyyy').format(DateTime.now());

    return RefreshIndicator(
      onRefresh: () => dashboardController.refreshAllDashboardData(),
      color: const Color(0xFF2563EB),
      child: Column(
        children: [
          // 1. EXECUTIVE TOP APP BAR & PROFILE HEADER
          _buildExecutiveHeader(todayDateStr, unreadNotifs),

          // 2. MAIN SCROLLABLE DASHBOARD BODY
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KPI GRID CARDS (4 METRICS)
                  _buildKpiMetricsGrid(),
                  const SizedBox(height: 18),

                  // ACTIONABLE ALERTS CENTER (If there are pending items)
                  _buildActionableAlertsBanner(),
                  const SizedBox(height: 18),

                  // 5 CORE SECTIONS OPERATIONS HUB (5 QUICK TILES)
                  const Text(
                    "5 CORE MANAGEMENT MODULES",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.6),
                  ),
                  const SizedBox(height: 10),
                  _buildOperationsHubGrid(),
                  const SizedBox(height: 22),

                  // TEAM SALES TARGET BENCHMARK
                  _buildTeamSalesTargetCard(),
                  const SizedBox(height: 22),

                  // DIRECT REPORTS SUMMARY
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "TEAM QUICK DIRECTORY",
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.6),
                      ),
                      TextButton(
                        onPressed: () => setState(() => _currentNavIndex = 1),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                        child: const Text(
                          "View Full Directory →",
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildTeamMemberCard("Alex Rahman", "Sales Executive", "Active", "BDT 40,000", const Color(0xFF059669)),
                  _buildTeamMemberCard("Sarah Khan", "Sales Executive", "Active", "BDT 35,000", const Color(0xFF2563EB)),
                  _buildTeamMemberCard("Tanvir Ahmed", "Business Analyst", "Active", "BDT 45,000", const Color(0xFF7C3AED)),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 1. EXECUTIVE HEADER
  // ==========================================
  Widget _buildExecutiveHeader(String dateStr, int unreadNotifs) {
    final user = AuthService.instance.getCurrentUser();
    final userName = user?.name ?? "Manager";
    final userRole = user?.roles.isNotEmpty == true ? user!.roles.first.toUpperCase() : "HR / ADMIN";

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF2563EB),
                child: Text(
                  userName.isNotEmpty ? userName[0] : "M",
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(4)),
                        child: Text(userRole, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                      ),
                      const SizedBox(width: 8),
                      Text(dateStr, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                    ],
                  ),
                ],
              ),
            ],
          ),

          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: Color(0xFF2563EB), size: 22),
                tooltip: "Refresh Dashboard",
                onPressed: () => dashboardController.refreshAllDashboardData(),
              ),
              if (widget.onSwitchToStaffMode != null)
                IconButton(
                  icon: const Icon(Iconsax.user_tag, color: Color(0xFF64748B), size: 22),
                  tooltip: "Switch to Staff View",
                  onPressed: widget.onSwitchToStaffMode,
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 2. KPI METRICS GRID (4 CARDS)
  // ==========================================
  Widget _buildKpiMetricsGrid() {
    return Obx(() {
      final activeStaff = dashboardController.totalActiveEmployees.value;
      final presentToday = dashboardController.presentTodayCount.value;
      final pendingLeaves = dashboardController.pendingLeavesCount.value;
      final pendingTasks = dashboardController.pendingTasksCount.value;

      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.55,
        children: [
          _buildKpiCard(
            title: "Staff Attendance",
            value: "$presentToday Present",
            subtitle: "Today's Verified Count",
            icon: Iconsax.calendar_tick,
            accentColor: const Color(0xFF059669),
            bgColor: const Color(0xFFF0FDF4),
            borderColor: const Color(0xFFBBF7D0),
            onTap: () => setState(() => _currentNavIndex = 2),
          ),
          _buildKpiCard(
            title: "Total Staff",
            value: "$activeStaff Active",
            subtitle: "Employees Onboarded",
            icon: Iconsax.people,
            accentColor: const Color(0xFF2563EB),
            bgColor: const Color(0xFFEFF6FF),
            borderColor: const Color(0xFFBFDBFE),
            onTap: () => setState(() => _currentNavIndex = 1),
          ),
          _buildKpiCard(
            title: "Leave Queue",
            value: "$pendingLeaves Pending",
            subtitle: "Requires Approval",
            icon: Iconsax.verify,
            accentColor: const Color(0xFF7C3AED),
            bgColor: const Color(0xFFFAF5FF),
            borderColor: const Color(0xFFE9D5FF),
            onTap: () => setState(() => _currentNavIndex = 3),
          ),
          _buildKpiCard(
            title: "Task Approvals",
            value: "$pendingTasks Submissions",
            subtitle: "Daily Branch Tasks",
            icon: Iconsax.task_square,
            accentColor: const Color(0xFFD97706),
            bgColor: const Color(0xFFFFFBEB),
            borderColor: const Color(0xFFFDE68A),
            onTap: () => setState(() => _currentNavIndex = 4),
          ),
        ],
      );
    });
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required Color bgColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8), border: Border.all(color: borderColor)),
                    child: Icon(icon, size: 16, color: accentColor),
                  ),
                ],
              ),
              Text(
                value,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: accentColor, letterSpacing: -0.3),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 3. ACTIONABLE ALERTS CENTER
  // ==========================================
  Widget _buildActionableAlertsBanner() {
    return Obx(() {
      final pendingLeaves = dashboardController.pendingLeavesCount.value;
      final pendingTasks = dashboardController.pendingTasksCount.value;
      final pendingSales = dashboardController.pendingSalesLogsCount.value;
      final total = pendingLeaves + pendingTasks + pendingSales;

      if (total == 0) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFFDE68A)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Iconsax.danger, color: Color(0xFFB45309), size: 18),
                const SizedBox(width: 8),
                Text(
                  "ACTION REQUIRED ($total PENDING)",
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF92400E), letterSpacing: 0.5),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (pendingLeaves > 0)
              _buildAlertItem(
                "$pendingLeaves Leave Request(s) awaiting approval",
                Iconsax.verify,
                const Color(0xFF7C3AED),
                () => setState(() => _currentNavIndex = 3),
              ),

            if (pendingTasks > 0)
              _buildAlertItem(
                "$pendingTasks Branch Task Submission(s) to verify",
                Iconsax.task_square,
                const Color(0xFFD97706),
                () => setState(() => _currentNavIndex = 4),
              ),

            if (pendingSales > 0)
              _buildAlertItem(
                "$pendingSales Sales Log Entry(ies) for review",
                Iconsax.receipt_edit,
                const Color(0xFF059669),
                () => setState(() => _currentNavIndex = 5),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildAlertItem(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFFDE68A))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 15, color: color),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              ],
            ),
            const Row(
              children: [
                Text("Review", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                Icon(Icons.arrow_forward_ios, size: 10, color: Color(0xFF2563EB)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 4. 5 CORE SECTIONS OPERATIONS HUB (5 TILES)
  // ==========================================
  Widget _buildOperationsHubGrid() {
    return Obx(() {
      final pendingLeaves = dashboardController.pendingLeavesCount.value;
      final pendingTasks = dashboardController.pendingTasksCount.value;
      final pendingSales = dashboardController.pendingSalesLogsCount.value;

      return GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.05,
        children: [
          _buildHubTile("1. Staff Directory", Iconsax.people, const Color(0xFF2563EB), const Color(0xFFEFF6FF), () => setState(() => _currentNavIndex = 1)),
          _buildHubTile("2. Attendance", Iconsax.calendar_tick, const Color(0xFF059669), const Color(0xFFECFDF5), () => setState(() => _currentNavIndex = 2)),
          _buildHubTile("3. Leave Approvals", Iconsax.verify, const Color(0xFF7C3AED), const Color(0xFFFAF5FF), () => setState(() => _currentNavIndex = 3), badgeCount: pendingLeaves),
          _buildHubTile("4. Daily Tasks", Iconsax.task_square, const Color(0xFF0284C7), const Color(0xFFF0F9FF), () => setState(() => _currentNavIndex = 4), badgeCount: pendingTasks),
          _buildHubTile("5. Sales Targets", Iconsax.radar_2, const Color(0xFFDC2626), const Color(0xFFFEF2F2), () => setState(() => _currentNavIndex = 5), badgeCount: pendingSales),
          _buildHubTile("Payroll", Iconsax.wallet_money, const Color(0xFFD97706), const Color(0xFFFFFBEB), () => setState(() => _currentNavIndex = 6)),
        ],
      );
    });
  }

  Widget _buildHubTile(String label, IconData icon, Color accent, Color bg, VoidCallback onTap, {int badgeCount = 0}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
                    child: Icon(icon, size: 22, color: accent),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (badgeCount > 0)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFEF4444), borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    badgeCount.toString(),
                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 5. SALES TARGET PERFORMANCE CARD
  // ==========================================
  Widget _buildTeamSalesTargetCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("PERFORMLY SALES PERFORMANCE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 0.5)),
                  SizedBox(height: 2),
                  Text("Team Sales Overview", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              InkWell(
                onTap: () => setState(() => _currentNavIndex = 5),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFF2563EB), borderRadius: BorderRadius.circular(6)),
                  child: const Text("Manage Targets →", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Track individual sales logs and verify invoice claims in real-time.",
            style: TextStyle(fontSize: 11, color: Color(0xFFCBD5E1)),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 6. TEAM MEMBER TILE
  // ==========================================
  Widget _buildTeamMemberCard(String name, String role, String status, String salary, Color color) {
    return InkWell(
      onTap: () => setState(() => _currentNavIndex = 1),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFFDBEAFE),
                  child: Text(name[0], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    Text("$role • $status", style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(salary, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // BOTTOM NAVIGATION BAR WITH REAL LIVE BADGES
  // ==========================================
  Widget _buildManagerBottomNav() {
    return Obx(() {
      final pendingLeaves = dashboardController.pendingLeavesCount.value;
      final pendingTasks = dashboardController.pendingTasksCount.value;
      final pendingSales = dashboardController.pendingSalesLogsCount.value;

      return BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (index) => setState(() => _currentNavIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: const Color(0xFF64748B),
        selectedFontSize: 10,
        unselectedFontSize: 9,
        items: [
          const BottomNavigationBarItem(icon: Icon(Iconsax.category), label: 'Overview'),
          const BottomNavigationBarItem(icon: Icon(Iconsax.people), label: 'Directory'),
          const BottomNavigationBarItem(icon: Icon(Iconsax.calendar_tick), label: 'Attendance'),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: pendingLeaves > 0,
              label: Text(pendingLeaves.toString()),
              child: const Icon(Iconsax.verify),
            ),
            label: 'Leaves',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: pendingTasks > 0,
              label: Text(pendingTasks.toString()),
              child: const Icon(Iconsax.task_square),
            ),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: pendingSales > 0,
              label: Text(pendingSales.toString()),
              child: const Icon(Iconsax.radar_2),
            ),
            label: 'Targets',
          ),
        ],
      );
    });
  }
}
