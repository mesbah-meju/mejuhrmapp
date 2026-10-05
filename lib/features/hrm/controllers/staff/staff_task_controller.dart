import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:auth_ui_app/core/repositories/tasks_repository.dart';
import 'package:auth_ui_app/features/hrm/controllers/staff/staff_attendance_controller.dart';
import 'package:auth_ui_app/features/hrm/models/task_model.dart';
import 'package:auth_ui_app/services/hrm_api_service.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class TaskController extends GetxController {
  static TaskController get instance {
    if (!Get.isRegistered<TaskController>()) {
      return Get.put(TaskController(), permanent: true);
    }
    return Get.find<TaskController>();
  }

  // Observables
  final RxBool isLoadingToday = false.obs;
  final RxBool isLoadingHistory = false.obs;
  final RxBool isLoadingReport = false.obs;
  final RxBool isTogglingTask = false.obs;
  final RxBool isCreatingAdditionalTask = false.obs;

  final Rx<TodayTasksResponse?> todayResponse = Rx<TodayTasksResponse?>(null);
  final RxList<BranchTaskModel> todayTasks = <BranchTaskModel>[].obs;
  final Rx<TaskSummaryModel?> taskSummary = Rx<TaskSummaryModel?>(null);

  final RxList<TaskHistoryItemModel> historyItems = <TaskHistoryItemModel>[].obs;
  final Rx<StaffTaskReportResponse?> staffReport = Rx<StaffTaskReportResponse?>(null);
  final RxInt selectedMonth = DateTime.now().month.obs;
  final RxInt selectedYear = DateTime.now().year.obs;
  final RxString selectedFilter = 'All'.obs; // 'All', 'Completed', 'Approved', 'Rejected'

  StreamSubscription? _tasksSubscription;

  @override
  void onInit() {
    super.onInit();
    _bindTasksStream();
    refreshAll();
  }

  @override
  void onClose() {
    _tasksSubscription?.cancel();
    super.onClose();
  }

  /// Helper to check if staff is currently actively clocked in
  bool get isActivelyClockedIn {
    final todayRes = todayResponse.value;
    final attStatus = AttendanceController.instance.todayStatus.value;

    if (todayRes != null) {
      return todayRes.isClockedIn && !todayRes.hasClockedOut && todayRes.canCompleteTasks;
    }
    if (attStatus != null) {
      final bool clockedIn = attStatus.isClockedIn || attStatus.clockIn != null;
      final bool clockedOut = attStatus.clockOut != null;
      return clockedIn && !clockedOut;
    }
    return false;
  }

  /// Helper to check if staff has clocked out for today
  bool get hasClockedOut {
    final todayRes = todayResponse.value;
    final attStatus = AttendanceController.instance.todayStatus.value;
    if (todayRes?.hasClockedOut == true) return true;
    if (attStatus?.clockOut != null) return true;
    return false;
  }

  void _bindTasksStream() {
    _tasksSubscription = TasksRepository.instance.watchTasks().listen((dbTasks) {
      if (dbTasks.isNotEmpty) {
        final active = isActivelyClockedIn;
        final models = dbTasks.map((t) {
          final bool canToggleTask = active && !t.completedByOther && t.status != 'approved';

          return BranchTaskModel(
            id: t.serverId ?? 0,
            taskName: t.taskName,
            description: t.description,
            branchId: t.branchId,
            isCompleted: t.isCompleted,
            status: t.status,
            completedByMe: t.completedByMe,
            completedByOther: t.completedByOther,
            completedBy: t.completedBy,
            completedByName: t.completedByName,
            completedAt: t.completedAt,
            notes: t.notes,
            managerComment: t.managerComment,
            approvedByName: t.approvedByName,
            approvedAt: t.approvedAt,
            canToggle: canToggleTask,
          );
        }).toList();

        todayTasks.assignAll(models);

        // Derive summary if not provided
        final completed = models.where((t) => t.isCompleted).length;
        final total = models.length;
        final pending = total - completed;
        final progress = total > 0 ? ((completed / total) * 100).round() : 0;

        taskSummary.value = TaskSummaryModel(
          totalTasks: total,
          completedTasks: completed,
          pendingTasks: pending,
          progressPercentage: progress,
        );
      }
    });
  }

  /// Refresh all data
  Future<void> refreshAll() async {
    await Future.wait([
      fetchTodayTasks(),
      fetchHistory(month: selectedMonth.value, year: selectedYear.value),
      fetchStaffReport(month: selectedMonth.value, year: selectedYear.value),
    ]);
  }

  /// 1. Fetch Today's Branch Tasks & Summary
  Future<void> fetchTodayTasks() async {
    isLoadingToday.value = true;
    try {
      final res = await HrmApiService.instance.getTodayTasks();
      if (res.isSuccess && res.data != null) {
        todayResponse.value = res.data;
        todayTasks.assignAll(res.data!.tasks);
        taskSummary.value = res.data!.summary;
      }
      await TasksRepository.instance.refreshTasks();
    } catch (_) {
    } finally {
      isLoadingToday.value = false;
    }
  }

  /// 2. Complete or Toggle Task (Strict Shift & Active Check-In Gating)
  Future<void> toggleTask(BranchTaskModel task, {String? notes}) async {
    if (isTogglingTask.value) return;

    // Strict Clock-In / Clock-Out gating: ONLY allowed during active check-in
    if (!isActivelyClockedIn) {
      final msg = hasClockedOut
          ? 'You have checked out for today. Tasks can only be completed while actively checked in.'
          : 'You must check in before you can complete daily tasks.';
      Get.snackbar(
        'Action Restricted',
        msg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFDC2626),
        colorText: Colors.white,
        icon: const Icon(Icons.lock_rounded, color: Colors.white),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
      return;
    }

    // Check business restrictions
    if (task.completedByOther) {
      Get.snackbar(
        'Task Restricted',
        'This task has already been completed today by ${task.completedByName ?? "another employee"}.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
      return;
    }

    if (task.status == 'approved') {
      Get.snackbar(
        'Task Verified',
        'This task has already been approved by management and cannot be modified.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blueAccent.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
      return;
    }

    try {
      await TasksRepository.instance.toggleTaskComplete(
        branchTaskId: task.id,
        notes: notes,
      );

      THelperFunctions.showSnackBar("Task updated! Saved locally & syncing with cloud.");
    } catch (e) {
      Get.snackbar(
        'Task Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.92),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  /// 3. Create Additional / Ad-Hoc Task
  Future<bool> createAdditionalTask({
    required String taskName,
    String? description,
    String? notes,
    bool isCompleted = true,
  }) async {
    isCreatingAdditionalTask.value = true;
    try {
      final response = await HrmApiService.instance.createAdditionalTask(
        taskName: taskName,
        description: description,
        notes: notes,
        isCompleted: isCompleted,
      );

      if (response.isSuccess && response.data != null) {
        THelperFunctions.showSnackBar("Additional task logged successfully!");
        await fetchTodayTasks();
        return true;
      } else {
        Get.snackbar(
          'Failed to Create Task',
          response.message.isNotEmpty ? response.message : 'Unable to create task.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withValues(alpha: 0.92),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.92),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return false;
    } finally {
      isCreatingAdditionalTask.value = false;
    }
  }

  /// 4. Fetch Personal Task Completion History
  Future<void> fetchHistory({int? month, int? year, String? status}) async {
    isLoadingHistory.value = true;
    try {
      final m = month ?? selectedMonth.value;
      final y = year ?? selectedYear.value;
      final stat = status ?? selectedFilter.value;
      selectedMonth.value = m;
      selectedYear.value = y;

      final response = await HrmApiService.instance.getTaskHistoryResponse(
        month: m,
        year: y,
        status: stat,
      );

      if (response.isSuccess && response.data != null) {
        historyItems.assignAll(response.data!.items);
      }
    } catch (_) {
    } finally {
      isLoadingHistory.value = false;
    }
  }

  /// 5. Fetch Staff Task Report
  Future<void> fetchStaffReport({int? month, int? year, String? startDate, String? endDate}) async {
    isLoadingReport.value = true;
    try {
      final m = month ?? selectedMonth.value;
      final y = year ?? selectedYear.value;
      final res = await HrmApiService.instance.getStaffTaskReport(
        month: m,
        year: y,
        startDate: startDate,
        endDate: endDate,
      );
      if (res.isSuccess && res.data != null) {
        staffReport.value = res.data;
      }
    } catch (_) {
    } finally {
      isLoadingReport.value = false;
    }
  }

  void changeMonth(int month, int year) {
    selectedMonth.value = month;
    selectedYear.value = year;
    fetchHistory(month: month, year: year);
    fetchStaffReport(month: month, year: year);
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    fetchHistory(status: filter);
  }

  /// Filtered list of history items
  List<TaskHistoryItemModel> get filteredHistory {
    if (selectedFilter.value == 'All') return historyItems;
    return historyItems
        .where((item) => item.status.toLowerCase() == selectedFilter.value.toLowerCase())
        .toList();
  }
}
