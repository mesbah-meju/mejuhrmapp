import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:auth_ui_app/features/hrm/models/manager_models.dart';
import 'package:auth_ui_app/features/hrm/models/target_model.dart';
import 'package:auth_ui_app/services/hrm_api_service.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class ManagerTargetController extends GetxController {
  static ManagerTargetController get instance => Get.isRegistered<ManagerTargetController>()
      ? Get.find<ManagerTargetController>()
      : Get.put(ManagerTargetController());

  final HrmApiService _apiService = HrmApiService.instance;

  final isLoadingTargets = false.obs;
  final isLoadingLogs = false.obs;
  final isSubmitting = false.obs;

  final targets = <ManagerSalesTargetModel>[].obs;
  final salesLogs = <SalesLogModel>[].obs;
  final selectedLogStatus = 'pending'.obs; // 'pending', 'approved', 'rejected'

  @override
  void onInit() {
    super.onInit();
    fetchTargets();
    fetchSalesLogs();
  }

  int get pendingLogsCount => salesLogs.where((l) => l.status.toLowerCase() == 'pending').length;

  Future<void> fetchTargets() async {
    isLoadingTargets.value = true;
    try {
      final res = await _apiService.getManagerTargets();
      if (res.isSuccess && res.data != null) {
        targets.assignAll(res.data!);
      }
    } catch (e) {
      debugPrint("Error fetching targets: $e");
    } finally {
      isLoadingTargets.value = false;
    }
  }

  Future<void> fetchSalesLogs() async {
    isLoadingLogs.value = true;
    try {
      final res = await _apiService.managerGetSalesLogs(
        status: selectedLogStatus.value == 'all' ? null : selectedLogStatus.value,
      );
      if (res.isSuccess && res.data != null) {
        salesLogs.assignAll(res.data!);
      }
    } catch (e) {
      debugPrint("Error fetching manager sales logs: $e");
    } finally {
      isLoadingLogs.value = false;
    }
  }

  void updateLogStatusFilter(String status) {
    selectedLogStatus.value = status;
    fetchSalesLogs();
  }

  /// Create Target
  Future<bool> createTarget(Map<String, dynamic> data) async {
    isSubmitting.value = true;
    try {
      final res = await _apiService.createManagerTarget(data);
      isSubmitting.value = false;

      if (res.isSuccess) {
        THelperFunctions.showSnackBar(res.message ?? "Target created successfully!");
        fetchTargets();
        return true;
      } else {
        THelperFunctions.showSnackBar(res.message ?? "Failed to create target.");
        return false;
      }
    } catch (e) {
      isSubmitting.value = false;
      THelperFunctions.showSnackBar("An error occurred: $e");
      return false;
    }
  }

  /// Update Target
  Future<bool> updateTarget(int id, Map<String, dynamic> data) async {
    isSubmitting.value = true;
    try {
      final res = await _apiService.updateManagerTarget(id, data);
      isSubmitting.value = false;

      if (res.isSuccess) {
        THelperFunctions.showSnackBar(res.message ?? "Target updated successfully!");
        fetchTargets();
        return true;
      } else {
        THelperFunctions.showSnackBar(res.message ?? "Failed to update target.");
        return false;
      }
    } catch (e) {
      isSubmitting.value = false;
      THelperFunctions.showSnackBar("An error occurred: $e");
      return false;
    }
  }

  /// Delete Target
  Future<bool> deleteTarget(int id) async {
    isSubmitting.value = true;
    try {
      final res = await _apiService.deleteManagerTarget(id);
      isSubmitting.value = false;

      if (res.isSuccess) {
        THelperFunctions.showSnackBar(res.message ?? "Target deleted.");
        fetchTargets();
        return true;
      } else {
        THelperFunctions.showSnackBar(res.message ?? "Failed to delete target.");
        return false;
      }
    } catch (e) {
      isSubmitting.value = false;
      THelperFunctions.showSnackBar("An error occurred: $e");
      return false;
    }
  }

  /// Approve Sales Log
  Future<bool> approveSalesLog(int logId) async {
    isSubmitting.value = true;
    try {
      final res = await _apiService.managerApproveSalesLog(logId);
      isSubmitting.value = false;

      if (res.isSuccess) {
        THelperFunctions.showSnackBar(res.message ?? "Sales entry approved!");
        fetchSalesLogs();
        return true;
      } else {
        THelperFunctions.showSnackBar(res.message ?? "Approval failed.");
        return false;
      }
    } catch (e) {
      isSubmitting.value = false;
      THelperFunctions.showSnackBar("An error occurred: $e");
      return false;
    }
  }

  /// Reject Sales Log
  Future<bool> rejectSalesLog(int logId, String reason) async {
    isSubmitting.value = true;
    try {
      final res = await _apiService.managerRejectSalesLog(logId, reason);
      isSubmitting.value = false;

      if (res.isSuccess) {
        THelperFunctions.showSnackBar(res.message ?? "Sales entry rejected.");
        fetchSalesLogs();
        return true;
      } else {
        THelperFunctions.showSnackBar(res.message ?? "Action failed.");
        return false;
      }
    } catch (e) {
      isSubmitting.value = false;
      THelperFunctions.showSnackBar("An error occurred: $e");
      return false;
    }
  }
}
