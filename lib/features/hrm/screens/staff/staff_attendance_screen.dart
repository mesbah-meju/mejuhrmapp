import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:auth_ui_app/common/widgets/app_page_header.dart';
import 'package:auth_ui_app/features/hrm/controllers/controllers.dart';
import 'package:auth_ui_app/features/hrm/models/attendance_model.dart';
import 'package:auth_ui_app/features/hrm/models/auth_response_model.dart';
import 'package:auth_ui_app/services/sync_controller.dart';

class AttendanceScreen extends StatefulWidget {
  final VoidCallback? onBackToDashboard;

  const AttendanceScreen({super.key, this.onBackToDashboard});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final AttendanceController controller = AttendanceController.instance;
  final SyncController syncController = SyncController.instance;

  @override
  void initState() {
    super.initState();
    controller.refreshAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Top Nav Header with Online Status and History Button
            AppPageHeader(
              title: "Attendance",
              onBack: widget.onBackToDashboard ?? () => Navigator.of(context).maybePop(),
              action: AppHeaderActionBadge.history(
                onTap: () {
                  Get.to(
                    () => const AttendanceHistoryScreen(),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 240),
                  );
                },
              ),
            ),

            // Main Content Area (Today's Attendance View)
            Expanded(
              child: _buildTodayTab(),
            ),
          ],
        ),
      ),
    );
  }



  // =========================================================================
  // TAB 1: TODAY'S ATTENDANCE VIEW
  // =========================================================================
  Widget _buildTodayTab() {
    return RefreshIndicator(
      onRefresh: controller.refreshAll,
      color: const Color(0xFF2563EB),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Obx(() {
          final status = controller.todayStatus.value;
          final isClockedIn = status?.isClockedIn ?? false;
          final canClockIn = status?.canClockIn ?? !isClockedIn;
          final canClockOut = status?.canClockOut ?? isClockedIn;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Business Calendar Alerts (Holiday / Leave / Non-working day)
              if (status != null) _buildCalendarAlertBanners(status),

              // 1. Geofence & Office Location Card (Positioned at TOP of the page)
              _buildGeofenceCard(status),
              const SizedBox(height: 14),

              // 2. Main Interactive Circular Check In / Check Out Card
              _buildClockActionButton(isClockedIn, canClockIn, canClockOut),
              const SizedBox(height: 14),

              // 3. Today's Working Time Metrics Card
              _buildTodayMetricsCard(status, isClockedIn),
              const SizedBox(height: 14),

              // 4. Single Unified Shift & Break Info Card in the Bottom
              _buildShiftAndBreakCard(status),
              const SizedBox(height: 24),
            ],
          );
        }),
      ),
    );
  }

  // =========================================================================
  // CALENDAR & POLICY STATUS ALERTS
  // =========================================================================
  Widget _buildCalendarAlertBanners(TodayAttendanceStatus status) {
    if (status.isHoliday) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF3C7),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFFDE68A)),
        ),
        child: Row(
          children: [
            const Icon(Icons.celebration_rounded, color: Color(0xFFD97706), size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                status.holidayName != null
                    ? "Official Holiday: ${status.holidayName}"
                    : "Today is an official company holiday.",
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF92400E)),
              ),
            ),
          ],
        ),
      );
    }

    if (status.isOnLeave) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFEDE9FE),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFDDD6FE)),
        ),
        child: Row(
          children: [
            const Icon(Icons.beach_access_rounded, color: Color(0xFF7C3AED), size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                status.leaveTitle != null
                    ? "On Leave: ${status.leaveTitle}"
                    : "You are marked as on approved leave today.",
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF5B21B6)),
              ),
            ),
          ],
        ),
      );
    }

    if (!status.isWorkingDay) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFCBD5E1)),
        ),
        child: const Row(
          children: [
            Icon(Icons.weekend_rounded, color: Color(0xFF64748B), size: 18),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Non-Working Day / Scheduled Weekend",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  // =========================================================================
  // UNIFIED SHIFT & BREAK INFO CARD (Positioned at bottom)
  // =========================================================================
  Widget _buildShiftAndBreakCard(TodayAttendanceStatus? status) {
    final shift = status?.shift;
    final shiftName = shift?.name ?? "Regular Day Shift";
    final startTime = shift?.startTime;
    final endTime = shift?.endTime;
    final breakStartTime = shift?.breakStartTime;
    final breakEndTime = shift?.breakEndTime;

    final shiftTimes = (startTime != null && endTime != null)
        ? "${_formatTime(startTime)} - ${_formatTime(endTime)}"
        : "09:00 AM - 05:00 PM";
    final breakTimes = (breakStartTime != null && breakEndTime != null)
        ? "${_formatTime(breakStartTime)} - ${_formatTime(breakEndTime)}"
        : "01:00 PM - 01:30 PM";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(Iconsax.calendar_1, size: 16, color: Color(0xFF2563EB)),
              ),
              const SizedBox(width: 10),
              const Text(
                "Shift & Schedule Details",
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 14),

          // 1. Shift Row (Top)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(Iconsax.clock, size: 16, color: Color(0xFF2563EB)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Shift",
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      shiftName,
                      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  shiftTimes,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF8FAFC)),
          const SizedBox(height: 12),

          // 2. Break Row (Below Shift)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(Iconsax.coffee, size: 16, color: Color(0xFFD97706)),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Break",
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "30 Min Window",
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFEF3C7)),
                ),
                child: Text(
                  breakTimes,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFB45309)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // GEOFENCE AREA CARD (Exact 100% Match with Design Spec)
  // =========================================================================
  Widget _buildGeofenceCard(TodayAttendanceStatus? status) {
    final loc = status?.checkInLocation ?? controller.activeTenantLocation.value;
    final locName = loc != null
        ? (loc is AttendanceLocationDetail ? loc.name : (loc is TenantLocationModel ? loc.locationName : 'Main Office'))
        : "Main Office";
    final locAddress = (loc is AttendanceLocationDetail && loc.address != null)
        ? loc.address!
        : (loc is TenantLocationModel ? loc.address : "Central Headquarters");
    final isInside = controller.isWithinGeofence.value;

    final Color pillBg = isInside ? const Color(0xFFE8F8EE) : const Color(0xFFFEF2F2);
    final Color pinColor = isInside ? const Color(0xFF00A86B) : const Color(0xFFDC2626);
    final String statusText = isInside ? "In Range" : "Not in Range";

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left Content Area (Title, Subtitle, Status Pill)
              Expanded(
                flex: 11,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Office Name
                      Text(
                        locName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      // Office Address Subtitle
                      Text(
                        locAddress,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF8CA0B3),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),

                      // Location Status Pill ("In Range" / "Not in Range")
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5.5),
                        decoration: BoxDecoration(
                          color: pillBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isInside ? Icons.check_circle_rounded : Icons.cancel_rounded,
                              size: 13,
                              color: pinColor,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              statusText,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: pinColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Right Vector Map Graphic (Matching screenshot)
              Expanded(
                flex: 11,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      constraints: const BoxConstraints(minHeight: 110),
                      child: CustomPaint(
                        painter: _GeofenceMapPainter(isInside: isInside),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // MAIN CLOCK ACTION BUTTON (With Optional Notes Prompt)
  // =========================================================================
  Widget _buildClockActionButton(bool isClockedIn, bool canClockIn, bool canClockOut) {
    return Obx(() {
      final isBusy = controller.isClocking.value;
      final isWithinGeofence = controller.isWithinGeofence.value;
      return _CircularHoldToPunchCard(
        isClockedIn: isClockedIn,
        isBusy: isBusy,
        isWithinGeofence: isWithinGeofence,
        onPunch: (notes) {
          controller.toggleClockInOut(notes: notes);
        },
      );
    });
  }

  // =========================================================================
  // TODAY METRICS CARD
  // =========================================================================
  Widget _buildTodayMetricsCard(TodayAttendanceStatus? status, bool isClockedIn) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Activity Log",
            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  label: "Clock In",
                  value: status?.clockIn != null ? _formatTime(status!.clockIn!) : "--:--",
                  icon: Iconsax.login,
                  iconColor: const Color(0xFF059669),
                ),
              ),
              Container(width: 1, height: 40, color: const Color(0xFFE2E8F0)),
              Expanded(
                child: _buildMetricItem(
                  label: "Clock Out",
                  value: status?.clockOut != null ? _formatTime(status!.clockOut!) : "--:--",
                  icon: Iconsax.logout,
                  iconColor: const Color(0xFFDC2626),
                ),
              ),
              Container(width: 1, height: 40, color: const Color(0xFFE2E8F0)),
              Expanded(
                child: _buildMetricItem(
                  label: "Total Duration",
                  value: status?.totalHours ?? "0.00 hours",
                  icon: Iconsax.timer,
                  iconColor: const Color(0xFF2563EB),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  String _formatTime(String rawTime) {
    try {
      final parts = rawTime.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final dt = DateTime(2026, 1, 1, hour, minute);
        return DateFormat('hh:mm a').format(dt);
      }
    } catch (_) {}
    return rawTime;
  }
}

// =========================================================================
// ATTENDANCE HISTORY & REPORT SCREEN (Daywise & Monthly Tabs)
// =========================================================================
class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  final AttendanceController controller = AttendanceController.instance;
  int _currentTabIndex = 0; // 0: Daywise History, 1: Monthly Report

  @override
  void initState() {
    super.initState();
    controller.fetchHistory();
    controller.fetchStaffReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Top Nav App Bar
            AppPageHeader(
              title: "Attendance History",
              onBack: () => Get.back(),
            ),

            // Segmented Switcher (Daywise History | Monthly Summary)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    _buildTabItem("Daywise History", isSelected: _currentTabIndex == 0, onTap: () {
                      setState(() => _currentTabIndex = 0);
                      controller.fetchHistory();
                    }),
                    _buildTabItem("Monthly Summary", isSelected: _currentTabIndex == 1, onTap: () {
                      setState(() => _currentTabIndex = 1);
                      controller.fetchStaffReport();
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Content Area (Daywise or Monthly)
            Expanded(
              child: IndexedStack(
                index: _currentTabIndex,
                children: [
                  _buildHistoryTab(),
                  _buildReportTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String label, {required bool isSelected, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
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
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // TAB 1: DAYWISE ATTENDANCE HISTORY VIEW
  // =========================================================================
  Widget _buildHistoryTab() {
    return RefreshIndicator(
      onRefresh: () => controller.fetchHistory(),
      color: const Color(0xFF2563EB),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Obx(() {
          final summary = controller.historySummary.value;
          final records = controller.filteredHistory;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Month & Year Selector
              _buildMonthSelector(),
              const SizedBox(height: 14),

              // Monthly Summary Statistics Cards
              if (summary != null) _buildSummaryCards(summary),
              const SizedBox(height: 16),

              // Filter Chips (All, Present, Half Day, Absent, Overtime)
              _buildHistoryFilterChips(),
              const SizedBox(height: 16),

              // History Records List
              if (controller.isLoadingHistory.value)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (records.isEmpty)
                _buildEmptyHistoryState()
              else
                ...records.map((r) => _buildHistoryRecordCard(r)),

              const SizedBox(height: 30),
            ],
          );
        }),
      ),
    );
  }

  // =========================================================================
  // TAB 3: COMPREHENSIVE MONTHLY REPORT VIEW
  // =========================================================================
  Widget _buildReportTab() {
    return RefreshIndicator(
      onRefresh: () => controller.fetchStaffReport(),
      color: const Color(0xFF2563EB),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Obx(() {
          final report = controller.staffReport.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Month & Year Selector
              _buildMonthSelector(),
              const SizedBox(height: 14),

              if (controller.isLoadingReport.value)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (report == null)
                _buildEmptyReportState()
              else ...[
                // Employee Profile Summary Card
                if (report.employee != null) ...[
                  _buildEmployeeProfileCard(report.employee!),
                  const SizedBox(height: 14),
                ],

                // Attendance Rate Progress Card
                _buildAttendanceRateCard(report.summary),
                const SizedBox(height: 14),

                // Hours & Overtime Metrics Row
                _buildReportHoursMetrics(report.summary),
                const SizedBox(height: 14),

                // Attendance Incident Stats Grid
                _buildReportIncidentsGrid(report.summary),
                const SizedBox(height: 18),

                // Day-by-day Activity Timeline
                const Text(
                  "Monthly Timeline Breakdown",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 10),

                if (report.timeline.isEmpty)
                  _buildEmptyHistoryState()
                else
                  ...report.timeline.map((item) => _buildTimelineItemCard(item)),
              ],

              const SizedBox(height: 30),
            ],
          );
        }),
      ),
    );
  }

  // =========================================================================
  // REPORT HELPERS & SUB-WIDGETS
  // =========================================================================
  Widget _buildEmployeeProfileCard(StaffReportEmployeeModel employee) {
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
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Icon(Iconsax.user, color: Color(0xFF2563EB), size: 22),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      employee.name,
                      style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                    ),
                    if (employee.employeeCode != null && employee.employeeCode!.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          employee.employeeCode!,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  "${employee.designation ?? 'Staff'} • ${employee.department ?? 'General'}",
                  style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  "Branch: ${employee.branch ?? 'Main'} | Shift: ${employee.shift ?? 'General'}",
                  style: const TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceRateCard(StaffReportSummaryModel summary) {
    final rate = summary.attendancePercentage;
    final Color rateColor = rate >= 95
        ? const Color(0xFF059669)
        : (rate >= 80 ? const Color(0xFF2563EB) : const Color(0xFFD97706));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Overall Attendance Rate",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
              ),
              Text(
                "${rate.toStringAsFixed(1)}%",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: rateColor),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (rate / 100.0).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(rateColor),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Present: ${summary.presentDaysCount} / ${summary.workingDaysCount} Working Days",
                style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
              ),
              Text(
                "${summary.holidayDaysCount} Holidays • ${summary.leaveDaysCount} Leaves",
                style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportHoursMetrics(StaffReportSummaryModel summary) {
    return Row(
      children: [
        Expanded(
          child: _buildReportMetricBox(
            label: "Worked Hours",
            value: "${summary.workedHours.toStringAsFixed(1)}h",
            subtext: "of ${summary.scheduledHours.toStringAsFixed(0)}h scheduled",
            icon: Iconsax.clock,
            color: const Color(0xFF2563EB),
            bgColor: const Color(0xFFEFF6FF),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildReportMetricBox(
            label: "Overtime (OT)",
            value: "${summary.overtimeHours.toStringAsFixed(1)}h",
            subtext: "+৳${summary.overtimeAmount.toStringAsFixed(1)} bonus",
            icon: Iconsax.trend_up,
            color: const Color(0xFF7C3AED),
            bgColor: const Color(0xFFEDE9FE),
          ),
        ),
      ],
    );
  }

  Widget _buildReportMetricBox({
    required String label,
    required String value,
    required String subtext,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
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
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, size: 14, color: color),
              ),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(subtext, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }

  Widget _buildReportIncidentsGrid(StaffReportSummaryModel summary) {
    return Row(
      children: [
        Expanded(
          child: _buildIncidentPill("Late Entries", "${summary.lateDaysCount}", const Color(0xFFD97706), const Color(0xFFFEF3C7)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildIncidentPill("Early Exits", "${summary.earlyExitCount}", const Color(0xFFEA580C), const Color(0xFFFFEDD5)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildIncidentPill("Half Days", "${summary.halfDaysCount}", const Color(0xFF6366F1), const Color(0xFFEEF2FF)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildIncidentPill("Absences", "${summary.absentDaysCount}", const Color(0xFFDC2626), const Color(0xFFFEE2E2)),
        ),
      ],
    );
  }

  Widget _buildIncidentPill(String label, String count, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Text(count, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 9.5, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItemCard(StaffReportTimelineItem item) {
    final isPresent = item.status.toLowerCase() == 'present';
    final isHoliday = item.dayType == 'holiday' || item.holidayName != null;
    final isLeave = item.dayType == 'leave' || item.leaveTitle != null;
    final Color badgeColor = isPresent
        ? const Color(0xFF059669)
        : (isHoliday
            ? const Color(0xFFD97706)
            : (isLeave ? const Color(0xFF7C3AED) : const Color(0xFFDC2626)));
    final Color badgeBg = isPresent
        ? const Color(0xFFDCFCE7)
        : (isHoliday
            ? const Color(0xFFFEF3C7)
            : (isLeave ? const Color(0xFFEDE9FE) : const Color(0xFFFEE2E2)));

    String dateFormatted = item.date;
    try {
      final dt = DateTime.parse(item.date);
      dateFormatted = DateFormat('EEE, dd MMM').format(dt);
    } catch (_) {}

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
                    dateFormatted,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                  ),
                  if (item.isLate) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(4)),
                      child: const Text("LATE", style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w800, color: Color(0xFFD97706))),
                    ),
                  ],
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(6)),
                child: Text(
                  item.status.toUpperCase(),
                  style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: badgeColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (isHoliday && item.holidayName != null)
            Text("Official Holiday: ${item.holidayName}", style: const TextStyle(fontSize: 11, color: Color(0xFF92400E), fontWeight: FontWeight.w600))
          else if (isLeave && item.leaveTitle != null)
            Text("Approved Leave: ${item.leaveTitle}", style: const TextStyle(fontSize: 11, color: Color(0xFF5B21B6), fontWeight: FontWeight.w600))
          else
            Row(
              children: [
                Expanded(
                  child: Text(
                    "In: ${item.clockIn != null ? _formatTime(item.clockIn!) : '--:--'}",
                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Out: ${item.clockOut != null ? _formatTime(item.clockOut!) : '--:--'}",
                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                  ),
                ),
                Text(
                  "${item.workedHours.toStringAsFixed(1)}h worked",
                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFF2563EB)),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyReportState() {
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
          Icon(Iconsax.document_text_1, size: 48, color: Color(0xFF94A3B8)),
          SizedBox(height: 12),
          Text(
            "No Monthly Report Found",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
          SizedBox(height: 4),
          Text(
            "There are no attendance statistics generated for this period.",
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // MONTH & YEAR SELECTOR
  // =========================================================================
  Widget _buildMonthSelector() {
    final monthName = DateFormat('MMMM yyyy').format(
      DateTime(controller.selectedYear.value, controller.selectedMonth.value),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              final prev = DateTime(controller.selectedYear.value, controller.selectedMonth.value - 1);
              controller.changeMonth(prev.month, prev.year);
            },
            icon: const Icon(Icons.chevron_left_rounded, color: Color(0xFF1E293B)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Row(
            children: [
              const Icon(Iconsax.calendar_2, size: 18, color: Color(0xFF2563EB)),
              const SizedBox(width: 8),
              Text(
                monthName,
                style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              final next = DateTime(controller.selectedYear.value, controller.selectedMonth.value + 1);
              controller.changeMonth(next.month, next.year);
            },
            icon: const Icon(Icons.chevron_right_rounded, color: Color(0xFF1E293B)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // SUMMARY CARDS
  // =========================================================================
  Widget _buildSummaryCards(AttendanceSummaryModel summary) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryStatItem(
                label: "Present",
                count: "${summary.presentDays}",
                color: const Color(0xFF059669),
                bgColor: const Color(0xFFDCFCE7),
                icon: Icons.check_circle_outline_rounded,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSummaryStatItem(
                label: "Half Days",
                count: "${summary.halfDays}",
                color: const Color(0xFFD97706),
                bgColor: const Color(0xFFFEF3C7),
                icon: Icons.timelapse_rounded,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSummaryStatItem(
                label: "Absent",
                count: "${summary.absentDays}",
                color: const Color(0xFFDC2626),
                bgColor: const Color(0xFFFEE2E2),
                icon: Icons.cancel_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildSummaryStatItem(
                label: "Total Worked",
                count: "${summary.totalWorkedHours.toStringAsFixed(1)}h",
                color: const Color(0xFF2563EB),
                bgColor: const Color(0xFFDBEAFE),
                icon: Iconsax.timer_1,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSummaryStatItem(
                label: "Overtime Hours",
                count: "${summary.totalOvertimeHours.toStringAsFixed(1)}h",
                color: const Color(0xFF7C3AED),
                bgColor: const Color(0xFFEDE9FE),
                icon: Iconsax.trend_up,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryStatItem({
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(count, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color)),
                Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // FILTER CHIPS
  // =========================================================================
  Widget _buildHistoryFilterChips() {
    final filters = ['All', 'Present', 'Half Day', 'Absent', 'Overtime'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: filters.map((f) {
          final isSelected = controller.selectedFilter.value == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(f),
              selected: isSelected,
              onSelected: (_) => controller.setFilter(f),
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
            ),
          );
        }).toList(),
      ),
    );
  }

  // =========================================================================
  // HISTORY RECORD CARD
  // =========================================================================
  Widget _buildHistoryRecordCard(AttendanceRecord record) {
    final isPresent = record.status.toLowerCase() == 'present';
    final isHalfDay = record.status.toLowerCase().contains('half') || record.calculatedStatus == 'half_day';
    final Color badgeColor = isPresent ? const Color(0xFF059669) : (isHalfDay ? const Color(0xFFD97706) : const Color(0xFFDC2626));
    final Color badgeBg = isPresent ? const Color(0xFFDCFCE7) : (isHalfDay ? const Color(0xFFFEF3C7) : const Color(0xFFFEE2E2));

    String formattedDate = record.date;
    try {
      final parsed = DateTime.parse(record.date);
      formattedDate = DateFormat('EEE, dd MMM yyyy').format(parsed);
    } catch (_) {}

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row (Date & Status Badge)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Iconsax.calendar_1, size: 16, color: Color(0xFF2563EB)),
                  const SizedBox(width: 8),
                  Text(
                    formattedDate,
                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  record.status.toUpperCase(),
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: badgeColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          // Check-In / Check-Out Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Clock In", style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(
                      record.clockIn != null ? _formatTime(record.clockIn!) : "--:--",
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                    ),
                    if (record.checkInLocation != null)
                      Text(
                        record.checkInLocation!.name,
                        style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Clock Out", style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(
                      record.clockOut != null ? _formatTime(record.clockOut!) : "--:--",
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                    ),
                    if (record.checkOutLocation != null)
                      Text(
                        record.checkOutLocation!.name,
                        style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Total Worked", style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(
                      record.totalHours,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF2563EB)),
                    ),
                    if (record.overtimeHoursNumeric > 0)
                      Text(
                        "+${record.overtimeHours} OT",
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF7C3AED)),
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

  Widget _buildEmptyHistoryState() {
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
          Icon(Iconsax.calendar_remove, size: 48, color: Color(0xFF94A3B8)),
          SizedBox(height: 12),
          Text(
            "No attendance logs found",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
          SizedBox(height: 4),
          Text(
            "There are no recorded sessions for the selected period.",
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // HELPER FORMATTER
  // =========================================================================
  String _formatTime(String rawTime) {
    try {
      final parts = rawTime.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final dt = DateTime(2026, 1, 1, hour, minute);
        return DateFormat('hh:mm a').format(dt);
      }
    } catch (_) {}
    return rawTime;
  }
}

// =========================================================================
// CUSTOM GEOFENCE MAP PAINTER (Exact Vector Match with Screenshot)
// =========================================================================
class _GeofenceMapPainter extends CustomPainter {
  final bool isInside;
  const _GeofenceMapPainter({required this.isInside});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Base Map Background
    final bgPaint = Paint()..color = const Color(0xFFF3F5F7);
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    // 2. City Block Parcels (Subtle slate & soft green park areas)
    final blockPaint = Paint()..color = const Color(0xFFE9ECF0);
    final parkPaint = Paint()..color = const Color(0xFFE2F4E6);

    // Park 1 (Top-Left area)
    final park1 = Path()
      ..moveTo(w * 0.08, h * 0.32)
      ..lineTo(w * 0.28, h * 0.16)
      ..lineTo(w * 0.42, h * 0.44)
      ..lineTo(w * 0.18, h * 0.60)
      ..close();
    canvas.drawPath(park1, parkPaint);

    // Park 2 (Bottom-Left Area)
    final park2 = Path()
      ..moveTo(w * 0.15, h * 0.74)
      ..lineTo(w * 0.42, h * 0.68)
      ..lineTo(w * 0.48, h * 0.98)
      ..lineTo(w * 0.12, h * 0.98)
      ..close();
    canvas.drawPath(park2, parkPaint);

    // Park 3 (Right Area near river)
    final park3 = Path()
      ..moveTo(w * 0.68, h * 0.50)
      ..lineTo(w * 0.82, h * 0.44)
      ..lineTo(w * 0.86, h * 0.72)
      ..lineTo(w * 0.70, h * 0.78)
      ..close();
    canvas.drawPath(park3, parkPaint);

    // Other Building/Parcel Blocks
    final block1 = Path()
      ..moveTo(w * 0.38, h * 0.08)
      ..lineTo(w * 0.58, h * 0.02)
      ..lineTo(w * 0.54, h * 0.24)
      ..lineTo(w * 0.34, h * 0.28)
      ..close();
    canvas.drawPath(block1, blockPaint);

    final block2 = Path()
      ..moveTo(w * 0.62, h * 0.18)
      ..lineTo(w * 0.76, h * 0.12)
      ..lineTo(w * 0.78, h * 0.35)
      ..lineTo(w * 0.64, h * 0.38)
      ..close();
    canvas.drawPath(block2, blockPaint);

    // 3. Roads (Crisp white roads with subtle light gray border)
    final roadBorderPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    final roadPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    // Diagonal Arterial Road 1
    roadBorderPaint.strokeWidth = 14;
    canvas.drawLine(Offset(w * 1.1, h * 0.72), Offset(-w * 0.1, -h * 0.12), roadBorderPaint);
    roadPaint.strokeWidth = 12;
    canvas.drawLine(Offset(w * 1.1, h * 0.72), Offset(-w * 0.1, -h * 0.12), roadPaint);

    // Diagonal Arterial Road 2
    roadBorderPaint.strokeWidth = 12;
    canvas.drawLine(Offset(-w * 0.1, h * 0.42), Offset(w * 0.85, h * 1.1), roadBorderPaint);
    roadPaint.strokeWidth = 10;
    canvas.drawLine(Offset(-w * 0.1, h * 0.42), Offset(w * 0.85, h * 1.1), roadPaint);

    // Secondary Cross Streets
    roadPaint.strokeWidth = 6;
    canvas.drawLine(Offset(w * 0.22, -h * 0.1), Offset(w * 0.68, h * 1.1), roadPaint);
    canvas.drawLine(Offset(w * 0.52, -h * 0.1), Offset(w * 0.95, h * 0.85), roadPaint);
    canvas.drawLine(Offset(-w * 0.1, h * 0.85), Offset(w * 0.48, h * 0.58), roadPaint);

    // Roundabout
    final roundaboutPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(w * 0.74, h * 0.84), 8, roundaboutPaint);

    // 4. Curving River / Waterway on Right
    final riverPaint = Paint()
      ..color = const Color(0xFFBAE6FD)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 26
      ..strokeCap = StrokeCap.round;

    final riverPath = Path()
      ..moveTo(w * 0.80, -h * 0.1)
      ..cubicTo(w * 0.86, h * 0.35, w * 0.96, h * 0.65, w * 1.05, h * 0.92);
    canvas.drawPath(riverPath, riverPaint);

    // 5. Geofence Circular Area & Dashed Perimeter
    final center = Offset(w * 0.56, h * 0.48);
    const double radius = 38.0;

    // Translucent filled radius
    final zoneFill = Paint()
      ..color = (isInside ? const Color(0xFF00A86B) : const Color(0xFFEF4444)).withValues(alpha: 0.14)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, zoneFill);

    // Dashed Green Perimeter Circle
    final dashPaint = Paint()
      ..color = isInside ? const Color(0xFF00A86B) : const Color(0xFFEF4444)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    _drawDashedCircle(canvas, center, radius, dashPaint);

    // 6. Central Teardrop Location Marker Pin (Exact match)
    final pinColor = isInside ? const Color(0xFF00A86B) : const Color(0xFFDC2626);
    _drawLocationPin(canvas, center, pinColor);
  }

  void _drawDashedCircle(Canvas canvas, Offset center, double radius, Paint paint) {
    const int dashCount = 34;
    const double totalAngle = 2 * math.pi;
    const double dashAngle = (totalAngle / dashCount) * 0.55;
    const double gapAngle = (totalAngle / dashCount) * 0.45;

    for (int i = 0; i < dashCount; i++) {
      final double startAngle = i * (dashAngle + gapAngle);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashAngle,
        false,
        paint,
      );
    }
  }

  void _drawLocationPin(Canvas canvas, Offset center, Color pinColor) {
    // A. Bottom Base Shadow / Dot
    final shadowPaint = Paint()..color = pinColor;
    canvas.drawCircle(Offset(center.dx, center.dy + 8), 3.2, shadowPaint);

    // B. Teardrop Shape Pin
    final pinPaint = Paint()
      ..color = pinColor
      ..style = PaintingStyle.fill;

    final pinPath = Path();
    final pinCenter = Offset(center.dx, center.dy - 6);
    const double pinRadius = 10.0;

    pinPath.addArc(
      Rect.fromCircle(center: pinCenter, radius: pinRadius),
      math.pi * 0.75,
      math.pi * 1.5,
    );
    pinPath.lineTo(center.dx, center.dy + 2);
    pinPath.close();

    canvas.drawPath(pinPath, pinPaint);

    // C. Crisp White Center Dot
    final whiteDotPaint = Paint()..color = Colors.white;
    canvas.drawCircle(pinCenter, 3.5, whiteDotPaint);
  }

  @override
  bool shouldRepaint(covariant _GeofenceMapPainter oldDelegate) =>
      oldDelegate.isInside != isInside;
}

// =========================================================================
// OFFICE BUILDING VECTOR ICON PAINTER
// =========================================================================
class _BuildingVectorPainter extends CustomPainter {
  final Color color;
  const _BuildingVectorPainter({this.color = const Color(0xFF00A86B)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.9
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Main Left Building Outer Outline
    final mainBuilding = Path()
      ..moveTo(w * 0.16, h * 0.86)
      ..lineTo(w * 0.16, h * 0.22)
      ..arcToPoint(Offset(w * 0.24, h * 0.14), radius: Radius.circular(w * 0.06))
      ..lineTo(w * 0.58, h * 0.14)
      ..arcToPoint(Offset(w * 0.66, h * 0.22), radius: Radius.circular(w * 0.06))
      ..lineTo(w * 0.66, h * 0.44);

    // Right Attached Building Outline
    final rightBuilding = Path()
      ..moveTo(w * 0.66, h * 0.44)
      ..lineTo(w * 0.78, h * 0.44)
      ..arcToPoint(Offset(w * 0.86, h * 0.52), radius: Radius.circular(w * 0.06))
      ..lineTo(w * 0.86, h * 0.86)
      ..lineTo(w * 0.14, h * 0.86);

    canvas.drawPath(mainBuilding, paint);
    canvas.drawPath(rightBuilding, paint);

    // Door in Main Building
    final door = Path()
      ..moveTo(w * 0.35, h * 0.86)
      ..lineTo(w * 0.35, h * 0.70)
      ..arcToPoint(Offset(w * 0.47, h * 0.70), radius: Radius.circular(w * 0.06))
      ..lineTo(w * 0.47, h * 0.86);
    canvas.drawPath(door, paint);

    // Windows in Main Building
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Top row windows
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.28, h * 0.28, w * 0.08, h * 0.08), const Radius.circular(1)), dotPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.46, h * 0.28, w * 0.08, h * 0.08), const Radius.circular(1)), dotPaint);

    // Middle row windows
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.28, h * 0.44, w * 0.08, h * 0.08), const Radius.circular(1)), dotPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.46, h * 0.44, w * 0.08, h * 0.08), const Radius.circular(1)), dotPaint);

    // Right building windows
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.72, h * 0.56, w * 0.07, h * 0.07), const Radius.circular(1)), dotPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.72, h * 0.68, w * 0.07, h * 0.07), const Radius.circular(1)), dotPaint);
  }

  @override
  bool shouldRepaint(covariant _BuildingVectorPainter oldDelegate) => oldDelegate.color != color;
}

