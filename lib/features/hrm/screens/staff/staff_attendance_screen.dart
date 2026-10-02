import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:auth_ui_app/features/hrm/controllers/controllers.dart';
import 'package:auth_ui_app/features/hrm/models/attendance_model.dart';
import 'package:auth_ui_app/features/hrm/models/auth_response_model.dart';
import 'package:auth_ui_app/services/auth_service.dart';

class AttendanceScreen extends StatefulWidget {
  final VoidCallback? onBackToDashboard;

  const AttendanceScreen({super.key, this.onBackToDashboard});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final AttendanceController controller = AttendanceController.instance;
  bool _showingHistory = false;
  String _selectedTab = 'Today'; // 'Today', 'This Week', 'This Month'

  @override
  void initState() {
    super.initState();
    controller.refreshAll();
  }

  @override
  Widget build(BuildContext context) {
    return _showingHistory ? _buildHistoryView() : _buildTodayView();
  }

  // =========================================================================
  // VIEW 1: TODAY'S ATTENDANCE VIEW
  // =========================================================================
  Widget _buildTodayView() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: RefreshIndicator(
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
                  // Header Bar
                  _buildTopHeader(),
                  const SizedBox(height: 16),

                  // Segmented Tabs (Today / History Toggle)
                  _buildSegmentedTabs(),
                  const SizedBox(height: 16),

                  // Business Calendar Status Alerts (Holiday / Leave / Non-working day)
                  if (status != null) _buildCalendarAlertBanners(status),

                  // Today Main Status Alert Banner
                  _buildStatusBanner(isClockedIn, status),
                  const SizedBox(height: 14),

                  // Shift & Schedule Info Cards
                  _buildScheduleRow(status),
                  const SizedBox(height: 14),

                  // Geofence & Location Card
                  _buildGeofenceCard(status),
                  const SizedBox(height: 14),

                  // Main Interactive Clock In / Clock Out Action Button
                  _buildClockActionButton(isClockedIn, canClockIn, canClockOut),
                  const SizedBox(height: 14),

                  // Working Time Metrics Card
                  _buildTodayMetricsCard(status, isClockedIn),
                  const SizedBox(height: 16),

                  // Live Digital Clock & Shift Timeline
                  _buildLiveClockCard(status, isClockedIn),
                  const SizedBox(height: 24),
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
    final user = AuthService.instance.getCurrentUser();
    final todayFormatted = DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now());

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
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Iconsax.calendar_tick, size: 20, color: Color(0xFF2563EB)),
              ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Attendance",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  todayFormatted,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),

        // History Pill Button
        InkWell(
          onTap: () {
            controller.fetchHistory();
            setState(() => _showingHistory = true);
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Row(
              children: [
                Icon(Iconsax.clock, size: 15, color: Color(0xFF2563EB)),
                SizedBox(width: 6),
                Text(
                  "History",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // SEGMENTED TABS
  // =========================================================================
  Widget _buildSegmentedTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _buildTabItem("Today", isSelected: _selectedTab == 'Today', onTap: () {
            setState(() {
              _selectedTab = 'Today';
              _showingHistory = false;
            });
          }),
          _buildTabItem("This Week", isSelected: _selectedTab == 'This Week', onTap: () {
            setState(() {
              _selectedTab = 'This Week';
              _showingHistory = true;
            });
            controller.fetchHistory();
          }),
          _buildTabItem("This Month", isSelected: _selectedTab == 'This Month', onTap: () {
            setState(() {
              _selectedTab = 'This Month';
              _showingHistory = true;
            });
            controller.fetchHistory();
          }),
        ],
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
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFBFDBFE)),
        ),
        child: Row(
          children: [
            const Icon(Icons.event_available_rounded, color: Color(0xFF2563EB), size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                status.leaveTitle != null
                    ? "On Approved Leave: ${status.leaveTitle}"
                    : "You are on approved full-day leave today.",
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E40AF)),
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
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Row(
          children: [
            Icon(Icons.weekend_rounded, color: Color(0xFF64748B), size: 18),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Company Weekend / Non-Working Day",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  // =========================================================================
  // STATUS BANNER
  // =========================================================================
  Widget _buildStatusBanner(bool isClockedIn, TodayAttendanceStatus? status) {
    final Color bgColor = isClockedIn ? const Color(0xFFECFDF5) : const Color(0xFFFFF1F2);
    final Color borderColor = isClockedIn ? const Color(0xFFA7F3D0) : const Color(0xFFFFE4E6);
    final Color textColor = isClockedIn ? const Color(0xFF065F46) : const Color(0xFF991B1B);
    final Color iconColor = isClockedIn ? const Color(0xFF059669) : const Color(0xFFEF4444);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                isClockedIn ? Icons.check_circle_rounded : Icons.login_rounded,
                color: iconColor,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isClockedIn ? "You are Checked In!" : "You haven't checked in yet",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isClockedIn
                      ? "Clocked in at ${status?.clockIn ?? '--'} • Status: Present"
                      : "Mark your attendance to record your work session.",
                  style: TextStyle(
                    fontSize: 11.5,
                    color: textColor.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // SCHEDULE ROW
  // =========================================================================
  Widget _buildScheduleRow(TodayAttendanceStatus? status) {
    final shift = status?.shift;
    final shiftName = shift?.name ?? "General Shift";
    final shiftTime = (shift != null && shift.startTime.isNotEmpty)
        ? "${_formatTime(shift.startTime)} - ${_formatTime(shift.endTime)}"
        : "09:00 AM - 06:00 PM";

    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            icon: Iconsax.calendar_1,
            iconColor: const Color(0xFF059669),
            iconBg: const Color(0xFFDCFCE7),
            title: "Work Schedule",
            value: shiftTime,
            subtitle: shiftName,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            icon: Iconsax.clock,
            iconColor: const Color(0xFF2563EB),
            iconBg: const Color(0xFFDBEAFE),
            title: "Hours Worked",
            value: status?.isClockedIn == true
                ? controller.liveElapsedTime.value
                : (status?.totalHours ?? "0.00 hours"),
            subtitle: status?.isClockedIn == true ? "Currently Active" : "Logged for today",
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String value,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
            ),
          ],
        ],
      ),
    );
  }

  // =========================================================================
  // GEOFENCE CARD
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

    return Container(
      padding: const EdgeInsets.all(14),
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
      child: Row(
        children: [
          // Geofence Radar Graphic
          SizedBox(
            width: 110,
            height: 95,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomPaint(
                painter: _GeofenceRadarPainter(isInside: isInside),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Location Meta
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "GEOFENCE AREA",
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF94A3B8), letterSpacing: 0.5),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: isInside ? const Color(0xFFDCFCE7) : const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(isInside ? Icons.check_circle_rounded : Icons.info_outline, size: 10, color: isInside ? const Color(0xFF059669) : const Color(0xFFDC2626)),
                          const SizedBox(width: 3),
                          Text(
                            isInside ? "Inside Radius" : "Outside",
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: isInside ? const Color(0xFF059669) : const Color(0xFFDC2626),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  locName,
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  locAddress,
                  style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B), height: 1.2),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  "GPS: ${controller.currentLat.value.toStringAsFixed(4)}, ${controller.currentLng.value.toStringAsFixed(4)} (±12m)",
                  style: const TextStyle(fontSize: 9.5, color: Color(0xFF94A3B8), fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // MAIN CLOCK ACTION BUTTON
  // =========================================================================
  Widget _buildClockActionButton(bool isClockedIn, bool canClockIn, bool canClockOut) {
    final Color buttonColor = isClockedIn ? const Color(0xFFDC2626) : const Color(0xFF059669);
    final String title = isClockedIn ? "Clock Out" : "Clock In";
    final String subtitle = isClockedIn ? "Finish work shift & calculate duration" : "Start your work shift (Geofence Verified)";

    return Obx(() {
      final isBusy = controller.isClocking.value;

      return InkWell(
        onTap: isBusy ? null : controller.toggleClockInOut,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: buttonColor.withValues(alpha: 0.35),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isBusy
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
                          ),
                        )
                      : Icon(
                          isClockedIn ? Icons.logout_rounded : Icons.login_rounded,
                          color: buttonColor,
                          size: 22,
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.white.withValues(alpha: 0.88),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 16),
            ],
          ),
        ),
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
                  value: status?.totalHours ?? "0.00h",
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

  Widget _buildMetricItem({required String label, required String value, required IconData icon, required Color iconColor}) {
    return Column(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
      ],
    );
  }

  // =========================================================================
  // LIVE DIGITAL CLOCK & TIMELINE CARD
  // =========================================================================
  Widget _buildLiveClockCard(TodayAttendanceStatus? status, bool isClockedIn) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "CURRENT SYSTEM TIME",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8), letterSpacing: 0.5),
              ),
              const SizedBox(height: 4),
              Obx(() => Text(
                    controller.liveCurrentTime.value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5,
                      fontFamily: 'monospace',
                    ),
                  )),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isClockedIn ? const Color(0xFF059669).withValues(alpha: 0.25) : Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isClockedIn ? const Color(0xFF059669) : Colors.white.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isClockedIn ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isClockedIn ? "SHIFT ACTIVE" : "OFF SHIFT",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: isClockedIn ? const Color(0xFF34D399) : Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // VIEW 2: FULL ATTENDANCE HISTORY VIEW
  // =========================================================================
  Widget _buildHistoryView() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: RefreshIndicator(
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
                  // History Top Bar
                  _buildHistoryTopBar(),
                  const SizedBox(height: 16),

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
        ),
      ),
    );
  }

  // =========================================================================
  // HISTORY TOP BAR
  // =========================================================================
  Widget _buildHistoryTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => setState(() => _showingHistory = false),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF1E293B)),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Attendance History",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Monthly attendance logs & overtime records",
                  style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ],
        ),

        IconButton(
          onPressed: () => controller.fetchHistory(),
          icon: const Icon(Icons.refresh_rounded, color: Color(0xFF2563EB)),
        ),
      ],
    );
  }

  // =========================================================================
  // MONTH SELECTOR
  // =========================================================================
  Widget _buildMonthSelector() {
    final currentMonthDate = DateTime(controller.selectedYear.value, controller.selectedMonth.value);
    final monthName = DateFormat('MMMM yyyy').format(currentMonthDate);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
// CUSTOM GEOFENCE RADAR PAINTER
// =========================================================================
class _GeofenceRadarPainter extends CustomPainter {
  final bool isInside;
  _GeofenceRadarPainter({required this.isInside});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Background tile
    final bgPaint = Paint()..color = const Color(0xFF0F172A);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Radar rings
    final ringPaint = Paint()
      ..color = (isInside ? const Color(0xFF059669) : const Color(0xFF2563EB)).withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawCircle(center, 18, ringPaint);
    canvas.drawCircle(center, 34, ringPaint);
    canvas.drawCircle(center, 48, ringPaint);

    // Allowed Geofence Radius Area Fill
    final zonePaint = Paint()
      ..color = (isInside ? const Color(0xFF10B981) : const Color(0xFF3B82F6)).withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 34, zonePaint);

    // Office Landmark Center Pin
    final officePaint = Paint()..color = const Color(0xFF38BDF8);
    canvas.drawCircle(center, 4, officePaint);

    // User GPS Dot
    final userPos = isInside ? Offset(center.dx + 4, center.dy - 3) : Offset(center.dx + 38, center.dy - 12);
    final userDot = Paint()..color = isInside ? const Color(0xFF22C55E) : const Color(0xFFEF4444);
    canvas.drawCircle(userPos, 4.5, userDot);

    // Pulse ring around user
    final pulsePaint = Paint()
      ..color = (isInside ? const Color(0xFF22C55E) : const Color(0xFFEF4444)).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(userPos, 8, pulsePaint);
  }

  @override
  bool shouldRepaint(covariant _GeofenceRadarPainter oldDelegate) => oldDelegate.isInside != isInside;
}
