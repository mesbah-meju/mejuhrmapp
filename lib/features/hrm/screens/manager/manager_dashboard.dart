import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:auth_ui_app/features/hrm/screens/approvals/approvals_screen.dart';
import 'package:auth_ui_app/services/approval_service.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class ManagerDashboardScreen extends StatefulWidget {
  final VoidCallback onSwitchToStaffMode;

  const ManagerDashboardScreen({
    super.key,
    required this.onSwitchToStaffMode,
  });

  @override
  State<ManagerDashboardScreen> createState() => _ManagerDashboardScreenState();
}

class _ManagerDashboardScreenState extends State<ManagerDashboardScreen> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget activeBody;
    switch (_currentNavIndex) {
      case 2:
        activeBody = ApprovalsScreen(onBack: () => setState(() => _currentNavIndex = 0));
        break;
      case 0:
      default:
        activeBody = _buildManagerHome();
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

  Widget _buildManagerHome() {
    final pendingCount = ApprovalService.instance.getRequests().where((r) => r.status == ApprovalStatus.pending).length;

    return Column(
      children: [
        // Manager Header
        _buildManagerHeader(),

        // Scrollable Body
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Pending Approvals Alert Banner
                if (pendingCount > 0) ...[
                  InkWell(
                    onTap: () => setState(() => _currentNavIndex = 2),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Iconsax.clock, color: Color(0xFFB45309), size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$pendingCount Pending Approval Requests",
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
                                ),
                                const Text(
                                  "Manual sales & attendance corrections require review",
                                  style: TextStyle(fontSize: 11, color: Color(0xFFB45309)),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFB45309)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // 2. Team Attendance Overview
                const Text("TODAY'S TEAM ATTENDANCE", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildStatCard("Present", "18", "90%", const Color(0xFF059669))),
                    const SizedBox(width: 8),
                    Expanded(child: _buildStatCard("Late", "2", "10%", const Color(0xFFD97706))),
                    const SizedBox(width: 8),
                    Expanded(child: _buildStatCard("Absent", "0", "0%", const Color(0xFFDC2626))),
                  ],
                ),
                const SizedBox(height: 20),

                // 3. Team Sales Target
                const Text("TEAM SALES PERFORMANCE", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Monthly Target", style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                          Text("BDT 500,000", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const LinearProgressIndicator(
                        value: 0.84,
                        minHeight: 8,
                        backgroundColor: Color(0xFFE2E8F0),
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Achieved: BDT 420,000 (84%)", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                          Text("Remaining: BDT 80,000", style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 4. Team Members List
                const Text("TEAM DIRECT REPORTS (5)", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5)),
                const SizedBox(height: 8),
                _buildTeamMemberTile("Rahul Sharma", "Senior Sales Executive", "Checked In 09:03 AM", "112% Sales Target"),
                _buildTeamMemberTile("Ananya Roy", "Sales Associate", "Checked In 09:12 AM", "94% Sales Target"),
                _buildTeamMemberTile("Tanvir Ahmed", "Business Analyst", "Checked In 09:00 AM", "100% Tasks Done"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildManagerHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFFDBEAFE),
                child: Icon(Iconsax.user_octagon, color: Color(0xFF2563EB), size: 22),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text("Manager Workspace", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text("MANAGER", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ],
                  ),
                  const Text("HR & Team Performance Operations", style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                ],
              ),
            ],
          ),
          OutlinedButton(
            onPressed: widget.onSwitchToStaffMode,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: Size.zero,
            ),
            child: const Text("Switch to Staff Mode", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String sub, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          Text(sub, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }

  Widget _buildTeamMemberTile(String name, String role, String status, String metric) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              Text("$role • $status", style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(metric, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF16A34A))),
          ),
        ],
      ),
    );
  }

  Widget _buildManagerBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentNavIndex,
      onTap: (index) => setState(() => _currentNavIndex = index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF2563EB),
      unselectedItemColor: const Color(0xFF64748B),
      items: const [
        BottomNavigationBarItem(icon: Icon(Iconsax.category), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Iconsax.people), label: 'Team'),
        BottomNavigationBarItem(icon: Icon(Iconsax.verify), label: 'Approvals'),
        BottomNavigationBarItem(icon: Icon(Iconsax.task_square), label: 'Tasks'),
      ],
    );
  }
}
