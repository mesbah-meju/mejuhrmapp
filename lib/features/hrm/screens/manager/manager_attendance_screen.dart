import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:auth_ui_app/services/notification_engine_service.dart';
import 'package:auth_ui_app/services/timeline_service.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class ManagerAttendanceScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const ManagerAttendanceScreen({super.key, this.onBack});

  @override
  State<ManagerAttendanceScreen> createState() => _ManagerAttendanceScreenState();
}

class _ManagerAttendanceScreenState extends State<ManagerAttendanceScreen> {
  String _selectedFilter = 'All'; // 'All', 'Checked In', 'Late', 'Absent'
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _attendanceRecords = [
    {
      'id': 'EMP-1001',
      'name': 'Rahul Sharma',
      'role': 'Senior Sales Executive',
      'avatar': 'RS',
      'checkInTime': '09:03 AM',
      'checkOutTime': '06:15 PM',
      'location': 'Head Office (Geofence Verified)',
      'workHours': '8h 42m',
      'status': 'Checked In',
      'statusColor': const Color(0xFF059669),
      'statusBg': const Color(0xFFDCFCE7),
      'isLate': false,
    },
    {
      'id': 'EMP-1002',
      'name': 'Ananya Roy',
      'role': 'Sales Associate',
      'avatar': 'AR',
      'checkInTime': '09:12 AM',
      'checkOutTime': 'Pending',
      'location': 'Showroom B (Geofence Verified)',
      'workHours': '7h 18m',
      'status': 'Late Check-In',
      'statusColor': const Color(0xFFD97706),
      'statusBg': const Color(0xFFFEF3C7),
      'isLate': true,
    },
    {
      'id': 'EMP-1003',
      'name': 'Tanvir Ahmed',
      'role': 'Business Analyst',
      'avatar': 'TA',
      'checkInTime': '09:00 AM',
      'checkOutTime': '06:00 PM',
      'location': 'Head Office (Geofence Verified)',
      'workHours': '8h 30m',
      'status': 'Checked In',
      'statusColor': const Color(0xFF059669),
      'statusBg': const Color(0xFFDCFCE7),
      'isLate': false,
    },
    {
      'id': 'EMP-1004',
      'name': 'Nusrat Jahan',
      'role': 'HR Coordinator',
      'avatar': 'NJ',
      'checkInTime': '09:25 AM',
      'checkOutTime': 'Pending',
      'location': 'Head Office (Geofence Verified)',
      'workHours': '6h 50m',
      'status': 'Late Check-In',
      'statusColor': const Color(0xFFD97706),
      'statusBg': const Color(0xFFFEF3C7),
      'isLate': true,
    },
    {
      'id': 'EMP-1005',
      'name': 'Mahmud Hasan',
      'role': 'Support Engineer',
      'avatar': 'MH',
      'checkInTime': '08:55 AM',
      'checkOutTime': 'Pending',
      'location': 'Client Site A (Field Verified)',
      'workHours': '7h 35m',
      'status': 'Checked In',
      'statusColor': const Color(0xFF059669),
      'statusBg': const Color(0xFFDCFCE7),
      'isLate': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filtered = _attendanceRecords;
    if (_selectedFilter == 'Checked In') {
      filtered = filtered.where((r) => r['status'] == 'Checked In').toList();
    } else if (_selectedFilter == 'Late') {
      filtered = filtered.where((r) => r['isLate'] == true).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((r) =>
          r['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r['role'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r['id'].toString().toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    final todayDateStr = DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
                onPressed: widget.onBack,
              )
            : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Team Attendance Report", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            Text(todayDateStr, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // KPI Overview Banner
            _buildAttendanceKpiSummary(),

            // "REMIND ALL MEMBERS TO ATTEND" PROMINENT BUTTON
            _buildRemindAllBanner(),

            // Search & Filters Bar
            _buildFiltersAndSearch(),

            // Attendance Record List
            Expanded(
              child: filtered.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return _buildAttendanceCard(filtered[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 1. ATTENDANCE KPI SUMMARY
  // ==========================================
  Widget _buildAttendanceKpiSummary() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Present On Time", style: TextStyle(fontSize: 11, color: Color(0xFF166534))),
                  SizedBox(height: 4),
                  Text("3 / 5 Staff", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF14532D))),
                  Text("60% Punctual", style: TextStyle(fontSize: 10, color: Color(0xFF16A34A))),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Late Check-In", style: TextStyle(fontSize: 11, color: Color(0xFF92400E))),
                  SizedBox(height: 4),
                  Text("2 Staff", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF78350F))),
                  Text("40% Delayed", style: TextStyle(fontSize: 10, color: Color(0xFFB45309))),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total Active", style: TextStyle(fontSize: 11, color: Color(0xFF1E40AF))),
                  SizedBox(height: 4),
                  Text("5 Members", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
                  Text("100% Checked", style: TextStyle(fontSize: 10, color: Color(0xFF2563EB))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 2. PROMINENT "REMIND ALL TO ATTEND" BUTTON BANNER
  // ==========================================
  Widget _buildRemindAllBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2563EB).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.notification_bing, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Broadcast Attendance Nudge", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text("Send instant check-in notification to team members", style: TextStyle(fontSize: 11, color: Color(0xFF93C5FD))),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: _remindAllMembersToAttend,
              icon: const Icon(Iconsax.send_2, size: 14),
              label: const Text("Broadcast Nudge", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1D4ED8),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 3. SEARCH & FILTERS
  // ==========================================
  Widget _buildFiltersAndSearch() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: "Search employee attendance...",
              hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
              prefixIcon: const Icon(Iconsax.search_normal, size: 18, color: Color(0xFF64748B)),
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildFilterChip('All', 'All (5)'),
              const SizedBox(width: 8),
              _buildFilterChip('Checked In', 'On-Time (3)'),
              const SizedBox(width: 8),
              _buildFilterChip('Late', 'Late (2)'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String val, String label) {
    final isSelected = _selectedFilter == val;
    return ChoiceChip(
      label: Text(label, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.white : const Color(0xFF475569))),
      selected: isSelected,
      selectedColor: const Color(0xFF2563EB),
      backgroundColor: const Color(0xFFF1F5F9),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (selected) {
        if (selected) setState(() => _selectedFilter = val);
      },
    );
  }

  // ==========================================
  // 4. ATTENDANCE CARD TILE
  // ==========================================
  Widget _buildAttendanceCard(Map<String, dynamic> rec) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFFDBEAFE),
                    child: Text(rec['avatar'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(rec['name'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      Text(rec['role'], style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: rec['statusBg'] as Color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(rec['status'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: rec['statusColor'] as Color)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Check-In Time", style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                  const SizedBox(height: 2),
                  Text(rec['checkInTime'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Check-Out Time", style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                  const SizedBox(height: 2),
                  Text(rec['checkOutTime'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text("Duration", style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                  const SizedBox(height: 2),
                  Text(rec['workHours'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Iconsax.location, size: 12, color: Color(0xFF059669)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  rec['location'],
                  style: const TextStyle(fontSize: 11, color: Color(0xFF059669), fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Action: Remind All Team Members to Attend
  void _remindAllMembersToAttend() {
    NotificationEngineService.instance.addNotification(
      AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        uuid: '01K-REM-ATTEND-${DateTime.now().millisecondsSinceEpoch}',
        category: 'attendance',
        title: '📢 Attendance Check-In Reminder',
        body: 'Manager reminder: Please mark your daily attendance & verify geofence location.',
        data: {'type': 'attendance_reminder'},
        deepLinkRoute: '/attendance',
        createdAt: DateTime.now(),
      ),
    );

    TimelineService.instance.logEvent(
      ActivityEvent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        uuid: '01K-EVT-REMIND-${DateTime.now().millisecondsSinceEpoch}',
        eventType: 'attendance.clock_in',
        title: 'Attendance Reminder Sent to Team',
        description: 'Manager dispatched check-in nudge notification to all 5 team members.',
        metadata: {'sent_to_count': 5},
        eventAt: DateTime.now(),
        status: 'completed',
      ),
    );

    THelperFunctions.showSnackBar("📢 Sent attendance check-in reminder push notification to all team members!");
  }

  Widget _buildEmptyState() {
    return const Center(child: Text("No attendance records found.", style: TextStyle(color: Color(0xFF64748B))));
  }
}
