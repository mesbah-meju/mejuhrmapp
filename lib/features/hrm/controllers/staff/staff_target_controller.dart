import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:auth_ui_app/features/hrm/models/target_model.dart';
import 'package:auth_ui_app/services/hrm_api_service.dart';
import 'package:auth_ui_app/services/sync_controller.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class TargetController extends GetxController {
  static TargetController get instance {
    if (!Get.isRegistered<TargetController>()) {
      return Get.put(TargetController(), permanent: true);
    }
    return Get.find<TargetController>();
  }

  // Observables
  final RxBool isLoadingTargets = false.obs;
  final RxBool isLoadingLogs = false.obs;
  final RxBool isLoggingSale = false.obs;
  final RxBool isLoadingProducts = false.obs;
  final RxBool isReviewing = false.obs;

  // Performly Data
  final Rx<PerformlyStatsModel> stats = Rx<PerformlyStatsModel>(PerformlyStatsModel());
  final RxList<TargetModel> targetsList = <TargetModel>[].obs;
  final Rx<TargetModel?> selectedTarget = Rx<TargetModel?>(null);
  final RxList<SalesLogModel> salesLogs = <SalesLogModel>[].obs;
  final RxList<PerformlyProductModel> productsList = <PerformlyProductModel>[].obs;

  // Manager Data
  final RxList<SalesLogModel> managerSalesLogs = <SalesLogModel>[].obs;

  // Filter state
  final RxString selectedTargetStatus = 'active'.obs; // 'active', 'completed', 'All'
  final RxString selectedLogStatus = 'All'.obs; // 'All', 'pending', 'approved', 'rejected'
  final RxInt selectedMonth = DateTime.now().month.obs;
  final RxInt selectedYear = DateTime.now().year.obs;

  @override
  void onInit() {
    super.onInit();
    refreshAll();
  }

  /// Refresh everything
  Future<void> refreshAll() async {
    await Future.wait([
      fetchTargets(),
      fetchSalesLogs(),
      fetchProducts(),
    ]);
  }

  /// 1. Fetch Staff Targets & Summary Stats
  Future<void> fetchTargets({String? status}) async {
    isLoadingTargets.value = true;
    try {
      final stat = status ?? (selectedTargetStatus.value != 'All' ? selectedTargetStatus.value : null);
      final response = await HrmApiService.instance.getMyTargets(status: stat);

      if (response.isSuccess && response.data != null) {
        stats.value = response.data!.stats;
        targetsList.assignAll(response.data!.targets);
      }
    } catch (_) {
    } finally {
      isLoadingTargets.value = false;
    }
  }

  /// 2. Fetch Single Target Details
  Future<void> fetchTargetDetails(int targetId) async {
    try {
      final response = await HrmApiService.instance.getTargetDetails(targetId);
      if (response.isSuccess && response.data != null) {
        selectedTarget.value = response.data;
        // Also update in list if present
        final index = targetsList.indexWhere((t) => t.id == targetId);
        if (index != -1) {
          targetsList[index] = response.data!;
        }
      }
    } catch (_) {}
  }

  /// 3. Fetch Staff Sales Logs History
  Future<void> fetchSalesLogs({String? status, int? month, int? year, int? targetId}) async {
    isLoadingLogs.value = true;
    try {
      final stat = status ?? (selectedLogStatus.value != 'All' ? selectedLogStatus.value.toLowerCase() : null);
      final m = month ?? selectedMonth.value;
      final y = year ?? selectedYear.value;

      final response = await HrmApiService.instance.getMySalesLogs(
        status: stat,
        month: m,
        year: y,
        targetId: targetId,
      );

      if (response.isSuccess && response.data != null) {
        salesLogs.assignAll(response.data!.items);
      }
    } catch (_) {
    } finally {
      isLoadingLogs.value = false;
    }
  }

  /// 4. Fetch Products for selection
  Future<void> fetchProducts() async {
    isLoadingProducts.value = true;
    try {
      final response = await HrmApiService.instance.getPerformlyProducts();
      if (response.isSuccess && response.data != null) {
        productsList.assignAll(response.data!);
      }
    } catch (_) {
    } finally {
      isLoadingProducts.value = false;
    }
  }

  /// 5. Staff: Log a Sale / Work Achievement Progress
  Future<bool> submitSaleLog({
    int? targetId,
    required String logDate,
    required String entryType,
    int? productId,
    required double quantity,
    double? unitPrice,
    double? totalAmount,
    String? customerName,
    String? invoiceNo,
    String? notes,
  }) async {
    if (isLoggingSale.value) return false;

    // Offline support
    if (!SyncController.instance.isOnline.value) {
      await SyncController.instance.enqueueAction(
        actionType: 'sales_log_create',
        payload: {
          'target_id': targetId,
          'log_date': logDate,
          'entry_type': entryType,
          'product_id': productId,
          'quantity': quantity,
          'unit_price': unitPrice,
          'total_amount': totalAmount,
          'customer_name': customerName,
          'invoice_no': invoiceNo,
          'notes': notes,
        },
        userMessage: "Sales log recorded offline. Will sync when back online.",
      );
      return true;
    }

    isLoggingSale.value = true;

    try {
      final response = await HrmApiService.instance.logSale(
        targetId: targetId,
        logDate: logDate,
        entryType: entryType,
        productId: productId,
        quantity: quantity,
        unitPrice: unitPrice,
        totalAmount: totalAmount,
        customerName: customerName,
        invoiceNo: invoiceNo,
        notes: notes,
      );

      isLoggingSale.value = false;

      if (response.isSuccess) {
        THelperFunctions.showSnackBar(
          response.message.isNotEmpty
              ? response.message
              : "Sales log submitted and pending manager approval!",
        );
        // Refresh targets and logs
        await fetchTargets();
        await fetchSalesLogs();
        return true;
      } else {
        Get.snackbar(
          'Submission Failed',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
        );
        return false;
      }
    } catch (e) {
      isLoggingSale.value = false;
      Get.snackbar(
        'Connection Error',
        'Could not submit sales log. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withValues(alpha: 0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return false;
    }
  }

  /// 6. Manager: Fetch Pending Sales Logs
  Future<void> fetchManagerSalesLogs({String? status}) async {
    try {
      final response = await HrmApiService.instance.managerGetSalesLogs(status: status);
      if (response.isSuccess && response.data != null) {
        managerSalesLogs.assignAll(response.data!);
      }
    } catch (_) {}
  }

  /// 7. Manager: Approve Sales Log
  Future<void> approveSalesLog(int logId) async {
    if (isReviewing.value) return;
    isReviewing.value = true;

    try {
      final response = await HrmApiService.instance.managerApproveSalesLog(logId);
      isReviewing.value = false;

      if (response.isSuccess) {
        THelperFunctions.showSnackBar(
          response.message.isNotEmpty ? response.message : "Sales log approved!",
        );
        await fetchManagerSalesLogs();
        await fetchTargets();
      }
    } catch (_) {
      isReviewing.value = false;
    }
  }

  /// 8. Manager: Reject Sales Log
  Future<void> rejectSalesLog(int logId, String reason) async {
    if (isReviewing.value) return;
    isReviewing.value = true;

    try {
      final response = await HrmApiService.instance.managerRejectSalesLog(logId, reason);
      isReviewing.value = false;

      if (response.isSuccess) {
        THelperFunctions.showSnackBar(
          response.message.isNotEmpty ? response.message : "Sales log rejected.",
        );
        await fetchManagerSalesLogs();
      }
    } catch (_) {
      isReviewing.value = false;
    }
  }

  void setTargetStatusFilter(String status) {
    selectedTargetStatus.value = status;
    fetchTargets(status: status != 'All' ? status : null);
  }

  void setLogStatusFilter(String status) {
    selectedLogStatus.value = status;
    fetchSalesLogs(status: status != 'All' ? status : null);
  }
}
