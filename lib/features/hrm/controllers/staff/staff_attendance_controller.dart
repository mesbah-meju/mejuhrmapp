import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:auth_ui_app/features/hrm/models/attendance_model.dart';
import 'package:auth_ui_app/features/hrm/models/auth_response_model.dart';
import 'package:auth_ui_app/features/hrm/models/geofence_model.dart';
import 'package:auth_ui_app/services/auth_service.dart';
import 'package:auth_ui_app/services/hrm_api_service.dart';
import 'package:auth_ui_app/services/offline_storage_service.dart';
import 'package:auth_ui_app/services/sync_controller.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class AttendanceController extends GetxController {
  static AttendanceController get instance {
    if (!Get.isRegistered<AttendanceController>()) {
      return Get.put(AttendanceController(), permanent: true);
    }
    return Get.find<AttendanceController>();
  }

  // Observables
  final RxBool isLoadingToday = false.obs;
  final RxBool isLoadingHistory = false.obs;
  final RxBool isClocking = false.obs;

  final Rx<TodayAttendanceStatus?> todayStatus = Rx<TodayAttendanceStatus?>(null);
  final Rx<AttendanceSummaryModel?> historySummary = Rx<AttendanceSummaryModel?>(null);
  final RxList<AttendanceRecord> historyRecords = <AttendanceRecord>[].obs;

  final RxInt selectedMonth = DateTime.now().month.obs;
  final RxInt selectedYear = DateTime.now().year.obs;
  final RxString selectedFilter = 'All'.obs; // 'All', 'Present', 'Half Day', 'Absent', 'Overtime'

  // Geofence / Location state
  final RxDouble currentLat = 23.7808875.obs;
  final RxDouble currentLng = 90.4192723.obs;
  final RxDouble currentAccuracy = 12.0.obs;
  final RxBool isWithinGeofence = true.obs;
  final RxString geofenceStatusText = "Inside Attendance Geofence".obs;
  final RxDouble nearestDistanceMeters = 0.0.obs;
  final Rx<TenantLocationModel?> activeTenantLocation = Rx<TenantLocationModel?>(null);

  Timer? _liveClockTimer;
  final RxString liveCurrentTime = "".obs;
  final RxString liveElapsedTime = "0.00 hours".obs;

  @override
  void onInit() {
    super.onInit();
    _startLiveClock();
    _loadCachedData();
    refreshAll();
  }

  @override
  void onClose() {
    _liveClockTimer?.cancel();
    super.onClose();
  }

  void _startLiveClock() {
    _updateClockDisplay();
    _liveClockTimer = Timer.periodic(const Duration(seconds: 1), (_) => _updateClockDisplay());
  }

  void _updateClockDisplay() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    liveCurrentTime.value = "$hour:$minute:$second $period";

    // Update live elapsed time if currently clocked in
    final status = todayStatus.value;
    if (status != null && status.isClockedIn && status.clockIn != null) {
      try {
        final inParts = status.clockIn!.split(':');
        if (inParts.length >= 2) {
          final inHour = int.parse(inParts[0]);
          final inMin = int.parse(inParts[1]);
          final inSec = inParts.length > 2 ? int.parse(inParts[2]) : 0;
          final clockInDateTime = DateTime(now.year, now.month, now.day, inHour, inMin, inSec);
          final diff = now.difference(clockInDateTime);
          if (!diff.isNegative) {
            final hours = diff.inHours;
            final minutes = diff.inMinutes % 60;
            liveElapsedTime.value = "${hours}h ${minutes}m";
          }
        }
      } catch (_) {}
    }
  }

  /// Load cached data from local storage for instant offline render
  void _loadCachedData() {
    try {
      final cachedToday = OfflineStorageService.instance.getCache(OfflineStorageService.keyAttendanceCache);
      if (cachedToday is Map<String, dynamic>) {
        todayStatus.value = TodayAttendanceStatus.fromJson(cachedToday);
      }

      // Check cached tenant locations for geofence evaluation
      final locations = AuthService.instance.getTenantLocations();
      if (locations.isNotEmpty) {
        activeTenantLocation.value = locations.first;
        _evaluateLocalGeofence(locations);
      }
    } catch (_) {}
  }

  /// Evaluate local geofence distance against all tenant locations
  void _evaluateLocalGeofence(List<TenantLocationModel> locations) {
    if (locations.isEmpty) return;
    final result = GeofenceCheckResult.evaluateLocalGeofence(
      userLat: currentLat.value,
      userLng: currentLng.value,
      locations: locations,
    );

    isWithinGeofence.value = result.isInsideGeofence;
    geofenceStatusText.value = result.message;
    if (result.matchedLocation != null) {
      nearestDistanceMeters.value = result.matchedLocation!.distance;
    }
  }

  /// Refresh both Today Status and Monthly History
  Future<void> refreshAll() async {
    await Future.wait([
      fetchTodayStatus(),
      fetchHistory(month: selectedMonth.value, year: selectedYear.value),
      fetchTenantLocations(),
    ]);
  }

  /// 1. Fetch Today's Attendance Overview & Status
  Future<void> fetchTodayStatus() async {
    isLoadingToday.value = true;
    try {
      final response = await HrmApiService.instance.getTodayAttendance();
      if (response.isSuccess && response.data != null) {
        todayStatus.value = response.data;
        await OfflineStorageService.instance.saveCache(
          OfflineStorageService.keyAttendanceCache,
          response.data!.toJson(),
        );
      }
    } catch (_) {
    } finally {
      isLoadingToday.value = false;
    }
  }

  /// 2. Fetch Monthly Attendance History & Summary
  Future<void> fetchHistory({int? month, int? year, String? startDate, String? endDate}) async {
    isLoadingHistory.value = true;
    try {
      final m = month ?? selectedMonth.value;
      final y = year ?? selectedYear.value;
      selectedMonth.value = m;
      selectedYear.value = y;

      final response = await HrmApiService.instance.getAttendanceHistoryResponse(
        month: m,
        year: y,
        startDate: startDate,
        endDate: endDate,
      );

      if (response.isSuccess && response.data != null) {
        historySummary.value = response.data!.summary;
        historyRecords.assignAll(response.data!.history);
      }
    } catch (_) {
    } finally {
      isLoadingHistory.value = false;
    }
  }

  /// Fetch latest Tenant Geofence Locations
  Future<void> fetchTenantLocations() async {
    try {
      final response = await HrmApiService.instance.getTenantLocations(refresh: true);
      if (response.isSuccess && response.data != null && response.data!.isNotEmpty) {
        _evaluateLocalGeofence(response.data!);
      }
    } catch (_) {}
  }

  /// Change selected month for history view
  void changeMonth(int month, int year) {
    selectedMonth.value = month;
    selectedYear.value = year;
    fetchHistory(month: month, year: year);
  }

  /// Change history filter tab
  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  /// Get filtered attendance records
  List<AttendanceRecord> get filteredHistory {
    final list = historyRecords;
    switch (selectedFilter.value) {
      case 'Present':
        return list.where((r) => r.status.toLowerCase() == 'present').toList();
      case 'Half Day':
        return list.where((r) => r.status.toLowerCase().contains('half') || r.calculatedStatus == 'half_day').toList();
      case 'Absent':
        return list.where((r) => r.status.toLowerCase() == 'absent').toList();
      case 'Overtime':
        return list.where((r) => r.overtimeHoursNumeric > 0 || (r.overtimeHours != null && r.overtimeHours != '0.00 hours')).toList();
      default:
        return list;
    }
  }

  /// 3. Geofenced Clock In
  Future<void> clockIn() async {
    if (isClocking.value) return;

    // Check offline mode
    if (!SyncController.instance.isOnline.value) {
      await SyncController.instance.enqueueAction(
        actionType: 'attendance_checkin',
        payload: {
          'latitude': currentLat.value,
          'longitude': currentLng.value,
          'accuracy': currentAccuracy.value,
          'timestamp': DateTime.now().toIso8601String(),
        },
        userMessage: "Clock In saved offline. Will sync automatically when network is restored.",
      );
      // Optimistically update today status locally
      todayStatus.value = TodayAttendanceStatus(
        isClockedIn: true,
        canClockIn: false,
        canClockOut: true,
        date: DateTime.now().toIso8601String().split('T').first,
        clockIn: liveCurrentTime.value,
        status: 'present',
      );
      return;
    }

    isClocking.value = true;

    try {
      final response = await HrmApiService.instance.clockIn(
        latitude: currentLat.value,
        longitude: currentLng.value,
        accuracy: currentAccuracy.value,
      );

      isClocking.value = false;

      if (response.isSuccess) {
        THelperFunctions.showSnackBar(
          response.message.isNotEmpty ? response.message : "Clocked in successfully!",
        );
        // Refresh live data from backend
        await fetchTodayStatus();
        await fetchHistory();
      } else {
        // Business logic rejection handling (Outside geofence, Holiday, On-Leave, Non-working day, IP restriction)
        final msg = response.message;
        Get.snackbar(
          'Clock In Restricted',
          msg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withValues(alpha: 0.92),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
          icon: const Icon(Icons.location_off_rounded, color: Colors.white),
        );
      }
    } catch (e) {
      isClocking.value = false;
      Get.snackbar(
        'Connection Error',
        'Could not connect to attendance server. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  /// 4. Clock Out & Auto-Calculation
  Future<void> clockOut() async {
    if (isClocking.value) return;

    // Check offline mode
    if (!SyncController.instance.isOnline.value) {
      await SyncController.instance.enqueueAction(
        actionType: 'attendance_checkout',
        payload: {
          'latitude': currentLat.value,
          'longitude': currentLng.value,
          'accuracy': currentAccuracy.value,
          'timestamp': DateTime.now().toIso8601String(),
        },
        userMessage: "Clock Out saved offline. Will sync automatically when network is restored.",
      );
      // Optimistically update today status locally
      todayStatus.value = TodayAttendanceStatus(
        isClockedIn: false,
        canClockIn: true,
        canClockOut: false,
        date: DateTime.now().toIso8601String().split('T').first,
        clockOut: liveCurrentTime.value,
        status: 'present',
      );
      return;
    }

    isClocking.value = true;

    try {
      final response = await HrmApiService.instance.clockOut(
        latitude: currentLat.value,
        longitude: currentLng.value,
        accuracy: currentAccuracy.value,
      );

      isClocking.value = false;

      if (response.isSuccess) {
        final record = response.data;
        String durationMsg = record?.totalHours ?? "";
        String overtimeMsg = (record != null && record.overtimeHoursNumeric > 0)
            ? " (Overtime: ${record.overtimeHours})"
            : "";

        THelperFunctions.showSnackBar(
          "Clocked out successfully! Worked: $durationMsg$overtimeMsg",
        );
        // Refresh live status and history
        await fetchTodayStatus();
        await fetchHistory();
      } else {
        Get.snackbar(
          'Clock Out Failed',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withValues(alpha: 0.92),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      isClocking.value = false;
      Get.snackbar(
        'Connection Error',
        'Could not connect to attendance server. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  /// Toggle check in / out action based on current state
  Future<void> toggleClockInOut() async {
    final status = todayStatus.value;
    if (status != null && status.isClockedIn) {
      await clockOut();
    } else {
      await clockIn();
    }
  }
}
