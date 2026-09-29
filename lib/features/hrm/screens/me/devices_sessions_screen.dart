import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:auth_ui_app/services/device_session_service.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class DevicesSessionsScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const DevicesSessionsScreen({super.key, this.onBack});

  @override
  State<DevicesSessionsScreen> createState() => _DevicesSessionsScreenState();
}

class _DevicesSessionsScreenState extends State<DevicesSessionsScreen> {
  late List<RegisteredDevice> _devices;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  void _loadDevices() {
    setState(() {
      _devices = DeviceSessionService.instance.getActiveDevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentDevice = _devices.firstWhere((d) => d.isCurrent, orElse: () => _devices.first);
    final otherDevices = _devices.where((d) => !d.isCurrent).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF1E293B)),
          onPressed: widget.onBack ?? () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Devices & Active Sessions",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. THIS DEVICE Card
            const Text(
              "THIS DEVICE",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5),
            ),
            const SizedBox(height: 8),
            _buildDeviceCard(currentDevice, isCurrentDevice: true),
            const SizedBox(height: 24),

            // 2. OTHER DEVICES Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "OTHER DEVICES (${otherDevices.length})",
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5),
                ),
                if (otherDevices.isNotEmpty)
                  TextButton(
                    onPressed: _showRevokeAllConfirmDialog,
                    child: const Text("Log Out All Other Devices", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFDC2626))),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            if (otherDevices.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Column(
                  children: [
                    Icon(Iconsax.shield_tick, size: 36, color: Color(0xFF10B981)),
                    SizedBox(height: 8),
                    Text("No Other Active Sessions", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    SizedBox(height: 4),
                    Text("You are only logged in on this device.", style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  ],
                ),
              )
            else
              ...otherDevices.map((device) => _buildDeviceCard(device, isCurrentDevice: false)),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceCard(RegisteredDevice device, {required bool isCurrentDevice}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentDevice ? const Color(0xFF93C5FD) : const Color(0xFFE2E8F0),
          width: isCurrentDevice ? 1.5 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isCurrentDevice ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              device.platform.toLowerCase().contains('web') ? Iconsax.monitor : Iconsax.mobile,
              size: 22,
              color: isCurrentDevice ? const Color(0xFF2563EB) : const Color(0xFF64748B),
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
                      device.deviceName,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    if (isCurrentDevice) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "Active Now",
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF15803D)),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "${device.platform} • App v${device.appVersion}",
                  style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Iconsax.location, size: 12, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 4),
                    Text(
                      "${device.location} • ${device.lastSeenAt}",
                      style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (!isCurrentDevice)
            IconButton(
              icon: const Icon(Iconsax.logout_1, size: 18, color: Color(0xFFDC2626)),
              onPressed: () => _revokeSingleDevice(device),
            ),
        ],
      ),
    );
  }

  void _revokeSingleDevice(RegisteredDevice device) {
    Get.defaultDialog(
      title: "Log Out Device",
      middleText: "Are you sure you want to log out session on ${device.deviceName}?",
      textConfirm: "Log Out",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFDC2626),
      onConfirm: () async {
        Get.back();
        await DeviceSessionService.instance.revokeSession(device.id);
        _loadDevices();
        THelperFunctions.showSnackBar("Session revoked for ${device.deviceName}");
      },
    );
  }

  void _showRevokeAllConfirmDialog() {
    Get.defaultDialog(
      title: "Log Out All Other Devices",
      middleText: "This will revoke all active sessions except your current device.",
      textConfirm: "Log Out All",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFDC2626),
      onConfirm: () async {
        Get.back();
        await DeviceSessionService.instance.revokeAllOtherSessions();
        _loadDevices();
        THelperFunctions.showSnackBar("All other sessions logged out successfully.");
      },
    );
  }
}
