import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import 'package:get/get.dart';
import 'package:auth_ui_app/common/widgets/connectivity_status_banner.dart';
import 'package:auth_ui_app/features/hrm/controllers/controllers.dart';
import 'package:auth_ui_app/features/hrm/screens/common/me_screen.dart';
import 'package:auth_ui_app/features/hrm/screens/staff/staff_attendance_screen.dart';
import 'package:auth_ui_app/features/hrm/screens/staff/staff_payroll_screen.dart';
import 'package:auth_ui_app/features/hrm/screens/staff/staff_targets_screen.dart';
import 'package:auth_ui_app/features/hrm/screens/staff/staff_tasks_screen.dart';
import 'package:auth_ui_app/services/auth_service.dart';

class HrmDashboardScreen extends StatefulWidget {
  const HrmDashboardScreen({super.key});

  @override
  State<HrmDashboardScreen> createState() => _HrmDashboardScreenState();
}

class _HrmDashboardScreenState extends State<HrmDashboardScreen>
    with TickerProviderStateMixin {
  int _currentNavIndex = 0;
  bool _isCheckedIn = false;
  String _selectedPerformancePeriod = 'This Month';
  String _selectedEarningsPeriod = 'This Month';

  // Daily Tasks State
  final List<Map<String, dynamic>> _tasks = [
    {'title': 'Client Follow-up Calls', 'time': '09:00 AM', 'completed': true},
    {'title': 'Prepare Sales Report', 'time': '11:00 AM', 'completed': true},
    {'title': 'Team Meeting', 'time': '02:00 PM', 'completed': false},
    {'title': 'Update CRM', 'time': '04:00 PM', 'completed': false},
    {'title': 'Send Proposal to Client', 'time': '05:00 PM', 'completed': false},
  ];

  void _setNav(int index) {
    HapticFeedback.selectionClick();
    setState(() => _currentNavIndex = index);
  }


  @override
  Widget build(BuildContext context) {
    Widget activeBody;
    switch (_currentNavIndex) {
      case 1:
        activeBody = TasksScreen(onBackToDashboard: () => _setNav(0));
        break;
      case 2:
        activeBody = AttendanceScreen(onBackToDashboard: () => _setNav(0));
        break;
      case 3:
        activeBody = TargetsScreen(onBackToDashboard: () => _setNav(0));
        break;
      case 4:
        activeBody = PayrollScreen(onBackToDashboard: () => _setNav(0));
        break;
      case 5:
        activeBody = MeScreen(
          onBackToDashboard: () => _setNav(0),
          onNavigateToTab: (index) => _setNav(index),
        );
        break;
      default:
        activeBody = _buildDashboardHome();
        break;
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: KeyedSubtree(key: ValueKey(_currentNavIndex), child: activeBody),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  // ==========================================
  // DASHBOARD HOME VIEW
  // ==========================================
  Widget _buildDashboardHome() {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // Top App Bar / Header
          _buildHeader(),

          // Connectivity & Offline Sync Status Banner
          const ConnectivityStatusBanner(),

          // Main Scrollable Dashboard Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  // 1. Performance Overview Section
                  _buildPerformanceOverviewCard(),
                  const SizedBox(height: 16),

                  // 2. Attendance Section
                  _buildAttendanceCard(),
                  const SizedBox(height: 16),

                  // 3. Daily Tasks Section
                  _buildDailyTasksCard(),
                  const SizedBox(height: 16),

                  // 4. Targets Section
                  _buildTargetsCard(),
                  const SizedBox(height: 16),

                  // 5. Earnings & Payments Section
                  _buildEarningsAndPaymentsCard(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TOP HEADER
  // ==========================================
  Widget _buildHeader() {
    final user = AuthService.instance.getUser();
    final name = user?['name'] ?? 'Rahul Sharma';

    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good Morning' : hour < 17 ? 'Good Afternoon' : 'Good Evening';
    final initials = name.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      color: const Color(0xFFF8FAFC),
      child: Row(
        children: [
          // Avatar → navigates to Me tab
          GestureDetector(
            onTap: () => _setNav(5),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 6, offset: const Offset(0, 2))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.network(
                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFF2563EB),
                    child: Center(child: Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15))),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Greeting & name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$greeting,', style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
                Text(name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), letterSpacing: -0.3)),
              ],
            ),
          ),

          // Notification bell
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.notifications_outlined, size: 20, color: Color(0xFF0F172A)),
                Positioned(top: 9, right: 9, child: Container(width: 7, height: 7, decoration: const BoxDecoration(color: Color(0xFFDC2626), shape: BoxShape.circle))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 1. PERFORMANCE OVERVIEW CARD
  // ==========================================
  Widget _buildPerformanceOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
          // Card Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.bar_chart_rounded, color: Color(0xFF2563EB), size: 24),
                  SizedBox(width: 8),
                  Text(
                    "Performance Overview",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              _buildDropdownFilter(
                _selectedPerformancePeriod,
                (val) => setState(() => _selectedPerformancePeriod = val!),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Layout: Left Chart, Right 2x2 Metric Grid
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Performance Area Line Chart
              Expanded(
                flex: 11,
                child: SizedBox(
                  height: 155,
                  child: CustomPaint(
                    painter: _PerformanceChartPainter(),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Right: 2x2 Metric Badges
              Expanded(
                flex: 9,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricTile(
                            bgColor: const Color(0xFFECFDF5),
                            iconColor: const Color(0xFF059669),
                            icon: Iconsax.radar,
                            value: "82% ↗",
                            valueColor: const Color(0xFF059669),
                            label: "Overall\nPerformance",
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildMetricTile(
                            bgColor: const Color(0xFFEFF6FF),
                            iconColor: const Color(0xFF2563EB),
                            icon: Icons.check_circle_rounded,
                            value: "18 / 22",
                            valueColor: const Color(0xFF0F172A),
                            label: "Tasks\nCompleted",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricTile(
                            bgColor: const Color(0xFFFAF5FF),
                            iconColor: const Color(0xFF7C3AED),
                            icon: Icons.bar_chart_rounded,
                            value: "4 / 5",
                            valueColor: const Color(0xFF0F172A),
                            label: "Targets\nAchieved",
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildMetricTile(
                            bgColor: const Color(0xFFFFFBEB),
                            iconColor: const Color(0xFFD97706),
                            icon: Icons.star_rounded,
                            value: "8.5",
                            valueColor: const Color(0xFFD97706),
                            label: "Average\nRating",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required Color bgColor,
    required Color iconColor,
    required IconData icon,
    required String value,
    required Color valueColor,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: valueColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF64748B),
              height: 1.2,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 2. ATTENDANCE SECTION
  // ==========================================
  Widget _buildAttendanceCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3.5,
            constraints: const BoxConstraints(minHeight: 60),
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(color: const Color(0xFFEF4444), borderRadius: BorderRadius.circular(4)),
          ),
          Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Attendance Header
          Row(
            children: [
              InkWell(
                onTap: () => setState(() => _currentNavIndex = 2),
                borderRadius: BorderRadius.circular(10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Attendance",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Alert Badge & Button
              Expanded(
                child: Obx(() {
                  final status = AttendanceController.instance.todayStatus.value;
                  final isClocked = status?.isClockedIn ?? false;
                  final isBusy = AttendanceController.instance.isClocking.value;

                  return Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isClocked ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: isClocked ? const Color(0xFF059669) : const Color(0xFFEF4444),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isClocked ? Icons.check : Icons.priority_high_rounded,
                                  color: Colors.white,
                                  size: 10,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  isClocked ? "Checked In (${status?.clockIn ?? ''})" : "You haven't checked in!",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isClocked ? const Color(0xFF065F46) : const Color(0xFFDC2626),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: isBusy ? null : AttendanceController.instance.toggleClockInOut,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isClocked ? const Color(0xFFDC2626) : const Color(0xFF059669),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                          minimumSize: const Size(0, 34),
                        ),
                        child: isBusy
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                              )
                            : Text(
                                isClocked ? "Clock Out" : "Clock In",
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Days & Status Row
          Row(
            children: [
              // Today Status
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today",
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _isCheckedIn ? "Present" : "Not Marked",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: _isCheckedIn ? const Color(0xFF059669) : const Color(0xFFDC2626),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),

              // Day Pills
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDayAttendancePill(
                      day: "Mon",
                      date: "Mar 17",
                      statusIcon: const Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 16),
                    ),
                    _buildDayAttendancePill(
                      day: "Tue",
                      date: "Mar 18",
                      statusIcon: const Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 16),
                    ),
                    _buildDayAttendancePill(
                      day: "Wed",
                      date: "Mar 19",
                      statusIcon: const Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 16),
                    ),
                    _buildDayAttendancePill(
                      day: "Thu",
                      date: "Mar 20",
                      statusIcon: const Icon(Icons.cancel_rounded, color: Color(0xFFDC2626), size: 16),
                    ),
                    _buildDayAttendancePill(
                      day: "Fri",
                      date: "Mar 21",
                      statusIcon: Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          color: Color(0xFF94A3B8),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayAttendancePill({
    required String day,
    required String date,
    required Widget statusIcon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFE4E6)),
      ),
      child: Column(
        children: [
          statusIcon,
          const SizedBox(height: 4),
          Text(
            day,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          Text(
            date,
            style: const TextStyle(
              fontSize: 9,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 3. DAILY TASKS SECTION
  // ==========================================
  Widget _buildDailyTasksCard() {
    return Obx(() {
      final summary = TaskController.instance.taskSummary.value;
      final tasks = TaskController.instance.todayTasks;
      final isClocked = TaskController.instance.todayResponse.value?.isClockedIn ?? AttendanceController.instance.todayStatus.value?.isClockedIn ?? false;
      final completedCount = summary?.completedTasks ?? 0;
      final totalCount = summary?.totalTasks ?? (tasks.isNotEmpty ? tasks.length : 1);
      final progress = totalCount > 0 ? completedCount / totalCount : 0.0;
      final pendingCount = summary?.pendingTasks ?? (tasks.where((t) => !t.isCompleted).length);

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.025),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 3.5,
              constraints: const BoxConstraints(minHeight: 60),
              margin: const EdgeInsets.only(right: 14),
              decoration: BoxDecoration(color: const Color(0xFFD97706), borderRadius: BorderRadius.circular(4)),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD97706),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.check_box_rounded, color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Daily Tasks",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          if (!isClocked)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "Clock in to view",
                                style: TextStyle(fontSize: 11, color: Color(0xFF2563EB), fontWeight: FontWeight.w600),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: pendingCount > 0 ? const Color(0xFFFEE2E2) : const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: pendingCount > 0 ? const Color(0xFFEF4444) : const Color(0xFF059669),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      pendingCount > 0 ? Icons.priority_high_rounded : Icons.check,
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    pendingCount > 0 ? "$pendingCount pending" : "All completed!",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: pendingCount > 0 ? const Color(0xFFDC2626) : const Color(0xFF065F46),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => setState(() => _currentNavIndex = 1),
                            child: const Row(
                              children: [
                                Text(
                                  "View All",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0F172A),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF0F172A)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Content
                  if (!isClocked)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "Please clock in with GPS to unlock today's branch tasks.",
                        style: TextStyle(fontSize: 12, color: const Color(0xFF64748B).withValues(alpha: 0.9)),
                      ),
                    )
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Circular Donut Progress
                        SizedBox(
                          width: 95,
                          height: 95,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CustomPaint(
                                size: const Size(95, 95),
                                painter: _DonutProgressPainter(
                                  progress: progress,
                                  progressColor: const Color(0xFF059669),
                                  backgroundColor: const Color(0xFFE2E8F0),
                                  strokeWidth: 9,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "$completedCount/$totalCount",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  const Text(
                                    "Completed",
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      color: Color(0xFF64748B),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Task Items List
                        Expanded(
                          child: Column(
                            children: tasks.take(4).map((task) {
                              final isDone = task.isCompleted;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: GestureDetector(
                                  onTap: task.canToggle ? () => TaskController.instance.toggleTask(task) : null,
                                  child: Row(
                                    children: [
                                      Icon(
                                        isDone ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                                        color: isDone ? const Color(0xFF059669) : const Color(0xFF94A3B8),
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          task.taskName,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDone ? const Color(0xFF64748B) : const Color(0xFF0F172A),
                                            fontWeight: FontWeight.w500,
                                            decoration: isDone ? TextDecoration.lineThrough : null,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // ==========================================
  // 4. TARGETS SECTION
  // ==========================================
  Widget _buildTargetsCard() {
    return Obx(() {
      final stats = TargetController.instance.stats.value;
      final targets = TargetController.instance.targetsList;
      final double progressFraction = (stats.overallAchievementPercentage / 100.0).clamp(0.0, 1.0);
      final int pendingCount = stats.pendingLogsCount;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.025),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 3.5,
              constraints: const BoxConstraints(minHeight: 60),
              margin: const EdgeInsets.only(right: 14),
              decoration: BoxDecoration(color: const Color(0xFF0284C7), borderRadius: BorderRadius.circular(4)),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => setState(() => _currentNavIndex = 3),
                        borderRadius: BorderRadius.circular(10),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0284C7),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Iconsax.radar, color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Targets",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          if (pendingCount > 0)
                            DecoratedBox(
                              decoration: const BoxDecoration(
                                color: Color(0xFFFEE2E2),
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFEF4444),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(2),
                                        child: Icon(Icons.priority_high_rounded, color: Colors.white, size: 10),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "$pendingCount logs pending",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFFDC2626),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => setState(() => _currentNavIndex = 3),
                            child: const Row(
                              children: [
                                Text(
                                  "View Details",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF0F172A),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF0F172A)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Content: Left Donut, Right Metric Columns + Progress Bar
                  Row(
                    children: [
                      SizedBox(
                        width: 95,
                        height: 95,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                              size: const Size(95, 95),
                              painter: _DonutProgressPainter(
                                progress: progressFraction,
                                progressColor: const Color(0xFF059669),
                                backgroundColor: const Color(0xFFE2E8F0),
                                strokeWidth: 9,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "${stats.overallAchievementPercentage.toStringAsFixed(0)}%",
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const Text(
                                  "Achieved",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF64748B),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 18),

                      // Metrics & Bar
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Active", style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                    const SizedBox(height: 2),
                                    Text("${stats.activeTargetsCount}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Units Sold", style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                    const SizedBox(height: 2),
                                    Text("${stats.totalUnitsSold.toInt()}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF16A34A))),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Commission", style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                    const SizedBox(height: 2),
                                    Text("\$${stats.totalCommissionEarned.toInt()}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFFD97706))),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Progress Bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: progressFraction,
                                backgroundColor: const Color(0xFFE2E8F0),
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF059669)),
                                minHeight: 7,
                              ),
                            ),
                            const SizedBox(height: 6),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${targets.length} targets assigned",
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                ),
                                Text(
                                  "${stats.overallAchievementPercentage.toStringAsFixed(1)}%",
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // ==========================================
  // 5. EARNINGS & PAYMENTS SECTION
  // ==========================================
  Widget _buildEarningsAndPaymentsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3.5,
            constraints: const BoxConstraints(minHeight: 60),
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(color: const Color(0xFF7C3AED), borderRadius: BorderRadius.circular(4)),
          ),
          Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => setState(() => _currentNavIndex = 4),
                borderRadius: BorderRadius.circular(10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.savings_rounded, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Earnings & Payments",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF64748B)),
                  ],
                ),
              ),
              _buildDropdownFilter(
                _selectedEarningsPeriod,
                (val) => setState(() => _selectedEarningsPeriod = val!),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Horizontal Financial Cards
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildFinanceCard(
                  icon: Icons.account_balance_wallet_rounded,
                  iconColor: const Color(0xFF059669),
                  iconBg: const Color(0xFFDCFCE7),
                  title: "Total Paid",
                  amount: "₹ 45,000",
                  amountColor: const Color(0xFF059669),
                ),
                const SizedBox(width: 10),
                _buildFinanceCard(
                  icon: Icons.access_time_filled_rounded,
                  iconColor: const Color(0xFF2563EB),
                  iconBg: const Color(0xFFDBEAFE),
                  title: "Not Paid",
                  amount: "₹ 10,000",
                  amountColor: const Color(0xFF2563EB),
                ),
                const SizedBox(width: 10),
                _buildFinanceCard(
                  icon: Icons.priority_high_rounded,
                  iconColor: const Color(0xFFEF4444),
                  iconBg: const Color(0xFFFEE2E2),
                  title: "Due Amount",
                  amount: "₹ 5,000",
                  amountColor: const Color(0xFFEF4444),
                ),
                const SizedBox(width: 10),
                _buildFinanceCard(
                  icon: Icons.handshake_rounded,
                  iconColor: const Color(0xFFD97706),
                  iconBg: const Color(0xFFFEF3C7),
                  title: "Loan",
                  amount: "₹ 8,000",
                  amountColor: const Color(0xFFD97706),
                ),
                const SizedBox(width: 10),
                _buildFinanceCard(
                  icon: Icons.bar_chart_rounded,
                  iconColor: const Color(0xFF7C3AED),
                  iconBg: const Color(0xFFF3E8FF),
                  title: "Commission",
                  amount: "₹ 12,500",
                  amountColor: const Color(0xFF7C3AED),
                ),
              ],
            ),
          ),
        ],
      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String amount,
    required Color amountColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Text(
                amount,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: amountColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // DROPDOWN FILTER HELPER
  // ==========================================
  Widget _buildDropdownFilter(String value, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Color(0xFF64748B)),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
          isDense: true,
          items: const [
            DropdownMenuItem(value: "This Month", child: Text("This Month")),
            DropdownMenuItem(value: "Last Month", child: Text("Last Month")),
            DropdownMenuItem(value: "This Year", child: Text("This Year")),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ==========================================
  // BOTTOM NAVIGATION BAR
  // ==========================================
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, "Dashboard"),
              _buildNavItem(1, Icons.assignment_rounded, Icons.assignment_outlined, "Tasks"),
              _buildNavItem(2, Icons.calendar_today_rounded, Icons.calendar_today_outlined, "Attendance"),
              _buildNavItem(3, Iconsax.radar, Iconsax.radar, "Targets"),
              _buildNavItem(4, Icons.credit_card_rounded, Icons.credit_card_outlined, "Payroll"),
              _buildNavItem(5, Icons.person_rounded, Icons.person_outline_rounded, "Me"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isSelected = _currentNavIndex == index;

    return InkWell(
      onTap: () => _setNav(index),
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
              size: 22,
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// CUSTOM PERFORMANCE LINE CHART PAINTER
// ==========================================
class _PerformanceChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const leftPadding = 24.0;
    const bottomPadding = 20.0;
    final chartWidth = size.width - leftPadding;
    final chartHeight = size.height - bottomPadding;

    // Draw Y-Axis Labels & Grid lines
    final yLabels = ["100", "75", "50", "25", "0"];
    final textStyle = const TextStyle(fontSize: 8.5, color: Color(0xFF94A3B8));
    final gridPaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..strokeWidth = 1;

    for (int i = 0; i < 5; i++) {
      final y = chartHeight * (i / 4.0);
      canvas.drawLine(Offset(leftPadding, y), Offset(size.width, y), gridPaint);

      final textSpan = TextSpan(text: yLabels[i], style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(0, y - textPainter.height / 2));
    }

    // Draw X-Axis Labels & Vertical Grid lines
    final xLabels = ["1 Mar", "8 Mar", "15 Mar", "22 Mar", "31 Mar"];
    for (int i = 0; i < 5; i++) {
      final x = leftPadding + chartWidth * (i / 4.0);
      canvas.drawLine(Offset(x, 0), Offset(x, chartHeight), gridPaint);

      final textSpan = TextSpan(text: xLabels[i], style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, chartHeight + 4),
      );
    }

    // Chart Data Points (Normalized 0.0 to 1.0)
    final points = [
      const Offset(0.0, 0.12),
      const Offset(0.12, 0.22),
      const Offset(0.25, 0.28),
      const Offset(0.38, 0.44),
      const Offset(0.50, 0.42),
      const Offset(0.62, 0.58),
      const Offset(0.75, 0.65),
      const Offset(0.88, 0.76),
      const Offset(1.0, 0.90),
    ];

    final path = Path();
    final fillPath = Path();

    final screenPoints = points.map((p) {
      final px = leftPadding + p.dx * chartWidth;
      final py = chartHeight - (p.dy * chartHeight);
      return Offset(px, py);
    }).toList();

    path.moveTo(screenPoints.first.dx, screenPoints.first.dy);
    fillPath.moveTo(screenPoints.first.dx, chartHeight);
    fillPath.lineTo(screenPoints.first.dx, screenPoints.first.dy);

    for (int i = 0; i < screenPoints.length - 1; i++) {
      final p0 = screenPoints[i];
      final p1 = screenPoints[i + 1];
      final controlX = (p0.dx + p1.dx) / 2;
      path.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
      fillPath.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
    }

    fillPath.lineTo(screenPoints.last.dx, chartHeight);
    fillPath.close();

    // Gradient Fill
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF8B5CF6).withValues(alpha: 0.35),
        const Color(0xFF3B82F6).withValues(alpha: 0.05),
      ],
    );

    final fillPaint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(leftPadding, 0, chartWidth, chartHeight));
    canvas.drawPath(fillPath, fillPaint);

    // Line Paint
    final linePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
      ).createShader(Rect.fromLTWH(leftPadding, 0, chartWidth, chartHeight))
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);

    // Dots
    final dotFillPaint = Paint()..color = const Color(0xFF6366F1);
    final dotBorderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (final pt in screenPoints) {
      canvas.drawCircle(pt, 3.5, dotFillPaint);
      canvas.drawCircle(pt, 3.5, dotBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==========================================
// CUSTOM DONUT PROGRESS PAINTER
// ==========================================
class _DonutProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  const _DonutProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, bgPaint);

    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _DonutProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
