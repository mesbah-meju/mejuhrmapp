import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:auth_ui_app/features/hrm/models/task_model.dart';
import 'package:auth_ui_app/services/hrm_api_service.dart';
import 'package:auth_ui_app/services/offline_storage_service.dart';
import 'package:auth_ui_app/services/sync_controller.dart';
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
  final RxBool isTogglingTask = false.obs;

  final Rx<TodayTasksResponse?> todayResponse = Rx<TodayTasksResponse?>(null);
  final RxList<BranchTaskModel> todayTasks = <BranchTaskModel>[].obs;
  final Rx<TaskSummaryModel?> taskSummary = Rx<TaskSummaryModel?>(null);

  final RxList<TaskHistoryItemModel> historyItems = <TaskHistoryItemModel>[].obs;
  final RxInt selectedMonth = DateTime.now().month.obs;
  final RxInt selectedYear = DateTime.now().year.obs;
  final RxString selectedFilter = 'All'.obs; // 'All', 'Completed', 'Approved', 'Rejected'

  @override
  void onInit() {
    super.onInit();
    _loadCachedData();
    refreshAll();
  }

  void _loadCachedData() {
    try {
      final cached = OfflineStorageService.instance.getCache(OfflineStorageService.keyTasksCache);
      if (cached is Map<String, dynamic>) {
        todayResponse.value = TodayTasksResponse.fromJson(cached);
        todayTasks.assignAll(todayResponse.value!.tasks);
        taskSummary.value = todayResponse.value!.summary;
      }
    } catch (_) {}
  }

  /// Refresh all data
  Future<void> refreshAll() async {
    await Future.wait([
      fetchTodayTasks(),
      fetchHistory(month: selectedMonth.value, year: selectedYear.value),
    ]);
  }

  /// 1. Fetch Today's Branch Tasks (Clock-in Gated)
  Future<void> fetchTodayTasks() async {
    isLoadingToday.value = true;
    try {
      final response = await HrmApiService.instance.getTodayTasks();
      if (response.isSuccess && response.data != null) {
        todayResponse.value = response.data;
        todayTasks.assignAll(response.data!.tasks);
        taskSummary.value = response.data!.summary;

        await OfflineStorageService.instance.saveCache(
          OfflineStorageService.keyTasksCache,
          response.data!.toJson(),
        );
      }
    } catch (_) {
    } finally {
      isLoadingToday.value = false;
    }
  }

  /// 2. Complete or Toggle Task
  Future<void> toggleTask(BranchTaskModel task, {String? notes}) async {
    if (isTogglingTask.value) return;

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

    // Offline queuing support
    if (!SyncController.instance.isOnline.value) {
      await SyncController.instance.enqueueAction(
        actionType: 'task_toggle',
        payload: {
          'branch_task_id': task.id,
          'notes': notes,
          'timestamp': DateTime.now().toIso8601String(),
        },
        userMessage: "Task completion saved offline. Will sync when online.",
      );

      // Optimistically update locally
      final index = todayTasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        todayTasks[index] = task.copyWith(
          isCompleted: !task.isCompleted,
          status: !task.isCompleted ? 'completed' : 'pending',
          completedByMe: !task.isCompleted,
          notes: notes ?? task.notes,
        );
      }
      return;
    }

    isTogglingTask.value = true;

    try {
      final response = await HrmApiService.instance.toggleTaskComplete(
        branchTaskId: task.id,
        notes: notes,
      );

      isTogglingTask.value = false;

      if (response.isSuccess) {
        THelperFunctions.showSnackBar(
          response.message.isNotEmpty ? response.message : "Task status updated successfully!",
        );
        // Refresh live tasks and personal history
        await fetchTodayTasks();
        await fetchHistory();
      } else {
        Get.snackbar(
          'Task Action Failed',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withValues(alpha: 0.92),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      isTogglingTask.value = false;
      Get.snackbar(
        'Connection Error',
        'Could not connect to task server. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  /// 3. Fetch Personal Task Completion History
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

  void changeMonth(int month, int year) {
    selectedMonth.value = month;
    selectedYear.value = year;
    fetchHistory(month: month, year: year);
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
