import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:auth_ui_app/services/sync_controller.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class AttendanceScreen extends StatefulWidget {
  final VoidCallback? onBackToDashboard;

  const AttendanceScreen({super.key, this.onBackToDashboard});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool _showingHistory = false;
  String _selectedTab = 'Today'; // 'Today', 'This Week', 'This Month'
  bool _isCheckedIn = false;
  String _checkInTime = "--";
  String _checkOutTime = "--";
  String _totalHours = "0h 0m";
  String _attendanceStatus = "--";

  int _selectedCalendarDay = 17;
  DateTime _currentMonth = DateTime(2026, 9);

  void _toggleCheckIn() {
    setState(() {
      _isCheckedIn = !_isCheckedIn;
      final now = DateTime.now();
      final formattedTime =
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";

      if (_isCheckedIn) {
        _checkInTime = formattedTime;
        _checkOutTime = "--";
        _totalHours = "8h 15m";
        _attendanceStatus = "Present";
        
        SyncController.instance.enqueueAction(
          actionType: 'attendance_checkin',
          payload: {
            'timestamp': now.toIso8601String(),
            'formatted_time': _checkInTime,
            'latitude': 23.8103,
            'longitude': 90.4125,
            'verified': true,
          },
          userMessage: "Successfully Checked In at $_checkInTime! (Geofence Verified)",
        );
      } else {
        _checkOutTime = formattedTime;
        
        SyncController.instance.enqueueAction(
          actionType: 'attendance_checkout',
          payload: {
            'timestamp': now.toIso8601String(),
            'formatted_time': _checkOutTime,
            'total_hours': _totalHours,
          },
          userMessage: "Successfully Checked Out at $_checkOutTime!",
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _showingHistory ? _buildHistoryView() : _buildTodayView();
  }

  // ==========================================
  // VIEW 1: TODAY'S ATTENDANCE VIEW
  // ==========================================
  Widget _buildTodayView() {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header with Hamburger, Title, and History Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.menu_rounded, size: 28, color: Color(0xFF1E293B)),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 14),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Attendance",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Check-in to start your work day",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // History Pill Button
                  InkWell(
                    onTap: () => setState(() => _showingHistory = true),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.history_rounded, size: 16, color: Color(0xFF1E293B)),
                          SizedBox(width: 5),
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
              ),
              const SizedBox(height: 16),

              // Segmented Tab Selector (Today / This Week / This Month)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    _buildTabButton("Today"),
                    _buildTabButton("This Week"),
                    _buildTabButton("This Month"),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Alert Banner Card (You haven't checked in today!)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFFE4E6)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.priority_high_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isCheckedIn ? "You are Checked In!" : "You haven't checked in today!",
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF991B1B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _isCheckedIn
                                ? "Attendance recorded for today's shift."
                                : "Mark your attendance to start your work day.",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _toggleCheckIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isCheckedIn ? const Color(0xFF059669) : const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                        minimumSize: const Size(0, 34),
                      ),
                      icon: const Icon(Icons.location_on_rounded, size: 14),
                      label: Text(
                        _isCheckedIn ? "Checked In" : "Check In Now",
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Work Schedule & Working Hours (2 Cards Row)
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      icon: Icons.calendar_today_rounded,
                      iconColor: const Color(0xFF059669),
                      iconBg: const Color(0xFFDCFCE7),
                      title: "Work Schedule",
                      value: "09:00 AM - 06:00 PM",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInfoCard(
                      icon: Icons.access_time_filled_rounded,
                      iconColor: const Color(0xFF2563EB),
                      iconBg: const Color(0xFFDBEAFE),
                      title: "Working Hours",
                      value: "8 Hours",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Geofence Map & Location Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Stylized GPS Geofence Map Area
                    SizedBox(
                      width: 130,
                      height: 110,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: CustomPaint(
                          painter: _GeofenceMapPainter(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Location Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Current Location",
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const Text(
                            "Within Office Area",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF059669),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.location_on, size: 14, color: Color(0xFF0F172A)),
                              SizedBox(width: 4),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Head Office",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                    Text(
                                      "House 12, Road 7\nDhanmondi, Dhaka",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF64748B),
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check, size: 12, color: Color(0xFF059669)),
                                SizedBox(width: 3),
                                Text(
                                  "Valid Location",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF059669),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Big Check In / Check Out Action Button
              InkWell(
                onTap: _toggleCheckIn,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: _isCheckedIn ? const Color(0xFFDC2626) : const Color(0xFF059669),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: (_isCheckedIn ? const Color(0xFFDC2626) : const Color(0xFF059669))
                            .withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isCheckedIn ? Icons.logout_rounded : Icons.arrow_forward_rounded,
                          color: _isCheckedIn ? const Color(0xFFDC2626) : const Color(0xFF059669),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isCheckedIn ? "Check Out" : "Check In",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            _isCheckedIn
                                ? "End your work day and clock out"
                                : "Mark your attendance now",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Today's Summary Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.bar_chart_rounded, color: Color(0xFF2563EB), size: 22),
                        SizedBox(width: 8),
                        Text(
                          "Today's Summary",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryColumn("Check In", _checkInTime),
                        const SizedBox(
                          height: 30,
                          child: VerticalDivider(color: Color(0xFFE2E8F0), thickness: 1),
                        ),
                        _buildSummaryColumn("Check Out", _checkOutTime),
                        const SizedBox(
                          height: 30,
                          child: VerticalDivider(color: Color(0xFFE2E8F0), thickness: 1),
                        ),
                        _buildSummaryColumn("Total Hours", _totalHours),
                        const SizedBox(
                          height: 30,
                          child: VerticalDivider(color: Color(0xFFE2E8F0), thickness: 1),
                        ),
                        _buildSummaryColumn("Status", _attendanceStatus),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Recent Activity Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAF5FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.access_time_filled_rounded, color: Color(0xFF7C3AED), size: 18),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Recent Activity",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(Icons.inbox_outlined, size: 28, color: Color(0xFF94A3B8)),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "No attendance recorded today.",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "Your check-in and check-out will appear here.",
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String label) {
    final isSelected = _selectedTab == label;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // VIEW 2: ATTENDANCE HISTORY VIEW
  // ==========================================
  Widget _buildHistoryView() {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Back Button & Filter Action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => setState(() => _showingHistory = false),
                        icon: const Icon(Icons.chevron_left_rounded, size: 30, color: Color(0xFF0F172A)),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Attendance History",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            "View your past attendance records",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.filter_list_rounded, size: 16, color: Color(0xFF2563EB)),
                        SizedBox(width: 4),
                        Text(
                          "Filter",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Calendar Card
              _buildCalendarCard(),
              const SizedBox(height: 16),

              // Timeline Record 1: 17 September 2026
              _buildAttendanceTimelineCard(
                date: "17 September 2026",
                statusText: "Present",
                statusBg: const Color(0xFFDCFCE7),
                statusColor: const Color(0xFF059669),
                checkInTime: "08:58 AM",
                checkInTag: "On Time",
                checkInTagBg: const Color(0xFFDCFCE7),
                checkInTagColor: const Color(0xFF059669),
                checkInLocation: "Head Office\nHouse 12, Road 7, Dhanmondi, Dhaka",
                checkOutTime: "06:12 PM",
                checkOutTag: "Late (12m)",
                checkOutTagBg: const Color(0xFFFEE2E2),
                checkOutTagColor: const Color(0xFFDC2626),
                checkOutLocation: "Head Office\nHouse 12, Road 7, Dhanmondi, Dhaka",
                totalHours: "9h 14m",
                scheduledHours: "Scheduled: 8h 0m",
              ),
              const SizedBox(height: 14),

              // Timeline Record 2: 16 September 2026
              _buildAttendanceTimelineCard(
                date: "16 September 2026",
                statusText: "Half Day",
                statusBg: const Color(0xFFFEF3C7),
                statusColor: const Color(0xFFD97706),
                checkInTime: "09:15 AM",
                checkInTag: "On Time",
                checkInTagBg: const Color(0xFFDCFCE7),
                checkInTagColor: const Color(0xFF059669),
                checkInLocation: "Head Office\nHouse 12, Road 7, Dhanmondi, Dhaka",
                checkOutTime: "01:35 PM",
                checkOutTag: "Early Leave",
                checkOutTagBg: const Color(0xFFFEE2E2),
                checkOutTagColor: const Color(0xFFDC2626),
                checkOutLocation: "Head Office\nHouse 12, Road 7, Dhanmondi, Dhaka",
                totalHours: "4h 20m",
                scheduledHours: "Scheduled: 8h 0m",
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Calendar Widget with Dots and Legend
  Widget _buildCalendarCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          // Month Header: < September 2026 >
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded, size: 22),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const Text(
                "September 2026",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded, size: 22),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Days of Week Header
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Sun", style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
              Text("Mon", style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
              Text("Tue", style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
              Text("Wed", style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
              Text("Thu", style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
              Text("Fri", style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
              Text("Sat", style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),

          // Calendar Days Grid
          _buildCalendarGrid(),
          const SizedBox(height: 14),

          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),

          // Legend at bottom: Present (Green) | Absent (Red) | Half Day (Orange) | Leave (Grey)
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _CalendarLegend(color: Color(0xFF059669), label: "Present"),
              _CalendarLegend(color: Color(0xFFDC2626), label: "Absent"),
              _CalendarLegend(color: Color(0xFFD97706), label: "Half Day"),
              _CalendarLegend(color: Color(0xFF64748B), label: "Leave"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    // 5 Weeks of Calendar Days
    final weeks = [
      [
        {'day': 31, 'isCurrent': false, 'dot': null},
        {'day': 1, 'isCurrent': true, 'dot': Color(0xFF059669)},
        {'day': 2, 'isCurrent': true, 'dot': null},
        {'day': 3, 'isCurrent': true, 'dot': Color(0xFF059669)},
        {'day': 4, 'isCurrent': true, 'dot': Color(0xFF059669)},
        {'day': 5, 'isCurrent': true, 'dot': Color(0xFF059669)},
        {'day': 6, 'isCurrent': true, 'dot': Color(0xFFDC2626)},
      ],
      [
        {'day': 7, 'isCurrent': true, 'dot': null},
        {'day': 8, 'isCurrent': true, 'dot': Color(0xFFDC2626)},
        {'day': 9, 'isCurrent': true, 'dot': null},
        {'day': 10, 'isCurrent': true, 'dot': Color(0xFFD97706)},
        {'day': 11, 'isCurrent': true, 'dot': null},
        {'day': 12, 'isCurrent': true, 'dot': Color(0xFF64748B)},
        {'day': 13, 'isCurrent': true, 'dot': Color(0xFFDC2626)},
      ],
      [
        {'day': 14, 'isCurrent': true, 'dot': Color(0xFF64748B)},
        {'day': 15, 'isCurrent': true, 'dot': Color(0xFF64748B)},
        {'day': 16, 'isCurrent': true, 'dot': Color(0xFFDC2626)},
        {'day': 17, 'isCurrent': true, 'dot': null, 'isSelected': true},
        {'day': 18, 'isCurrent': true, 'dot': Color(0xFFDC2626)},
        {'day': 19, 'isCurrent': true, 'dot': Color(0xFFDC2626)},
        {'day': 20, 'isCurrent': true, 'dot': Color(0xFFDC2626)},
      ],
      [
        {'day': 21, 'isCurrent': true, 'dot': Color(0xFF059669)},
        {'day': 22, 'isCurrent': true, 'dot': Color(0xFFD97706)},
        {'day': 23, 'isCurrent': true, 'dot': Color(0xFFDC2626)},
        {'day': 24, 'isCurrent': true, 'dot': null},
        {'day': 25, 'isCurrent': true, 'dot': null},
        {'day': 26, 'isCurrent': true, 'dot': null},
        {'day': 27, 'isCurrent': true, 'dot': null},
      ],
      [
        {'day': 28, 'isCurrent': true, 'dot': Color(0xFFD97706)},
        {'day': 29, 'isCurrent': true, 'dot': Color(0xFFD97706)},
        {'day': 30, 'isCurrent': true, 'dot': null},
        {'day': 1, 'isCurrent': false, 'dot': null},
        {'day': 2, 'isCurrent': false, 'dot': null},
        {'day': 3, 'isCurrent': false, 'dot': null},
        {'day': 4, 'isCurrent': false, 'dot': null},
      ],
    ];

    return Column(
      children: weeks.map((week) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: week.map((d) {
              final isCurrent = d['isCurrent'] as bool;
              final isSelected = d['isSelected'] == true;
              final dot = d['dot'] as Color?;
              final day = d['day'] as int;

              return InkWell(
                onTap: () => setState(() => _selectedCalendarDay = day),
                child: SizedBox(
                  width: 32,
                  child: Column(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            "$day",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : isCurrent
                                      ? const Color(0xFF0F172A)
                                      : const Color(0xFFCBD5E1),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? Colors.transparent : (dot ?? Colors.transparent),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  // Attendance Timeline Item
  Widget _buildAttendanceTimelineCard({
    required String date,
    required String statusText,
    required Color statusBg,
    required Color statusColor,
    required String checkInTime,
    required String checkInTag,
    required Color checkInTagBg,
    required Color checkInTagColor,
    required String checkInLocation,
    required String checkOutTime,
    required String checkOutTag,
    required Color checkOutTagBg,
    required Color checkOutTagColor,
    required String checkOutLocation,
    required String totalHours,
    required String scheduledHours,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Date + Status Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Vertical Timeline
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline vertical rail
              Column(
                children: [
                  const SizedBox(height: 4),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFF059669),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 48,
                    color: const Color(0xFFE2E8F0),
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // Timeline Content
              Expanded(
                child: Column(
                  children: [
                    // Check In Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Check In",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              checkInTime,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: checkInTagBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            checkInTag,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: checkInTagColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            checkInLocation,
                            style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), height: 1.2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Check Out Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Check Out",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              checkOutTime,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: checkOutTagBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            checkOutTag,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: checkOutTagColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            checkOutLocation,
                            style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), height: 1.2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),

          // Total Working Hours Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.access_time_rounded, size: 16, color: Color(0xFF2563EB)),
                  SizedBox(width: 6),
                  Text(
                    "Total Working Hours",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    totalHours,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                  ),
                  Text(
                    scheduledHours,
                    style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Legend Dot Row Helper
class _CalendarLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _CalendarLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

// Stylized Geofence Map Area Custom Painter
class _GeofenceMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Map base background
    final bgPaint = Paint()..color = const Color(0xFFF1F5F9);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Subtle Map Roads / Grid Lines
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.3);
    path.lineTo(size.width, size.height * 0.4);

    path.moveTo(size.width * 0.3, 0);
    path.lineTo(size.width * 0.7, size.height);

    path.moveTo(0, size.height * 0.8);
    path.lineTo(size.width, size.height * 0.7);
    canvas.drawPath(path, roadPaint);

    // Translucent Green Geofence Radius
    final center = Offset(size.width * 0.5, size.height * 0.5);
    final geofenceRadius = size.height * 0.38;

    final geofenceFill = Paint()
      ..color = const Color(0xFF3B82F6).withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, geofenceRadius, geofenceFill);

    final geofenceBorder = Paint()
      ..color = const Color(0xFF3B82F6).withValues(alpha: 0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, geofenceRadius, geofenceBorder);

    // Pulsing Outer Radar Circle
    final radarPaint = Paint()
      ..color = const Color(0xFF2563EB).withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 14, radarPaint);

    // Blue Center Pin
    final pinPaint = Paint()..color = const Color(0xFF2563EB);
    canvas.drawCircle(center, 6, pinPaint);

    final pinInnerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, 2.5, pinInnerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
