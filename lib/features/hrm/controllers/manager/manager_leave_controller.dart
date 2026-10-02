import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:auth_ui_app/features/hrm/models/manager_models.dart';
import 'package:auth_ui_app/services/hrm_api_service.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class ManagerLeaveController extends GetxController {
  static ManagerLeaveController get instance => Get.isRegistered<ManagerLeaveController>()
      ? Get.find<ManagerLeaveController>()
      : Get.put(ManagerLeaveController());

  final HrmApiService _apiService = HrmApiService.instance;

  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final leaves = <ManagerLeaveModel>[].obs;

  final selectedTab = 0.obs; // 0 = Pending, 1 = Approved, 2 = Rejected
  final filterMonth = Rxn<int>();
  final filterYear = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    fetchLeaves();
  }

  List<ManagerLeaveModel> get pendingLeaves => leaves.where((l) => l.status == 'pending').toList();
  List<ManagerLeaveModel> get approvedLeaves => leaves.where((l) => l.status == 'approved').toList();
  List<ManagerLeaveModel> get rejectedLeaves => leaves.where((l) => l.status == 'rejected').toList();

  int get pendingCount => pendingLeaves.length;

  Future<void> fetchLeaves() async {
    isLoading.value = true;
    try {
      final res = await _apiService.getManagerLeaves(
        month: filterMonth.value,
        year: filterYear.value,
      );

      if (res.isSuccess && res.data != null) {
        leaves.assignAll(res.data!);
      }
    } catch (e) {
      debugPrint("Error fetching manager leaves: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Approve or Reject Leave Request
  Future<bool> reviewLeave({
    required int leaveId,
    required String status, // 'approved' or 'rejected'
    String? comment,
  }) async {
    isSubmitting.value = true;
    try {
      final res = await _apiService.reviewManagerLeave(
        leaveId: leaveId,
        status: status,
        comment: comment,
      );
      isSubmitting.value = false;

      if (res.isSuccess) {
        THelperFunctions.showSnackBar(
          status == 'approved' ? "Leave request approved." : "Leave request rejected.",
        );
        fetchLeaves();
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

  /// Create Leave for Staff
  Future<bool> createLeave(Map<String, dynamic> data) async {
    isSubmitting.value = true;
    try {
      final res = await _apiService.createLeaveForStaff(data);
      isSubmitting.value = false;

      if (res.isSuccess) {
        THelperFunctions.showSnackBar(res.message ?? "Leave recorded successfully!");
        fetchLeaves();
        return true;
      } else {
        THelperFunctions.showSnackBar(res.message ?? "Failed to create leave.");
        return false;
      }
    } catch (e) {
      isSubmitting.value = false;
      THelperFunctions.showSnackBar("An error occurred: $e");
      return false;
    }
  }
}
