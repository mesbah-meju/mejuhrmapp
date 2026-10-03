import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:auth_ui_app/features/hrm/models/manager_models.dart';
import 'package:auth_ui_app/features/hrm/models/task_model.dart';
import 'package:auth_ui_app/services/hrm_api_service.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class ManagerTaskController extends GetxController {
  static ManagerTaskController get instance {
    if (!Get.isRegistered<ManagerTaskController>()) {
      return Get.put(ManagerTaskController(), permanent: true);
    }
    return Get.find<ManagerTaskController>();
  }

  // Observables
  final RxBool isLoading = false.obs;
  final RxBool isReviewing = false.obs;
  final RxBool isLoadingBranchTasks = false.obs;
  final RxBool isLoadingReport = false.obs;
  final RxBool isSubmittingTask = false.obs;

  final RxList<ManagerTaskCompletionModel> completions = <ManagerTaskCompletionModel>[].obs;
  final RxList<ManagerBranchTaskCrudModel> branchTasks = <ManagerBranchTaskCrudModel>[].obs;
  final Rx<ManagerTaskReportResponse?> report = Rx<ManagerTaskReportResponse?>(null);
  final RxString selectedStatusFilter = 'All'.obs; // 'All', 'completed', 'approved', 'rejected'
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxInt selectedReportMonth = DateTime.now().month.obs;
  final RxInt selectedReportYear = DateTime.now().year.obs;

  final RxInt pendingCount = 0.obs;
  final RxInt approvedCount = 0.obs;
  final RxInt rejectedCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCompletions();
    fetchBranchTasks();
    fetchReport();
  }

  /// 0. Fetch Manager Task Report & Analytics
  Future<void> fetchReport({int? month, int? year, int? branchId, int? departmentId, int? employeeId}) async {
    isLoadingReport.value = true;
    try {
      final m = month ?? selectedReportMonth.value;
      final y = year ?? selectedReportYear.value;
      selectedReportMonth.value = m;
      selectedReportYear.value = y;

      final res = await HrmApiService.instance.managerGetTasksReport(
        month: m,
        year: y,
        branchId: branchId,
        departmentId: departmentId,
        employeeId: employeeId,
      );
      if (res.isSuccess && res.data != null) {
        report.value = res.data;
      }
    } catch (_) {
    } finally {
      isLoadingReport.value = false;
    }
  }

  /// 1. Fetch Task Completions for Manager Review
  Future<void> fetchCompletions({String? date, String? status}) async {
    isLoading.value = true;
    try {
      final dateStr = date ?? selectedDate.value?.toIso8601String().split('T').first;
      final stat = status ?? (selectedStatusFilter.value != 'All' ? selectedStatusFilter.value.toLowerCase() : null);

      final response = await HrmApiService.instance.getManagerTaskCompletions(
        date: dateStr,
        status: stat,
      );

      if (response.isSuccess && response.data != null) {
        completions.assignAll(response.data!.items);
        _updateSummaryCounts();
      }
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  void _updateSummaryCounts() {
    pendingCount.value = completions.where((c) => c.status == 'completed' || c.status == 'pending').length;
    approvedCount.value = completions.where((c) => c.status == 'approved').length;
    rejectedCount.value = completions.where((c) => c.status == 'rejected').length;
  }

  void setStatusFilter(String filter) {
    selectedStatusFilter.value = filter;
    fetchCompletions(status: filter != 'All' ? filter.toLowerCase() : null);
  }

  void setDateFilter(DateTime? date) {
    selectedDate.value = date;
    fetchCompletions(date: date?.toIso8601String().split('T').first);
  }

  /// 2. Manager Approve Task
  Future<void> approveTask(int completionId, {String? comment}) async {
    await _reviewTaskAction(completionId, 'approved', comment);
  }

  /// 3. Manager Reject Task
  Future<void> rejectTask(int completionId, {String? comment}) async {
    await _reviewTaskAction(completionId, 'rejected', comment);
  }

  Future<void> _reviewTaskAction(int completionId, String status, String? comment) async {
    if (isReviewing.value) return;

    isReviewing.value = true;
    try {
      final response = await HrmApiService.instance.reviewManagerTask(
        completionId: completionId,
        status: status,
        comment: comment,
      );

      isReviewing.value = false;

      if (response.isSuccess) {
        THelperFunctions.showSnackBar(
          response.message.isNotEmpty
              ? response.message
              : (status == 'approved' ? "Task completion approved!" : "Task marked as rejected."),
        );
        await fetchCompletions();
      } else {
        Get.snackbar(
          'Review Action Failed',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      isReviewing.value = false;
      Get.snackbar(
        'Connection Error',
        'Could not connect to task review server. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  /// Filtered list based on selected tab
  List<ManagerTaskCompletionModel> get filteredCompletions {
    if (selectedStatusFilter.value == 'All') return completions;
    return completions
        .where((c) => c.status.toLowerCase() == selectedStatusFilter.value.toLowerCase())
        .toList();
  }

  // =========================================================================
  // Branch Tasks CRUD Methods
  // =========================================================================

  Future<void> fetchBranchTasks({int? branchId}) async {
    isLoadingBranchTasks.value = true;
    try {
      final res = await HrmApiService.instance.getManagerBranchTasks(branchId: branchId);
      if (res.isSuccess && res.data != null) {
        branchTasks.assignAll(res.data!);
      }
    } catch (e) {
      debugPrint("Error fetching branch tasks: $e");
    } finally {
      isLoadingBranchTasks.value = false;
    }
  }

  Future<bool> createBranchTask(Map<String, dynamic> data) async {
    isSubmittingTask.value = true;
    try {
      final res = await HrmApiService.instance.createManagerBranchTask(data);
      isSubmittingTask.value = false;

      if (res.isSuccess) {
        THelperFunctions.showSnackBar(res.message.isNotEmpty ? res.message : "Task created successfully!");
        fetchBranchTasks();
        return true;
      } else {
        THelperFunctions.showSnackBar(res.message.isNotEmpty ? res.message : "Failed to create task.");
        return false;
      }
    } catch (e) {
      isSubmittingTask.value = false;
      THelperFunctions.showSnackBar("An error occurred: $e");
      return false;
    }
  }

  Future<bool> updateBranchTask(int id, Map<String, dynamic> data) async {
    isSubmittingTask.value = true;
    try {
      final res = await HrmApiService.instance.updateManagerBranchTask(id, data);
      isSubmittingTask.value = false;

      if (res.isSuccess) {
        THelperFunctions.showSnackBar(res.message.isNotEmpty ? res.message : "Task updated successfully!");
        fetchBranchTasks();
        return true;
      } else {
        THelperFunctions.showSnackBar(res.message.isNotEmpty ? res.message : "Failed to update task.");
        return false;
      }
    } catch (e) {
      isSubmittingTask.value = false;
      THelperFunctions.showSnackBar("An error occurred: $e");
      return false;
    }
  }

  Future<bool> deleteBranchTask(int id) async {
    isSubmittingTask.value = true;
    try {
      final res = await HrmApiService.instance.deleteManagerBranchTask(id);
      isSubmittingTask.value = false;

      if (res.isSuccess) {
        THelperFunctions.showSnackBar(res.message.isNotEmpty ? res.message : "Task deleted.");
        fetchBranchTasks();
        return true;
      } else {
        THelperFunctions.showSnackBar(res.message.isNotEmpty ? res.message : "Failed to delete task.");
        return false;
      }
    } catch (e) {
      isSubmittingTask.value = false;
      THelperFunctions.showSnackBar("An error occurred: $e");
      return false;
    }
  }
}