// =========================================================================
// LIVE DIGITAL CLOCK & DATE WIDGET (Isolated state to prevent rebuilds)
// =========================================================================
class _LiveClockAndDateWidget extends StatefulWidget {
  const _LiveClockAndDateWidget();

  @override
  State<_LiveClockAndDateWidget> createState() => _LiveClockAndDateWidgetState();
}

class _LiveClockAndDateWidgetState extends State<_LiveClockAndDateWidget> {
  late Timer _clockTimer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _currentTime = DateTime.now());
      }
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String timeStr = DateFormat('HH:mm:ss').format(_currentTime);
    final String dateStr = DateFormat('MMM dd yyyy EEEE').format(_currentTime);

    return Column(
      children: [
        Text(
          timeStr,
          style: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F382A),
            letterSpacing: 0.5,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          dateStr,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: Color(0xFF5A6E7C),
          ),
        ),
      ],
    );
  }
}

// =========================================================================
// CIRCULAR PRESS & HOLD PUNCH COMPONENT
// =========================================================================
class _CircularHoldToPunchCard extends StatefulWidget {
  final bool isClockedIn;
  final bool isBusy;
  final bool isWithinGeofence;
  final Function(String? notes) onPunch;

  const _CircularHoldToPunchCard({
    required this.isClockedIn,
    required this.isBusy,
    this.isWithinGeofence = true,
    required this.onPunch,
  });

