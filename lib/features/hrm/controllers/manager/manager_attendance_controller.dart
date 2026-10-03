import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:auth_ui_app/features/hrm/models/manager_models.dart';
import 'package:auth_ui_app/services/connectivity_service.dart';
import 'package:auth_ui_app/services/hrm_api_service.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class ManagerAttendanceController extends GetxController {
  static ManagerAttendanceController get instance => Get.isRegistered<ManagerAttendanceController>()
      ? Get.find<ManagerAttendanceController>()
      : Get.put(ManagerAttendanceController());

  final HrmApiService _apiService = HrmApiService.instance;

  // Active Tab Index: 0 = Overview, 1 = Attendance Log, 2 = Analytics Report
  final activeTabIndex = 0.obs;

  // 1. Overview State
  final isLoadingOverview = false.obs;
  final overview = Rx<ManagerAttendanceOverviewResponse?>(null);

  // 2. Attendance Log & Paginated Records State
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final attendances = <ManagerAttendanceModel>[].obs;
  final pagination = Rx<ManagerAttendancePaginationModel>(ManagerAttendancePaginationModel());
  final currentPage = 1.obs;

  final selectedDate = Rx<DateTime>(DateTime.now());
  final selectedBranchId = Rxn<int>();
  final selectedDepartmentId = Rxn<int>();
  final selectedDesignationId = Rxn<int>();
  final selectedStatus = 'all'.obs; // 'all', 'present', 'absent', 'half day'
  final searchQuery = ''.obs;

  // 3. Analytics Report State
  final isLoadingReport = false.obs;
  final reportData = Rx<ManagerAttendanceReportResponse?>(null);
  final reportMonth = DateTime.now().month.obs;
  final reportYear = DateTime.now().year.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOverview();
    fetchAttendances();
    fetchReport();
  }

  String get formattedDate => DateFormat('yyyy-MM-dd').format(selectedDate.value);

  // =========================================================================
  // 1. LIVE TODAY TEAM OVERVIEW (2.1)
  // =========================================================================
  Future<void> fetchOverview() async {
    isLoadingOverview.value = true;
    try {
      final res = await _apiService.getManagerAttendanceOverview(
        date: formattedDate,
        branchId: selectedBranchId.value,
        departmentId: selectedDepartmentId.value,
      );

      if (res.isSuccess && res.data != null) {
        overview.value = res.data;
      }
    } catch (e) {
      debugPrint("Error fetching manager overview: $e");
    } finally {
      isLoadingOverview.value = false;
    }
  }

  // =========================================================================
  // 2. FILTERABLE ATTENDANCE LIST (2.2)
  // =========================================================================
  Future<void> fetchAttendances({int page = 1}) async {
    isLoading.value = true;
    currentPage.value = page;
    try {
      final res = await _apiService.getManagerAttendanceList(
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        date: formattedDate,
        branchId: selectedBranchId.value,
        departmentId: selectedDepartmentId.value,
        designationId: selectedDesignationId.value,
        status: selectedStatus.value == 'all' ? null : selectedStatus.value,
        page: page,
        perPage: 20,
      );

      if (res.isSuccess && res.data != null) {
        attendances.assignAll(res.data!.items);
        pagination.value = res.data!.pagination;
      }
    } catch (e) {
      debugPrint("Error fetching manager attendances: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateDate(DateTime date) {
    selectedDate.value = date;
    fetchOverview();
    fetchAttendances(page: 1);
  }

  void updateBranch(int? branchId) {
    selectedBranchId.value = branchId;
    fetchOverview();
    fetchAttendances(page: 1);
  }

  void updateDepartment(int? deptId) {
    selectedDepartmentId.value = deptId;
    fetchOverview();
    fetchAttendances(page: 1);
  }

  void updateStatus(String status) {
    selectedStatus.value = status;
    fetchAttendances(page: 1);
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    fetchAttendances(page: 1);
  }

  // =========================================================================
  // 3. ATTENDANCE ANALYTICS REPORT (2.3)
  // =========================================================================
  Future<void> fetchReport() async {
    isLoadingReport.value = true;
    try {
      final res = await _apiService.getManagerAttendanceReport(
        month: reportMonth.value,
        year: reportYear.value,
        branchId: selectedBranchId.value,
        departmentId: selectedDepartmentId.value,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
      );

      if (res.isSuccess && res.data != null) {
        reportData.value = res.data;
      }
    } catch (e) {
      debugPrint("Error fetching manager attendance report: $e");
    } finally {
      isLoadingReport.value = false;
    }
  }

  void updateReportMonth(int month, int year) {
    reportMonth.value = month;
    reportYear.value = year;
    fetchReport();
  }

  // =========================================================================
  // 4. MANUAL ATTENDANCE CRUD (2.4, 2.5, 2.6) - SERVER AUTHORITATIVE
  // =========================================================================

  /// 2.4 Create attendance manually (POST /api/hrm/manager/attendances)
  Future<bool> createAttendance(Map<String, dynamic> data) async {
    if (!ConnectivityService.instance.isOnline) {
      THelperFunctions.showSnackBar("Internet connection required for manager administrative operations.");
      return false;
    }

    isSubmitting.value = true;
    try {
      final res = await _apiService.createAttendanceManually(data);
      isSubmitting.value = false;

      if (res.isSuccess) {
        THelperFunctions.showSnackBar(res.message.isNotEmpty ? res.message : "Attendance logged successfully!");
        fetchOverview();
        fetchAttendances();
        return true;
      } else {
        THelperFunctions.showSnackBar(res.message.isNotEmpty ? res.message : "Failed to create attendance.");
        return false;
      }
    } catch (e) {
      isSubmitting.value = false;
      THelperFunctions.showSnackBar("An error occurred: $e");
      return false;
    }
  }

  /// 2.5 Update attendance (PUT /api/hrm/manager/attendances/{id})
  Future<bool> updateAttendance(int id, Map<String, dynamic> data) async {
    if (!ConnectivityService.instance.isOnline) {
      THelperFunctions.showSnackBar("Internet connection required for manager administrative operations.");
      return false;
    }

    isSubmitting.value = true;
    try {
      final res = await _apiService.updateAttendance(id, data);
      isSubmitting.value = false;

      if (res.isSuccess) {
        THelperFunctions.showSnackBar(res.message.isNotEmpty ? res.message : "Attendance updated successfully!");
        fetchOverview();
        fetchAttendances();
        return true;
      } else {
        THelperFunctions.showSnackBar(res.message.isNotEmpty ? res.message : "Failed to update attendance.");
        return false;
      }
    } catch (e) {
      isSubmitting.value = false;
      THelperFunctions.showSnackBar("An error occurred: $e");
      return false;
    }
  }

  /// 2.6 Delete attendance (DELETE /api/hrm/manager/attendances/{id})
  Future<bool> deleteAttendance(int id) async {
    if (!ConnectivityService.instance.isOnline) {
      THelperFunctions.showSnackBar("Internet connection required for manager administrative operations.");
      return false;
    }

    isSubmitting.value = true;
    try {
      final res = await _apiService.deleteAttendance(id);
      isSubmitting.value = false;

      if (res.isSuccess) {
        THelperFunctions.showSnackBar(res.message.isNotEmpty ? res.message : "Attendance record removed.");
        fetchOverview();
        fetchAttendances();
        return true;
      } else {
        THelperFunctions.showSnackBar(res.message.isNotEmpty ? res.message : "Failed to delete record.");
        return false;
      }
    } catch (e) {
      isSubmitting.value = false;
      THelperFunctions.showSnackBar("An error occurred: $e");
      return false;
    }
  }
}

