import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:auth_ui_app/features/authentication/screens/login/login.dart';
import 'package:auth_ui_app/features/hrm/screens/approvals/approvals_screen.dart';
import 'package:auth_ui_app/features/hrm/screens/me/devices_sessions_screen.dart';
import 'package:auth_ui_app/features/hrm/screens/notifications/notifications_screen.dart';
import 'package:auth_ui_app/features/hrm/screens/sync_center/sync_center_screen.dart';
import 'package:auth_ui_app/features/hrm/screens/timeline/timeline_screen.dart';
import 'package:auth_ui_app/services/auth_service.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class MeScreen extends StatefulWidget {
  final VoidCallback? onBackToDashboard;
  final Function(int)? onNavigateToTab;

  const MeScreen({
    super.key,
    this.onBackToDashboard,
    this.onNavigateToTab,
  });

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  // Preference States
  bool _taskReminders = true;
  bool _attendanceReminders = true;
  bool _targetUpdates = true;
  bool _payrollNotifications = true;
  bool _generalNotifications = false;

  String _selectedThemeMode = 'Light'; // 'System Default', 'Light', 'Dark'
  String _selectedLanguage = 'English';
  String _defaultStartPage = 'Dashboard';
  bool _biometricEnabled = true;

  // Profile Information State (Editable where permitted)
  String _employeeName = "Rahul Sharma";
  String _designation = "Senior Sales Executive";
  String _department = "Sales & Business Development";
  String _employeeId = "EMP-00125";
  String _branch = "Dhaka Main Office";
  String _employmentType = "Full-time Permanent";
  String _joiningDate = "15 Jan 2024";
  String _reportingManager = "Mustafizur Rahman (VP Sales)";
  String _phone = "+880 1712-345678";
  String _email = "rahul.sharma@metromobile.com";
  String _address = "House 42, Road 11, Banani, Dhaka-1213";
  String _dateOfBirth = "14 Aug 1996";
  String _gender = "Male";
  String _emergencyContactName = "Dr. Ananya Sharma";
  String _emergencyRelationship = "Spouse";
  String _emergencyPhone = "+880 1819-987654";

  @override
  void initState() {
    super.initState();
    final user = AuthService.instance.getUser();
    if (user != null && user['name'] != null && user['name'].toString().isNotEmpty) {
      _employeeName = user['name'];
    }
    if (user != null && user['email'] != null && user['email'].toString().isNotEmpty) {
      _email = user['email'];
    }
  }

  void _handleLogout() {
    Get.defaultDialog(
      title: "Confirm Logout",
      titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
      middleText: "Are you sure you want to sign out from your HRM account?",
      middleTextStyle: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
      textConfirm: "Log Out",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFEF4444),
      cancelTextColor: const Color(0xFF64748B),
      onConfirm: () async {
        await AuthService.instance.logout();
        Get.offAll(() => const LoginScreen());
      },
    );
  }

  // ==========================================
  // EDIT PROFILE DIALOG
  // ==========================================
  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _employeeName);
    final phoneController = TextEditingController(text: _phone);
    final addressController = TextEditingController(text: _address);

    Get.bottomSheet(
      Container(
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
                    "Edit Profile",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _employeeName = nameController.text.trim();
                      _phone = phoneController.text.trim();
                      _address = addressController.text.trim();
                    });
                    Get.back();
                    THelperFunctions.showSnackBar("Profile updated successfully!");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Save Changes", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  // ==========================================
  // PROFILE SUB-SHEETS (PERSONAL, EMPLOYMENT, CONTACT, EMERGENCY)
  // ==========================================
  void _showInfoSheet({
    required String title,
    required List<Map<String, String>> fields,
  }) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(22),
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
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              const Divider(height: 20, color: Color(0xFFF1F5F9)),
              const SizedBox(height: 6),
              ...fields.map((f) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          f['label'] ?? '',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          f['value'] ?? '',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // NOTIFICATIONS PREFERENCES SHEET
  // ==========================================
  void _showNotificationPreferencesSheet() {
    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            padding: const EdgeInsets.all(22),
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
                        "Notification Settings",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildToggleRow(
                    "Task Reminders",
                    "Alerts for due and upcoming tasks",
                    _taskReminders,
                    (val) {
                      setSheetState(() => _taskReminders = val);
                      setState(() => _taskReminders = val);
                    },
                  ),
                  _buildToggleRow(
                    "Attendance Reminders",
                    "Morning check-in & evening check-out notifications",
                    _attendanceReminders,
                    (val) {
                      setSheetState(() => _attendanceReminders = val);
                      setState(() => _attendanceReminders = val);
                    },
                  ),
                  _buildToggleRow(
                    "Target Updates",
                    "Sales achievements & target threshold alerts",
                    _targetUpdates,
                    (val) {
                      setSheetState(() => _targetUpdates = val);
                      setState(() => _targetUpdates = val);
                    },
                  ),
                  _buildToggleRow(
                    "Payroll Notifications",
                    "Salary disbursement and payslip release alerts",
                    _payrollNotifications,
                    (val) {
                      setSheetState(() => _payrollNotifications = val);
                      setState(() => _payrollNotifications = val);
                    },
                  ),
                  _buildToggleRow(
                    "General Company News",
                    "Broadcast messages and company announcements",
                    _generalNotifications,
                    (val) {
                      setSheetState(() => _generalNotifications = val);
                      setState(() => _generalNotifications = val);
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildToggleRow(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF2563EB),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // CHANGE PASSWORD DIALOG
  // ==========================================
  void _showChangePasswordDialog() {
    final curPass = TextEditingController();
    final newPass = TextEditingController();
    final confPass = TextEditingController();

    Get.defaultDialog(
      title: "Change Password",
      titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Column(
          children: [
            TextField(
              controller: curPass,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Current Password",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPass,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "New Password",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confPass,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Confirm New Password",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
      textConfirm: "Update Password",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF2563EB),
      onConfirm: () {
        if (newPass.text.trim().isEmpty || newPass.text != confPass.text) {
          THelperFunctions.showSnackBar("Passwords do not match or are empty.");
          return;
        }
        Get.back();
        THelperFunctions.showSnackBar("Password updated securely!");
      },
    );
  }

  // ==========================================
  // ABOUT PAGE DIALOG
  // ==========================================
  void _showAboutDialog() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(22),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.hub_rounded, color: Colors.white, size: 32),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Employee Performance & HRM",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              ),
              const Text(
                "Version 1.0.0 (Build 100)",
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Text(
                  "Unified mobile enterprise application integrating Employee Performance Tracking, Real-time Attendance & Geofencing, Daily Task Management, Continuous Sales Targets, and Payroll Management.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Color(0xFF475569), height: 1.4),
                ),
              ),
              const SizedBox(height: 16),
              // Company & Developer Info
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Column(
                  children: const [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Provided by", style: TextStyle(fontSize: 11, color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold)),
                        Text("Metro HRM Systems Ltd.", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF1E3A8A))),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Support Email", style: TextStyle(fontSize: 11, color: Color(0xFF1E3A8A))),
                        Text("support@metromobile.com", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF2563EB))),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Website", style: TextStyle(fontSize: 11, color: Color(0xFF1E3A8A))),
                        Text("https://hrm.mesbahuddin.info", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF2563EB))),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Last Updated", style: TextStyle(fontSize: 11, color: Color(0xFF1E3A8A))),
                        Text("28 Sep 2026", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF1E3A8A))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "© 2026 Metro HRM Systems. All rights reserved.",
                style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  // ==========================================
  // MAIN ME SCREEN BUILD
  // ==========================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Profile Header
              _buildProfileHeader(),
              const SizedBox(height: 14),

              // 2. My Work Summary Card
              _buildMyWorkSummary(),
              const SizedBox(height: 16),

              // 2.5 Enterprise Operations & Activity
              _buildSectionCard(
                title: "Enterprise Operations",
                icon: Icons.auto_awesome_rounded,
                iconColor: const Color(0xFF2563EB),
                items: [
                  _buildSectionItem(
                    icon: Icons.timeline_rounded,
                    iconColor: const Color(0xFF2563EB),
                    title: "Activity Timeline",
                    subtitle: "Event-based daily work history",
                    onTap: () => Get.to(() => const TimelineScreen()),
                  ),
                  _buildSectionItem(
                    icon: Icons.verified_user_outlined,
                    iconColor: const Color(0xFF059669),
                    title: "Approval Engine",
                    subtitle: "Sales, attendance & overtime requests",
                    onTap: () => Get.to(() => const ApprovalsScreen()),
                  ),
                  _buildSectionItem(
                    icon: Icons.cloud_sync_outlined,
                    iconColor: const Color(0xFFD97706),
                    title: "Sync Center",
                    subtitle: "Offline health & pending sync queue",
                    onTap: () => Get.to(() => const SyncCenterScreen()),
                  ),
                  _buildSectionItem(
                    icon: Icons.notifications_active_outlined,
                    iconColor: const Color(0xFF7C3AED),
                    title: "Notifications Hub",
                    subtitle: "Alerts, reminders & deep links",
                    onTap: () => Get.to(() => const NotificationsScreen()),
                  ),
                  _buildSectionItem(
                    icon: Icons.devices_other_rounded,
                    iconColor: const Color(0xFFDC2626),
                    title: "Devices & Sessions",
                    subtitle: "Registered devices & session revoke",
                    isLast: true,
                    onTap: () => Get.to(() => const DevicesSessionsScreen()),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 3. My Profile Section
              _buildSectionCard(
                title: "My Profile",
                icon: Icons.person_outline_rounded,
                iconColor: const Color(0xFF2563EB),
                items: [
                  _buildSectionItem(
                    icon: Icons.badge_outlined,
                    iconColor: const Color(0xFF2563EB),
                    title: "Personal Information",
                    subtitle: "Name, DOB, gender & address",
                    onTap: () => _showInfoSheet(
                      title: "Personal Information",
                      fields: [
                        {'label': 'Full Name', 'value': _employeeName},
                        {'label': 'Date of Birth', 'value': _dateOfBirth},
                        {'label': 'Gender', 'value': _gender},
                        {'label': 'Present Address', 'value': _address},
                      ],
                    ),
                  ),
                  _buildSectionItem(
                    icon: Icons.business_center_outlined,
                    iconColor: const Color(0xFF059669),
                    title: "Employment Information",
                    subtitle: "ID, department, role & manager",
                    onTap: () => _showInfoSheet(
                      title: "Employment Information",
                      fields: [
                        {'label': 'Employee ID', 'value': _employeeId},
                        {'label': 'Designation', 'value': _designation},
                        {'label': 'Department', 'value': _department},
                        {'label': 'Branch', 'value': _branch},
                        {'label': 'Joining Date', 'value': _joiningDate},
                        {'label': 'Employment Type', 'value': _employmentType},
                        {'label': 'Reporting Manager', 'value': _reportingManager},
                      ],
                    ),
                  ),
                  _buildSectionItem(
                    icon: Icons.call_outlined,
                    iconColor: const Color(0xFF7C3AED),
                    title: "Contact Information",
                    subtitle: "Phone, corporate email & address",
                    onTap: () => _showInfoSheet(
                      title: "Contact Information",
                      fields: [
                        {'label': 'Official Email', 'value': _email},
                        {'label': 'Mobile Number', 'value': _phone},
                        {'label': 'Emergency Number', 'value': _emergencyPhone},
                        {'label': 'Office Location', 'value': _branch},
                      ],
                    ),
                  ),
                  _buildSectionItem(
                    icon: Icons.contact_emergency_outlined,
                    iconColor: const Color(0xFFEF4444),
                    title: "Emergency Contact",
                    subtitle: "Designated emergency guardian",
                    isLast: true,
                    onTap: () => _showInfoSheet(
                      title: "Emergency Contact",
                      fields: [
                        {'label': 'Guardian Name', 'value': _emergencyContactName},
                        {'label': 'Relationship', 'value': _emergencyRelationship},
                        {'label': 'Contact Number', 'value': _emergencyPhone},
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 4. Preferences Section
              _buildSectionCard(
                title: "Preferences",
                icon: Icons.tune_rounded,
                iconColor: const Color(0xFF7C3AED),
                items: [
                  _buildSectionItem(
                    icon: Icons.notifications_none_rounded,
                    iconColor: const Color(0xFF2563EB),
                    title: "Notifications",
                    subtitle: "Task, attendance & target reminders",
                    onTap: _showNotificationPreferencesSheet,
                  ),
                  _buildSectionItem(
                    icon: Icons.palette_outlined,
                    iconColor: const Color(0xFF059669),
                    title: "Appearance",
                    subtitle: _selectedThemeMode,
                    onTap: () {
                      Get.defaultDialog(
                        title: "Appearance Theme",
                        content: Column(
                          children: ["System Default", "Light", "Dark"].map((theme) {
                            return RadioListTile<String>(
                              title: Text(theme, style: const TextStyle(fontWeight: FontWeight.w600)),
                              value: theme,
                              groupValue: _selectedThemeMode,
                              onChanged: (val) {
                                setState(() => _selectedThemeMode = val!);
                                Get.back();
                                THelperFunctions.showSnackBar("Theme set to $val");
                              },
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                  _buildSectionItem(
                    icon: Icons.language_rounded,
                    iconColor: const Color(0xFFD97706),
                    title: "Language",
                    subtitle: _selectedLanguage,
                    onTap: () {
                      THelperFunctions.showSnackBar("Language is set to English (Default)");
                    },
                  ),
                  _buildSectionItem(
                    icon: Icons.home_outlined,
                    iconColor: const Color(0xFF7C3AED),
                    title: "Default Start Page",
                    subtitle: _defaultStartPage,
                    isLast: true,
                    onTap: () {
                      Get.defaultDialog(
                        title: "Default Start Page",
                        content: Column(
                          children: ["Dashboard", "Tasks", "Attendance", "Targets"].map((page) {
                            return RadioListTile<String>(
                              title: Text(page, style: const TextStyle(fontWeight: FontWeight.w600)),
                              value: page,
                              groupValue: _defaultStartPage,
                              onChanged: (val) {
                                setState(() => _defaultStartPage = val!);
                                Get.back();
                                THelperFunctions.showSnackBar("Default start page set to $val");
                              },
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 5. Account & Security Section
              _buildSectionCard(
                title: "Account & Security",
                icon: Icons.shield_outlined,
                iconColor: const Color(0xFF059669),
                items: [
                  _buildSectionItem(
                    icon: Icons.lock_outline_rounded,
                    iconColor: const Color(0xFF2563EB),
                    title: "Change Password",
                    subtitle: "Update account authentication key",
                    onTap: _showChangePasswordDialog,
                  ),
                  _buildSectionItem(
                    icon: Icons.history_rounded,
                    iconColor: const Color(0xFF7C3AED),
                    title: "Login Activity",
                    subtitle: "Chrome on Windows • Dhaka, BD",
                    onTap: () {
                      _showInfoSheet(
                        title: "Recent Login Activity",
                        fields: [
                          {'label': 'Current Session', 'value': 'Chrome on Windows 11 (Active Now)'},
                          {'label': 'Location', 'value': 'Dhaka, Bangladesh (IP: 103.145.x.x)'},
                          {'label': 'Previous Login', 'value': 'Android Mobile • 27 Sep 2026, 09:15 AM'},
                        ],
                      );
                    },
                  ),
                  _buildSectionItem(
                    icon: Icons.fingerprint_rounded,
                    iconColor: const Color(0xFF059669),
                    title: "Biometric Login",
                    subtitle: _biometricEnabled ? "Enabled (Fingerprint / Face ID)" : "Disabled",
                    isLast: true,
                    trailing: Switch(
                      value: _biometricEnabled,
                      activeColor: const Color(0xFF059669),
                      onChanged: (val) => setState(() => _biometricEnabled = val),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 6. App & Support Section
              _buildSectionCard(
                title: "App & Support",
                icon: Icons.help_outline_rounded,
                iconColor: const Color(0xFFD97706),
                items: [
                  _buildSectionItem(
                    icon: Icons.support_agent_rounded,
                    iconColor: const Color(0xFF2563EB),
                    title: "Help & Support",
                    subtitle: "HR helpdesk & user guide",
                    onTap: () => THelperFunctions.showSnackBar("Support Desk: support@metromobile.com"),
                  ),
                  _buildSectionItem(
                    icon: Icons.bug_report_outlined,
                    iconColor: const Color(0xFFEF4444),
                    title: "Report a Problem",
                    subtitle: "Submit feedback or report issue",
                    onTap: () {
                      final bugCtrl = TextEditingController();
                      Get.defaultDialog(
                        title: "Report a Problem",
                        content: TextField(
                          controller: bugCtrl,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "Describe the issue or feedback...",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        textConfirm: "Submit",
                        textCancel: "Cancel",
                        confirmTextColor: Colors.white,
                        buttonColor: const Color(0xFF2563EB),
                        onConfirm: () {
                          Get.back();
                          THelperFunctions.showSnackBar("Feedback submitted to IT support!");
                        },
                      );
                    },
                  ),
                  _buildSectionItem(
                    icon: Icons.policy_outlined,
                    iconColor: const Color(0xFF64748B),
                    title: "Privacy Policy",
                    subtitle: "Enterprise data privacy practices",
                    onTap: () => THelperFunctions.showSnackBar("Enterprise compliance standards active."),
                  ),
                  _buildSectionItem(
                    icon: Icons.info_outline_rounded,
                    iconColor: const Color(0xFF2563EB),
                    title: "About",
                    subtitle: "Version 1.0.0 • Metro HRM",
                    isLast: true,
                    onTap: _showAboutDialog,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 7. Log Out Button (Prominent & Clean)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: _handleLogout,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFEF4444),
                    side: const BorderSide(color: Color(0xFFFECACA), width: 1.5),
                    backgroundColor: const Color(0xFFFFF1F2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded, size: 20, color: Color(0xFFEF4444)),
                      SizedBox(width: 8),
                      Text(
                        "Log Out",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFFEF4444)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Version Footer
              const Center(
                child: Text(
                  "Metro HRM Mobile • Version 1.0.0 (Build 100)",
                  style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // PROFILE HEADER WIDGET
  // ==========================================
  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
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
        children: [
          Row(
            children: [
              // Avatar with Online Status
              Stack(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF2563EB), width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(29),
                      child: Image.network(
                        "https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFF2563EB),
                            child: const Center(
                              child: Text(
                                "RS",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF059669),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),

              // Name & Designation Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _employeeName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _designation,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2563EB)),
                    ),
                    Text(
                      _department,
                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Edit Profile Button
              InkWell(
                onTap: _showEditProfileDialog,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 13, color: Color(0xFF2563EB)),
                      SizedBox(width: 4),
                      Text(
                        "Edit",
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),

          // Metadata Row: ID, Branch, Employment Type
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetaTag(Icons.badge_outlined, _employeeId),
              _buildMetaTag(Icons.location_on_outlined, _branch),
              _buildMetaTag(Icons.verified_user_outlined, "Permanent"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetaTag(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 13, color: const Color(0xFF64748B)),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10.5, color: Color(0xFF475569), fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // ==========================================
  // MY WORK SUMMARY CARD
  // ==========================================
  Widget _buildMyWorkSummary() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "My Work Summary",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              ),
              Text(
                "This Month",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Attendance (Tab 2)
              Expanded(
                child: _buildSummaryMetricTile(
                  icon: Icons.calendar_month_rounded,
                  iconColor: const Color(0xFF059669),
                  iconBg: const Color(0xFFDCFCE7),
                  title: "Attendance",
                  value: "20 / 22",
                  subtitle: "Days",
                  onTap: () => widget.onNavigateToTab?.call(2),
                ),
              ),
              const SizedBox(width: 8),
              // Tasks (Tab 1)
              Expanded(
                child: _buildSummaryMetricTile(
                  icon: Icons.check_circle_outline_rounded,
                  iconColor: const Color(0xFF2563EB),
                  iconBg: const Color(0xFFEFF6FF),
                  title: "Tasks",
                  value: "42 / 48",
                  subtitle: "Completed",
                  onTap: () => widget.onNavigateToTab?.call(1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // Targets (Tab 3)
              Expanded(
                child: _buildSummaryMetricTile(
                  icon: Icons.track_changes_rounded,
                  iconColor: const Color(0xFF7C3AED),
                  iconBg: const Color(0xFFFAF5FF),
                  title: "Sales Target",
                  value: "108%",
                  subtitle: "Over Achieved",
                  onTap: () => widget.onNavigateToTab?.call(3),
                ),
              ),
              const SizedBox(width: 8),
              // Payroll (Tab 4)
              Expanded(
                child: _buildSummaryMetricTile(
                  icon: Icons.account_balance_wallet_rounded,
                  iconColor: const Color(0xFFD97706),
                  iconBg: const Color(0xFFFFFBEB),
                  title: "Payroll",
                  value: "32,500",
                  subtitle: "BDT Payable",
                  onTap: () => widget.onNavigateToTab?.call(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryMetricTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String value,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 16),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                  ),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 9.5, color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, size: 14, color: Color(0xFFCBD5E1)),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // REUSABLE SECTION CARD BUILDER
  // ==========================================
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 18),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          ...items,
        ],
      ),
    );
  }

  Widget _buildSectionItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(20)) : BorderRadius.zero,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: iconColor, size: 16),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                        ),
                        Text(
                          subtitle,
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                  trailing ?? const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF94A3B8)),
                ],
              ),
            ),
          ),
        ),
        if (!isLast) const Divider(height: 1, indent: 52, color: Color(0xFFF1F5F9)),
      ],
    );
  }
}
