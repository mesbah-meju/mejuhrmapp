import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:auth_ui_app/common/widgets/app_page_header.dart';
import 'package:auth_ui_app/services/auth_service.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class DevicesSessionsScreen extends StatefulWidget {
  const DevicesSessionsScreen({super.key});

  @override
  State<DevicesSessionsScreen> createState() => _DevicesSessionsScreenState();
}

class _DevicesSessionsScreenState extends State<DevicesSessionsScreen> {
  final List<Map<String, dynamic>> _devices = [
    {
      'id': 'DEV-01',
      'name': 'Chrome Web Browser',
      'platform': 'Web Browser',
      'ip': '192.168.1.45',
      'lastActive': 'Active Now',
      'isCurrent': true,
    },
    {
      'id': 'DEV-02',
      'name': 'Samsung Galaxy S23',
      'platform': 'Android Mobile App',
      'ip': '103.145.78.12',
      'lastActive': '2 hours ago',
      'isCurrent': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.getCurrentUser();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            AppPageHeader(
              title: "Devices & Sessions",
              onBack: () => Get.back(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Header
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Row(
                children: [
                  const Icon(Iconsax.shield_tick, color: Color(0xFF2563EB), size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Device Security & Biometrics",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Signed in as ${user?.email ?? 'User'}. You can revoke unrecognized sessions.",
                          style: const TextStyle(fontSize: 11, color: Color(0xFF3B82F6)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "ACTIVE SESSIONS",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.6),
            ),
            const SizedBox(height: 10),

            ..._devices.map((device) => _buildDeviceCard(device)),

            const SizedBox(height: 24),

            // Revoke All Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFDC2626),
                  side: const BorderSide(color: Color(0xFFFCA5A5)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Iconsax.logout, size: 18),
                label: const Text("Log Out All Other Devices", style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  setState(() {
                    _devices.removeWhere((d) => d['isCurrent'] != true);
                  });
                  THelperFunctions.showSnackBar("All other active sessions have been revoked.");
                },
              ),
            ),
          ],
        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceCard(Map<String, dynamic> device) {
    final isCurrent = device['isCurrent'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrent ? const Color(0xFF93C5FD) : const Color(0xFFE2E8F0),
        ),
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
            decoration: BoxDecoration(
              color: isCurrent ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              device['platform'].toString().contains('Web') ? Iconsax.monitor : Iconsax.mobile,
              color: isCurrent ? const Color(0xFF2563EB) : const Color(0xFF64748B),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      device['name'],
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    if (isCurrent) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text("This Device", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  "${device['platform']} • IP: ${device['ip']}",
                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
                Text(
                  "Last active: ${device['lastActive']}",
                  style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
          ),
          if (!isCurrent)
            IconButton(
              icon: const Icon(Iconsax.trash, size: 18, color: Color(0xFFDC2626)),
              tooltip: "Revoke Session",
              onPressed: () {
                setState(() {
                  _devices.remove(device);
                });
                THelperFunctions.showSnackBar("Session revoked successfully.");
              },
            ),
        ],
      ),
    );
  }
}
