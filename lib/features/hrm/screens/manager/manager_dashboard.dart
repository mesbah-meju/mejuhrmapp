import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:auth_ui_app/features/hrm/screens/manager/manager_approvals_screen.dart';
import 'package:auth_ui_app/features/hrm/screens/manager/manager_attendance_screen.dart';
import 'package:auth_ui_app/features/hrm/screens/manager/manager_payroll_screen.dart';
import 'package:auth_ui_app/features/hrm/screens/manager/manager_tasks_screen.dart';
import 'package:auth_ui_app/features/hrm/screens/manager/manager_team_screen.dart';
import 'package:auth_ui_app/services/approval_service.dart';
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
  final PayrollService _payrollService = PayrollService.instance;

  @override
  void initState() {
    super.initState();
    _payrollService.addListener(_onPayrollUpdate);
  }

  @override
  void dispose() {
    _payrollService.removeListener(_onPayrollUpdate);
    super.dispose();
  }

  void _onPayrollUpdate() {
    if (mounted) setState(() {});
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
        activeBody = ManagerPayrollScreen(onBack: () => setState(() => _currentNavIndex = 0));
        break;
      case 5:
        activeBody = ManagerTasksScreen(onBack: () => setState(() => _currentNavIndex = 0));
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
    final pendingApprovals = ApprovalService.instance.getRequests().where((r) => r.status == ApprovalStatus.pending).length;
    final pendingPayrollCount = _payrollService.pendingItems.length;
    final pendingPayrollTotal = _payrollService.totalPending;
    final unreadNotifs = NotificationEngineService.instance.getUnreadCount();
    final currencyFormat = NumberFormat.currency(symbol: 'BDT ', decimalDigits: 0);
    final todayDateStr = DateFormat('EEEE, dd MMM yyyy').format(DateTime.now());

    return Column(
      children: [
        // 1. EXECUTIVE TOP APP BAR & PROFILE HEADER
        _buildExecutiveHeader(todayDateStr, unreadNotifs),

        // 2. MAIN SCROLLABLE DASHBOARD BODY
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // KPI GRID CARDS (4 METRICS)
                _buildKpiMetricsGrid(
                  pendingApprovals: pendingApprovals,
                  pendingPayrollTotal: pendingPayrollTotal,
                  currencyFormat: currencyFormat,
                ),
                const SizedBox(height: 20),

                // ACTIONABLE ALERTS CENTER (If there are pending items)
                if (pendingApprovals > 0 || pendingPayrollCount > 0) ...[
                  _buildActionableAlertsBanner(
                    pendingApprovals: pendingApprovals,
                    pendingPayrollCount: pendingPayrollCount,
                    pendingPayrollTotal: pendingPayrollTotal,
                    currencyFormat: currencyFormat,
                  ),
                  const SizedBox(height: 20),
                ],

                // OPERATIONS & MANAGEMENT HUB (6 QUICK TILES)
                const Text(
                  "MANAGEMENT OPERATIONS HUB",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.6),
                ),
                const SizedBox(height: 10),
                _buildOperationsHubGrid(pendingApprovals, pendingPayrollCount),
                const SizedBox(height: 22),

                // TEAM REVENUE & TARGET PERFORMANCE CARD
                _buildTeamSalesTargetCard(currencyFormat),
                const SizedBox(height: 22),

                // DIRECT REPORTS QUICK SUMMARY LIST
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "DIRECT REPORTS PERFORMANCE",
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.6),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _currentNavIndex = 1),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                      child: const Text(
                        "View All Team Reports →",
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildTeamMemberCard("Rahul Sharma", "Senior Sales Executive", "Checked In 09:03 AM", "112% Target", const Color(0xFF059669)),
                _buildTeamMemberCard("Ananya Roy", "Sales Associate", "Checked In 09:12 AM", "94% Target", const Color(0xFF2563EB)),
                _buildTeamMemberCard("Tanvir Ahmed", "Business Analyst", "Checked In 09:00 AM", "100% Tasks", const Color(0xFF7C3AED)),
                _buildTeamMemberCard("Nusrat Jahan", "HR Coordinator", "Field Visit 09:25 AM", "96% Target", const Color(0xFFD97706)),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 1. EXECUTIVE HEADER
  // ==========================================
  Widget _buildExecutiveHeader(String dateStr, int unreadNotifs) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFBFDBFE), width: 2),
                ),
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFFDBEAFE),
                  child: Icon(Iconsax.user_octagon, color: Color(0xFF2563EB), size: 22),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Manager Workspace",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), letterSpacing: -0.3),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text("EXECUTIVE", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateStr,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),

          // Header Right Actions
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() => _currentNavIndex = 3);
                },
                icon: Badge(
                  isLabelVisible: unreadNotifs > 0,
                  label: Text(unreadNotifs.toString()),
                  child: const Icon(Iconsax.notification, color: Color(0xFF475569), size: 22),
                ),
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
  Widget _buildKpiMetricsGrid({
    required int pendingApprovals,
    required double pendingPayrollTotal,
    required NumberFormat currencyFormat,
  }) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.55,
      children: [
        _buildKpiCard(
          title: "Team Attendance",
          value: "18 / 20",
          subtitle: "90% Punctual Today",
          icon: Iconsax.calendar_tick,
          accentColor: const Color(0xFF059669),
          bgColor: const Color(0xFFF0FDF4),
          borderColor: const Color(0xFFBBF7D0),
          onTap: () => setState(() => _currentNavIndex = 2),
        ),
        _buildKpiCard(
          title: "Monthly Revenue",
          value: "BDT 420K",
          subtitle: "84% Target Reached",
          icon: Iconsax.chart_21,
          accentColor: const Color(0xFF2563EB),
          bgColor: const Color(0xFFEFF6FF),
          borderColor: const Color(0xFFBFDBFE),
          onTap: () => setState(() => _currentNavIndex = 1),
        ),
        _buildKpiCard(
          title: "Pending Payroll",
          value: currencyFormat.format(pendingPayrollTotal),
          subtitle: "Pending Disbursements",
          icon: Iconsax.wallet_money,
          accentColor: const Color(0xFFD97706),
          bgColor: const Color(0xFFFFFBEB),
          borderColor: const Color(0xFFFDE68A),
          onTap: () => setState(() => _currentNavIndex = 4),
        ),
        _buildKpiCard(
          title: "Pending Approvals",
          value: "$pendingApprovals Requests",
          subtitle: "Requires Authorization",
          icon: Iconsax.verify,
          accentColor: const Color(0xFF7C3AED),
          bgColor: const Color(0xFFFAF5FF),
          borderColor: const Color(0xFFE9D5FF),
          onTap: () => setState(() => _currentNavIndex = 3),
        ),
      ],
    );
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: accentColor, letterSpacing: -0.3),
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
  Widget _buildActionableAlertsBanner({
    required int pendingApprovals,
    required int pendingPayrollCount,
    required double pendingPayrollTotal,
    required NumberFormat currencyFormat,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Iconsax.danger, color: Color(0xFFB45309), size: 20),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  "MANAGER ACTIONABLE ALERTS CENTER",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF92400E), letterSpacing: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          if (pendingApprovals > 0)
            InkWell(
              onTap: () => setState(() => _currentNavIndex = 3),
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFFDE68A))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Iconsax.verify, size: 16, color: Color(0xFF7C3AED)),
                        const SizedBox(width: 8),
                        Text("$pendingApprovals Sales & Attendance Requests Pending", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
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
            ),

          if (pendingPayrollCount > 0)
            InkWell(
              onTap: () => setState(() => _currentNavIndex = 4),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFFDE68A))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Iconsax.wallet_money, size: 16, color: Color(0xFFD97706)),
                        const SizedBox(width: 8),
                        Text("Pending Disbursements: ${currencyFormat.format(pendingPayrollTotal)}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      ],
                    ),
                    const Row(
                      children: [
                        Text("Disburse", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                        Icon(Icons.arrow_forward_ios, size: 10, color: Color(0xFF2563EB)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ==========================================
  // 4. OPERATIONS HUB GRID (6 TILES)
  // ==========================================
  Widget _buildOperationsHubGrid(int pendingApprovals, int pendingPayroll) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.05,
      children: [
        _buildHubTile("Team Reports", Iconsax.people, const Color(0xFF2563EB), const Color(0xFFEFF6FF), () => setState(() => _currentNavIndex = 1)),
        _buildHubTile("Attendance", Iconsax.calendar_tick, const Color(0xFF059669), const Color(0xFFECFDF5), () => setState(() => _currentNavIndex = 2)),
        _buildHubTile("Approvals", Iconsax.verify, const Color(0xFF7C3AED), const Color(0xFFFAF5FF), () => setState(() => _currentNavIndex = 3), badgeCount: pendingApprovals),
        _buildHubTile("Payroll", Iconsax.wallet_money, const Color(0xFFD97706), const Color(0xFFFFFBEB), () => setState(() => _currentNavIndex = 4), badgeCount: pendingPayroll),
        _buildHubTile("Tasks", Iconsax.task_square, const Color(0xFF0284C7), const Color(0xFFF0F9FF), () => setState(() => _currentNavIndex = 5)),
        _buildHubTile("Targets", Iconsax.chart_21, const Color(0xFFDC2626), const Color(0xFFFEF2F2), () => setState(() => _currentNavIndex = 1)),
      ],
    );
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
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
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
  // 5. TEAM SALES TARGET & REVENUE CARD
  // ==========================================
  Widget _buildTeamSalesTargetCard(NumberFormat format) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Color(0x1F000000), blurRadius: 10, offset: Offset(0, 4))],
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
                  Text("MONTHLY REVENUE BENCHMARK", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 0.5)),
                  SizedBox(height: 2),
                  Text("Team Target: BDT 500,000", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF059669), borderRadius: BorderRadius.circular(6)),
                child: const Text("84% Achieved", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 14),

          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const LinearProgressIndicator(
              value: 0.84,
              minHeight: 8,
              backgroundColor: Color(0xFF334155),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF38BDF8)),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Achieved: ${format.format(420000)}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8))),
              Text("Remaining: ${format.format(80000)}", style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 6. TEAM MEMBER TILE
  // ==========================================
  Widget _buildTeamMemberCard(String name, String role, String status, String metric, Color color) {
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
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(metric, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // BOTTOM NAVIGATION BAR
  // ==========================================
  Widget _buildManagerBottomNav() {
    final pendingPayroll = _payrollService.pendingItems.length;
    final pendingApprovals = ApprovalService.instance.getRequests().where((r) => r.status == ApprovalStatus.pending).length;

    return BottomNavigationBar(
      currentIndex: _currentNavIndex,
      onTap: (index) => setState(() => _currentNavIndex = index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF2563EB),
      unselectedItemColor: const Color(0xFF64748B),
      selectedFontSize: 11,
      unselectedFontSize: 10,
      items: [
        const BottomNavigationBarItem(icon: Icon(Iconsax.category), label: 'Dashboard'),
        const BottomNavigationBarItem(icon: Icon(Iconsax.people), label: 'Team'),
        const BottomNavigationBarItem(icon: Icon(Iconsax.calendar_tick), label: 'Attendance'),
        BottomNavigationBarItem(
          icon: Badge(
            isLabelVisible: pendingApprovals > 0,
            label: Text(pendingApprovals.toString()),
            child: const Icon(Iconsax.verify),
          ),
          label: 'Approvals',
        ),
        BottomNavigationBarItem(
          icon: Badge(
            isLabelVisible: pendingPayroll > 0,
            label: Text(pendingPayroll.toString()),
            child: const Icon(Iconsax.wallet_money),
          ),
          label: 'Payroll',
        ),
        const BottomNavigationBarItem(icon: Icon(Iconsax.task_square), label: 'Tasks'),
      ],
    );
  }
}