  @override
  State<_CircularHoldToPunchCard> createState() => _CircularHoldToPunchCardState();
}

class _CircularHoldToPunchCardState extends State<_CircularHoldToPunchCard>
    with TickerProviderStateMixin {
  late AnimationController _holdController;
  late Animation<double> _scaleAnimation;

  final TextEditingController _notesController = TextEditingController();
  bool _isEditingRemark = false;
  bool _isHolding = false;

  @override
  void initState() {
    super.initState();

    // 1.4 second press-and-hold threshold
    _holdController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _holdController, curve: Curves.easeInOut),
    );

    _holdController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onPunchTriggered();
      }
    });
  }

  @override
  void dispose() {
    _holdController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onPunchTriggered() {
    HapticFeedback.heavyImpact();
    _holdController.reset();
    setState(() {
      _isHolding = false;
      _isEditingRemark = false;
    });

    final note = _notesController.text.trim();
    widget.onPunch(note.isNotEmpty ? note : null);
    _notesController.clear();
    if (mounted) setState(() {});
  }

  void _startHolding() {
    if (widget.isBusy) return;

    // STRICT GEOFENCE ENFORCEMENT: Block user from holding to check in OR check out when not in range
    if (!widget.isWithinGeofence) {
      final action = widget.isClockedIn ? "Check Out" : "Check In";
      HapticFeedback.heavyImpact();
      Get.snackbar(
        '$action Disabled',
        'You are not in range of the office location. You must be in range to $action.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFDC2626),
        colorText: Colors.white,
        icon: const Icon(Icons.location_off_rounded, color: Colors.white),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
      return;
    }

    HapticFeedback.lightImpact();
    setState(() => _isHolding = true);
    _holdController.forward();
  }

  void _cancelHolding() {
    if (!_isHolding) return;
    setState(() => _isHolding = false);
    if (_holdController.value > 0 && !_holdController.isCompleted) {
      _holdController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isClockedIn = widget.isClockedIn;
    final bool isBlocked = !widget.isWithinGeofence;
    final Color circleColor = isClockedIn
        ? (isBlocked ? const Color(0xFF7F1D1D) : const Color(0xFFE83A58))
        : (isBlocked ? const Color(0xFF1E3A34) : const Color(0xFF063A29));
    final Color haloColor = isClockedIn
        ? (isBlocked ? const Color(0xFFFEE2E2) : const Color(0xFFFAD2D8))
        : (isBlocked ? const Color(0xFFE2ECE5) : const Color(0xFFD6ECD8));
    final String actionText = isClockedIn ? "Check Out" : "Check In";
    final hasRemark = _notesController.text.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. Digital Real-Time Clock & Date (Independent ticker)
          const _LiveClockAndDateWidget(),
          const SizedBox(height: 24),

          // 2. Interactive Hold-to-Punch Circle
          Center(
            child: Listener(
              onPointerDown: (_) => _startHolding(),
              onPointerUp: (_) => _cancelHolding(),
              onPointerCancel: (_) => _cancelHolding(),
              child: AnimatedBuilder(
                animation: _holdController,
                builder: (context, child) {
                  final double holdProgress = _holdController.value;
                  final double scale = _scaleAnimation.value;

                  return Transform.scale(
                    scale: scale,
                    child: SizedBox(
                      width: 204,
                      height: 204,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // A. Outer Halo Ring
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: haloColor,
                            ),
                          ),

                          // B. Animated Hold Progress Ring
                          if (holdProgress > 0)
                            CustomPaint(
                              size: const Size(204, 204),
                              painter: _HoldToPunchArcPainter(
                                progress: holdProgress,
                                arcColor: isClockedIn ? const Color(0xFF991B1B) : const Color(0xFF10B981),
                              ),
                            ),

                          // C. Center Solid Circle Button
                          Container(
                            width: 162,
                            height: 162,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: circleColor,
                              boxShadow: [
                                BoxShadow(
                                  color: circleColor.withValues(alpha: 0.28),
                                  blurRadius: 14,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              shape: const CircleBorder(),
                              child: Center(
                                child: widget.isBusy
                                    ? const Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 28,
                                            height: 28,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.8,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "Recording...",
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Outline Touch Gesture Hand Icon (or Lock when blocked)
                                          SizedBox(
                                            width: 38,
                                            height: 38,
                                            child: isBlocked
                                                ? const Icon(
                                                    Icons.location_off_rounded,
                                                    size: 32,
                                                    color: Colors.white70,
                                                  )
                                                : const CustomPaint(
                                                    painter: _TouchHandVectorPainter(color: Colors.white),
                                                  ),
                                          ),
                                          const SizedBox(height: 8),

                                          // Action Label
                                          Text(
                                            actionText,
                                            style: TextStyle(
                                              fontSize: 16.5,
                                              fontWeight: FontWeight.w700,
                                              color: isBlocked ? Colors.white70 : Colors.white,
                                              letterSpacing: 0.1,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 3. Guidance Pill (Clear status feedback if blocked or ready)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: isBlocked ? const Color(0xFFFEF2F2) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
              border: isBlocked ? Border.all(color: const Color(0xFFFECACA)) : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isBlocked
                      ? Icons.location_off_rounded
                      : (_isHolding ? Icons.lock_clock_rounded : Icons.touch_app_rounded),
                  size: 13,
                  color: isBlocked ? const Color(0xFFDC2626) : const Color(0xFF64748B),
                ),
                const SizedBox(width: 5),
                Text(
                  isBlocked
                      ? "Not in Range • $actionText Disabled"
                      : (_isHolding ? "Release to cancel" : "Press & hold to $actionText"),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isBlocked ? const Color(0xFFDC2626) : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 4. Simple Remark Section
          if (_isEditingRemark)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: circleColor.withValues(alpha: 0.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.edit_note_rounded, size: 16, color: circleColor),
                          const SizedBox(width: 6),
                          const Text(
                            "Add Remark",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF334155),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _isEditingRemark = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: circleColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            "Done",
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notesController,
                    autofocus: true,
                    maxLines: 2,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => setState(() => _isEditingRemark = false),
                    decoration: InputDecoration(
                      hintText: "Type note / remark before punching...",
                      hintStyle: const TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: circleColor, width: 1.2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                  ),
                ],
              ),
            )
          else if (hasRemark)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.notes_rounded, size: 14, color: circleColor),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      "Remark: ${_notesController.text.trim()}",
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF334155),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => _isEditingRemark = true),
                    child: Icon(Icons.edit_rounded, size: 14, color: circleColor),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      _notesController.clear();
                      setState(() {});
                    },
                    child: const Icon(Icons.close_rounded, size: 14, color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
            )
          else
            GestureDetector(
              onTap: () => setState(() => _isEditingRemark = true),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit_note_rounded, size: 15, color: circleColor),
                    const SizedBox(width: 5),
                    Text(
                      "Add Remark",
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: circleColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// =========================================================================
// CUSTOM ARC PAINTER FOR HOLD PROGRESS
// =========================================================================
class _HoldToPunchArcPainter extends CustomPainter {
  final double progress;
  final Color arcColor;

  const _HoldToPunchArcPainter({
    required this.progress,
    required this.arcColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 10) / 2;

    if (progress > 0) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      final sweepAngle = 2 * math.pi * progress;

      final paint = Paint()
        ..color = arcColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9.5
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, -math.pi / 2, sweepAngle, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _HoldToPunchArcPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.arcColor != arcColor;
}

// =========================================================================
// EXACT TOUCH HAND OUTLINE VECTOR PAINTER (Matches screenshot icon)
// =========================================================================
class _TouchHandVectorPainter extends CustomPainter {
  final Color color;

  const _TouchHandVectorPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // 1. Concentric ripple arc at fingertip (x=0.5, y=0.18)
    final rippleRect = Rect.fromCenter(
      center: Offset(w * 0.5, h * 0.18),
      width: w * 0.28,
      height: h * 0.28,
    );
    canvas.drawArc(rippleRect, -math.pi * 0.85, math.pi * 0.7, false, paint);

    // 2. Hand outline path
    final path = Path();
    // Index finger top (rounded)
    path.moveTo(w * 0.45, h * 0.32);
    path.lineTo(w * 0.45, h * 0.18);
    path.arcToPoint(Offset(w * 0.55, h * 0.18), radius: Radius.circular(w * 0.05));
    path.lineTo(w * 0.55, h * 0.36);

    // Middle finger
    path.arcToPoint(Offset(w * 0.65, h * 0.38), radius: Radius.circular(w * 0.05));
    path.lineTo(w * 0.65, h * 0.42);

    // Ring finger
    path.arcToPoint(Offset(w * 0.74, h * 0.45), radius: Radius.circular(w * 0.045));
    path.lineTo(w * 0.74, h * 0.54);

    // Pinky finger & palm right curve
    path.arcToPoint(Offset(w * 0.72, h * 0.68), radius: Radius.circular(w * 0.08), clockwise: true);
    path.quadraticBezierTo(w * 0.68, h * 0.86, w * 0.55, h * 0.88);

    // Wrist bottom
    path.lineTo(w * 0.42, h * 0.88);

    // Thumb left curve & knuckle
    path.quadraticBezierTo(w * 0.32, h * 0.82, w * 0.28, h * 0.66);
    path.quadraticBezierTo(w * 0.24, h * 0.54, w * 0.34, h * 0.48);
    path.lineTo(w * 0.45, h * 0.48);
    path.lineTo(w * 0.45, h * 0.32);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TouchHandVectorPainter oldDelegate) =>
      oldDelegate.color != color;
}

