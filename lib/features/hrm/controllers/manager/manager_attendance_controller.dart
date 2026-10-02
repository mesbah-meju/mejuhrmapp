import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:auth_ui_app/features/hrm/models/manager_models.dart';
import 'package:auth_ui_app/services/hrm_api_service.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class ManagerAttendanceController extends GetxController {
  static ManagerAttendanceController get instance => Get.isRegistered<ManagerAttendanceController>()
      ? Get.find<ManagerAttendanceController>()
      : Get.put(ManagerAttendanceController());

  final HrmApiService _apiService = HrmApiService.instance;

  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final attendances = <ManagerAttendanceModel>[].obs;

  final selectedDate = Rx<DateTime>(DateTime.now());
  final selectedBranchId = Rxn<int>();
  final selectedStatus = 'all'.obs; // 'all', 'present', 'late', 'absent'

  @override
  void onInit() {
    super.onInit();
    fetchAttendances();
  }

  String get formattedDate => DateFormat('yyyy-MM-dd').format(selectedDate.value);

  Future<void> fetchAttendances() async {
    isLoading.value = true;
    try {
      final res = await _apiService.getManagerAttendances(
        date: formattedDate,
        branchId: selectedBranchId.value,
        status: selectedStatus.value == 'all' ? null : selectedStatus.value,
      );

      if (res.isSuccess && res.data != null) {
        attendances.assignAll(res.data!);
      }
    } catch (e) {
      debugPrint("Error fetching manager attendances: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateDate(DateTime date) {
    selectedDate.value = date;
    fetchAttendances();
  }

  void updateBranch(int? branchId) {
    selectedBranchId.value = branchId;
    fetchAttendances();
  }

  void updateStatus(String status) {
    selectedStatus.value = status;
    fetchAttendances();
  }

  /// Create attendance manually
  Future<bool> createAttendance(Map<String, dynamic> data) async {
    isSubmitting.value = true;
    try {
      final res = await _apiService.createAttendanceManually(data);
      isSubmitting.value = false;

      if (res.isSuccess) {
        THelperFunctions.showSnackBar(res.message ?? "Attendance logged successfully!");
        fetchAttendances();
        return true;
      } else {
        THelperFunctions.showSnackBar(res.message ?? "Failed to create attendance.");
        return false;
      }
    } catch (e) {
      isSubmitting.value = false;
      THelperFunctions.showSnackBar("An error occurred: $e");
      return false;
    }
  }

  /// Update attendance
  Future<bool> updateAttendance(int id, Map<String, dynamic> data) async {
    isSubmitting.value = true;
    try {
      final res = await _apiService.updateAttendance(id, data);
      isSubmitting.value = false;

      if (res.isSuccess) {
        THelperFunctions.showSnackBar(res.message ?? "Attendance updated successfully!");
        fetchAttendances();
        return true;
      } else {
        THelperFunctions.showSnackBar(res.message ?? "Failed to update attendance.");
        return false;
      }
    } catch (e) {
      isSubmitting.value = false;
      THelperFunctions.showSnackBar("An error occurred: $e");
      return false;
    }
  }

  /// Delete attendance
  Future<bool> deleteAttendance(int id) async {
    isSubmitting.value = true;
    try {
      final res = await _apiService.deleteAttendance(id);
      isSubmitting.value = false;

      if (res.isSuccess) {
        THelperFunctions.showSnackBar(res.message ?? "Attendance record removed.");
        fetchAttendances();
        return true;
      } else {
        THelperFunctions.showSnackBar(res.message ?? "Failed to delete record.");
        return false;
      }
    } catch (e) {
      isSubmitting.value = false;
      THelperFunctions.showSnackBar("An error occurred: $e");
      return false;
    }
  }
}
