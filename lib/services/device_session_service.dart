import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

import 'package:auth_ui_app/utils/constants/api_constants.dart';

class RegisteredDevice {
  final String id;
  final String deviceName;
  final String platform;
  final String appVersion;
  final String osVersion;
  final String lastSeenAt;
  final String location;
  final bool isCurrent;
  bool isActive;

  RegisteredDevice({
    required this.id,
    required this.deviceName,
    required this.platform,
    required this.appVersion,
    required this.osVersion,
    required this.lastSeenAt,
    required this.location,
    required this.isCurrent,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'deviceName': deviceName,
        'platform': platform,
        'appVersion': appVersion,
        'osVersion': osVersion,
        'lastSeenAt': lastSeenAt,
        'location': location,
        'isCurrent': isCurrent,
        'isActive': isActive,
      };

  factory RegisteredDevice.fromJson(Map<String, dynamic> json) => RegisteredDevice(
        id: json['id'] as String,
        deviceName: json['deviceName'] as String,
        platform: json['platform'] as String,
        appVersion: json['appVersion'] as String,
        osVersion: json['osVersion'] as String,
        lastSeenAt: json['lastSeenAt'] as String,
        location: json['location'] as String? ?? 'Dhaka, BD',
        isCurrent: json['isCurrent'] as bool? ?? false,
        isActive: json['isActive'] as bool? ?? true,
      );
}

class DeviceSessionService {
  static final DeviceSessionService instance = DeviceSessionService._internal();
  DeviceSessionService._internal();

  final GetStorage _storage = GetStorage();

  /// Get or create unique client device identifier
  String getDeviceId() {
    String? deviceId = _storage.read<String>(ApiConstants.storageDeviceIdKey);
    if (deviceId == null || deviceId.isEmpty) {
      deviceId = "DEV-${DateTime.now().millisecondsSinceEpoch}-${(1000 + (DateTime.now().microsecond % 9000))}";
      _storage.write(ApiConstants.storageDeviceIdKey, deviceId);
    }
    return deviceId;
  }

  /// Get active sessions for current user
  List<RegisteredDevice> getActiveDevices() {
    final currentId = getDeviceId();
    final rawList = _storage.read<List>('cached_user_devices') ?? [];

    if (rawList.isEmpty) {
      // Default demo devices list
      return [
        RegisteredDevice(
          id: currentId,
          deviceName: kIsWeb ? 'Chrome Web App' : 'Samsung Galaxy S24',
          platform: kIsWeb ? 'Web / Chrome' : 'Android 16',
          appVersion: ApiConstants.appVersion,
          osVersion: 'Android 16',
          lastSeenAt: 'Active now',
          location: 'Dhaka, Bangladesh',
          isCurrent: true,
        ),
        RegisteredDevice(
          id: 'DEV-981240-PIXEL',
          deviceName: 'Google Pixel 9',
          platform: 'Android 15',
          appVersion: '1.4.2',
          osVersion: 'Android 15',
          lastSeenAt: 'Yesterday at 04:20 PM',
          location: 'Chittagong, Bangladesh',
          isCurrent: false,
        ),
        RegisteredDevice(
          id: 'DEV-554192-IPHONE',
          deviceName: 'iPhone 15 Pro',
          platform: 'iOS 17.5',
          appVersion: '1.4.0',
          osVersion: 'iOS 17.5',
          lastSeenAt: '3 days ago',
          location: 'Dhaka, Bangladesh',
          isCurrent: false,
        ),
      ];
    }

    return rawList
        .map((item) => RegisteredDevice.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  /// Save devices to cache
  Future<void> saveDevices(List<RegisteredDevice> devices) async {
    final list = devices.map((d) => d.toJson()).toList();
    await _storage.write('cached_user_devices', list);
  }

  /// Revoke a specific session
  Future<bool> revokeSession(String deviceId) async {
    final devices = getActiveDevices();
    final updated = devices.where((d) => d.id != deviceId).toList();
    await saveDevices(updated);
    return true;
  }

  /// Revoke all other devices except current
  Future<bool> revokeAllOtherSessions() async {
    final currentId = getDeviceId();
    final devices = getActiveDevices();
    final updated = devices.where((d) => d.id == currentId).toList();
    await saveDevices(updated);
    return true;
  }
}
