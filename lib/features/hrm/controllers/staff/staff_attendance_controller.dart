import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:auth_ui_app/core/repositories/attendance_repository.dart';
import 'package:auth_ui_app/features/hrm/models/attendance_model.dart';
import 'package:auth_ui_app/features/hrm/models/auth_response_model.dart';
import 'package:auth_ui_app/features/hrm/models/geofence_model.dart';
import 'package:auth_ui_app/services/hrm_api_service.dart';
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
  final RxBool isLoadingReport = false.obs;
  final RxBool isClocking = false.obs;

  final Rx<TodayAttendanceStatus?> todayStatus = Rx<TodayAttendanceStatus?>(null);
  final Rx<AttendanceSummaryModel?> historySummary = Rx<AttendanceSummaryModel?>(null);
  final RxList<AttendanceRecord> historyRecords = <AttendanceRecord>[].obs;
  final Rx<StaffAttendanceReportResponse?> staffReport = Rx<StaffAttendanceReportResponse?>(null);

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
  StreamSubscription? _todaySubscription;
  StreamSubscription? _historySubscription;

  final RxString liveCurrentTime = "".obs;
  final RxString liveElapsedTime = "0.00 hours".obs;

  @override
  void onInit() {
    super.onInit();
    _startLiveClock();
    _bindDatabaseStreams();
    refreshAll();
  }

  @override
  void onClose() {
    _liveClockTimer?.cancel();
    _todaySubscription?.cancel();
    _historySubscription?.cancel();
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

  /// Bind reactive Drift SQLite Streams
  void _bindDatabaseStreams() {
    // 1. Today Status Stream
    _todaySubscription = AttendanceRepository.instance.watchTodayStatus().listen((data) {
      if (data != null) {
        AttendanceLocationDetail? checkInLoc;
        if (data.checkInLocationJson != null) {
          try {
            checkInLoc = AttendanceLocationDetail.fromJson(
              jsonDecode(data.checkInLocationJson!) as Map<String, dynamic>,
            );
          } catch (_) {}
        }

        AttendanceBranchDetail? checkInBr;
        if (data.checkInBranchJson != null) {
          try {
            checkInBr = AttendanceBranchDetail.fromJson(
              jsonDecode(data.checkInBranchJson!) as Map<String, dynamic>,
            );
          } catch (_) {}
        }

        AttendanceShiftDetail? shift;
        if (data.shiftJson != null) {
          try {
            shift = AttendanceShiftDetail.fromJson(
              jsonDecode(data.shiftJson!) as Map<String, dynamic>,
            );
          } catch (_) {}
        }

        Map<String, String>? workingDays;
        if (data.workingDaysMapJson != null) {
          try {
            workingDays = Map<String, String>.from(
              jsonDecode(data.workingDaysMapJson!) as Map,
            );
          } catch (_) {}
        }

        todayStatus.value = TodayAttendanceStatus(
          isClockedIn: data.isClockedIn,
          canClockIn: data.canClockIn,
          canClockOut: data.canClockOut,
          attendanceId: data.attendanceId ?? 0,
          date: data.date,
          clockIn: data.clockIn,
          clockOut: data.clockOut,
          totalHours: data.totalHours,
          totalHoursNumeric: data.totalHoursNumeric,
          breakHours: data.breakHours,
          overtimeHours: data.overtimeHours,
          status: data.status,
          isWorkingDay: data.isWorkingDay,
          isHoliday: data.isHoliday,
          holidayName: data.holidayName,
          isOnLeave: data.isOnLeave,
          isHalfDayLeave: data.isHalfDayLeave,
          leaveTitle: data.leaveTitle,
          checkInLocation: checkInLoc,
          checkInBranch: checkInBr,
          shift: shift,
          workingDaysMap: workingDays ?? const {},
        );
      }
    });

    // 2. History Stream
    _bindHistoryStream();
  }

  void _bindHistoryStream() {
    _historySubscription?.cancel();
    _historySubscription = AttendanceRepository.instance
        .watchMonthlyHistory(selectedMonth.value, selectedYear.value)
        .listen((records) {
      final list = records.map((r) {
        AttendanceLocationDetail? loc;
        if (r.checkInLocationJson != null) {
          try {
            loc = AttendanceLocationDetail.fromJson(
              jsonDecode(r.checkInLocationJson!) as Map<String, dynamic>,
            );
          } catch (_) {}
        }

        return AttendanceRecord(
          id: r.serverId ?? 0,
          date: r.date,
          clockIn: r.clockIn,
          clockOut: r.clockOut,
          status: r.status,
          calculatedStatus: r.calculatedStatus,
          isLate: r.isLate,
          isEarly: r.isEarly,
          totalHours: r.totalHours,
          totalHoursNumeric: r.totalHoursNumeric,
          breakHours: r.breakHours,
          breakHoursNumeric: r.breakHoursNumeric,
          overtimeHours: r.overtimeHours,
          overtimeHoursNumeric: r.overtimeHoursNumeric,
          overtimeAmount: r.overtimeAmount,
          notes: r.notes,
          checkInLocation: loc,
        );
      }).toList();

      historyRecords.assignAll(list);
    });
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
      final res = await AttendanceRepository.instance.refreshTodayStatus();
      if (res != null) {
        todayStatus.value = res;
      }
    } catch (_) {
    } finally {
      isLoadingToday.value = false;
    }
  }

  /// 2. Fetch Monthly Attendance History
  Future<void> fetchHistory({int? month, int? year}) async {
    isLoadingHistory.value = true;
    try {
      final m = month ?? selectedMonth.value;
      final y = year ?? selectedYear.value;
      await AttendanceRepository.instance.refreshHistory(month: m, year: y);

      // Also get summary
      final summaryRes = await HrmApiService.instance.getAttendanceHistoryResponse(month: m, year: y);
      if (summaryRes.isSuccess && summaryRes.data != null) {
        historySummary.value = summaryRes.data!.summary;
      }
    } catch (_) {
    } finally {
      isLoadingHistory.value = false;
    }
  }

  /// Fetch Comprehensive Monthly Staff Attendance Report
  Future<void> fetchStaffReport({int? month, int? year}) async {
    isLoadingReport.value = true;
    try {
      final m = month ?? selectedMonth.value;
      final y = year ?? selectedYear.value;
      final response = await HrmApiService.instance.getStaffAttendanceReport(month: m, year: y);
      if (response.isSuccess && response.data != null) {
        staffReport.value = response.data;
      }
    } catch (_) {
    } finally {
      isLoadingReport.value = false;
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
    _bindHistoryStream();
    fetchHistory(month: month, year: year);
    fetchStaffReport(month: month, year: year);
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

  /// 3. Geofenced Clock In (Local-First with SQLite queue)
  Future<void> clockIn({String? notes}) async {
    if (isClocking.value) return;

    // STRICT GEOFENCE ENFORCEMENT: Block check-in when user is not in range
    if (!isWithinGeofence.value) {
      Get.snackbar(
        'Not in Range',
        'You are not in range of the office location. Check-in is strictly permitted only when in range.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFDC2626),
        colorText: Colors.white,
        icon: const Icon(Icons.location_off_rounded, color: Colors.white),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
      return;
    }

    isClocking.value = true;
    try {
      await AttendanceRepository.instance.clockIn(
        latitude: currentLat.value,
        longitude: currentLng.value,
        accuracy: currentAccuracy.value,
        notes: notes,
      );

      THelperFunctions.showSnackBar("Clock In recorded! Saved locally & syncing with cloud.");
    } catch (e) {
      Get.snackbar(
        'Clock In Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.92),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isClocking.value = false;
    }
  }

  /// 4. Clock Out (Local-First with SQLite queue)
  Future<void> clockOut({String? notes}) async {
    if (isClocking.value) return;

    // STRICT GEOFENCE ENFORCEMENT: Block check-out when user is not in range
    if (!isWithinGeofence.value) {
      Get.snackbar(
        'Not in Range',
        'You are not in range of the office location. Check-out is strictly permitted only when in range.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFDC2626),
        colorText: Colors.white,
        icon: const Icon(Icons.location_off_rounded, color: Colors.white),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
      return;
    }

    isClocking.value = true;
    try {
      await AttendanceRepository.instance.clockOut(
        latitude: currentLat.value,
        longitude: currentLng.value,
        accuracy: currentAccuracy.value,
        notes: notes,
      );

      THelperFunctions.showSnackBar("Clock Out recorded! Calculating work shift duration.");
    } catch (e) {
      Get.snackbar(
        'Clock Out Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.92),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isClocking.value = false;
    }
  }

  /// Toggle check in / out action based on current state
  Future<void> toggleClockInOut({String? notes}) async {
    final status = todayStatus.value;
    final isClockedIn = status != null && status.isClockedIn;

    // STRICT GEOFENCE ENFORCEMENT: Block both check-in and check-out when not in range
    if (!isWithinGeofence.value) {
      final action = isClockedIn ? "Check Out" : "Check In";
      Get.snackbar(
        '$action Blocked',
        'You are not in range of the office location. $action is strictly permitted only when in range.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFDC2626),
        colorText: Colors.white,
        icon: const Icon(Icons.location_off_rounded, color: Colors.white),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
      return;
    }

    if (isClockedIn) {
      await clockOut(notes: notes);
    } else {
      await clockIn(notes: notes);
    }
  }
}
