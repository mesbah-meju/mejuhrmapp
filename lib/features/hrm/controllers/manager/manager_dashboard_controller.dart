import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:auth_ui_app/services/hrm_api_service.dart';

class ManagerDashboardController extends GetxController {
  static ManagerDashboardController get instance => Get.isRegistered<ManagerDashboardController>()
      ? Get.find<ManagerDashboardController>()
      : Get.put(ManagerDashboardController());

  final HrmApiService _apiService = HrmApiService.instance;

  final isLoading = false.obs;

  // Badge Counts
  final pendingLeavesCount = 0.obs;
  final pendingTasksCount = 0.obs;
  final pendingSalesLogsCount = 0.obs;

  // Summary Metrics
  final totalActiveEmployees = 0.obs;
  final presentTodayCount = 0.obs;
  final lateTodayCount = 0.obs;
  final totalSalesAchieved = 0.0.obs;
  final totalSalesTarget = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    refreshAllDashboardData();
  }

  int get totalPendingApprovals =>
      pendingLeavesCount.value + pendingTasksCount.value + pendingSalesLogsCount.value;

  Future<void> refreshAllDashboardData() async {
    isLoading.value = true;
    await Future.wait([
      _fetchPendingLeavesBadge(),
      _fetchPendingTasksBadge(),
      _fetchPendingSalesLogsBadge(),
      _fetchTeamAttendanceSummary(),
      _fetchEmployeesSummary(),
    ]);
    isLoading.value = false;
  }

  Future<void> _fetchPendingLeavesBadge() async {
    try {
      final res = await _apiService.getManagerLeaves(status: 'pending');
      if (res.isSuccess && res.data != null) {
        pendingLeavesCount.value = res.data!.length;
      }
    } catch (e) {
      debugPrint("Error fetching pending leaves badge: $e");
    }
  }

  Future<void> _fetchPendingTasksBadge() async {
    try {
      final res = await _apiService.getManagerTaskCompletions(status: 'completed');
      if (res.isSuccess && res.data != null) {
        pendingTasksCount.value = res.data!.items.length;
      }
    } catch (e) {
      debugPrint("Error fetching pending tasks badge: $e");
    }
  }

  Future<void> _fetchPendingSalesLogsBadge() async {
    try {
      final res = await _apiService.managerGetSalesLogs(status: 'pending');
      if (res.isSuccess && res.data != null) {
        pendingSalesLogsCount.value = res.data!.length;
      }
    } catch (e) {
      debugPrint("Error fetching pending sales logs badge: $e");
    }
  }

  Future<void> _fetchTeamAttendanceSummary() async {
    try {
      final res = await _apiService.getManagerAttendances();
      if (res.isSuccess && res.data != null) {
        presentTodayCount.value = res.data!.where((a) => a.status.toLowerCase() == 'present').length;
        lateTodayCount.value = res.data!.where((a) => a.isLate).length;
      }
    } catch (e) {
      debugPrint("Error fetching attendance summary: $e");
    }
  }

  Future<void> _fetchEmployeesSummary() async {
    try {
      final res = await _apiService.getManagerEmployees(status: 'active');
      if (res.isSuccess && res.data != null) {
        totalActiveEmployees.value = res.data!.pagination?.total ?? res.data!.employees.length;
      }
    } catch (e) {
      debugPrint("Error fetching employees summary: $e");
    }
  }
}
