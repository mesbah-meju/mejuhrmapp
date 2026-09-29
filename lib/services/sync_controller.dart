import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:auth_ui_app/services/offline_storage_service.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class SyncController extends GetxController {
  static SyncController get instance {
    if (!Get.isRegistered<SyncController>()) {
      return Get.put(SyncController(), permanent: true);
    }
    return Get.find<SyncController>();
  }

  final RxBool isOnline = true.obs;
  final RxBool isSyncing = false.obs;
  final RxInt pendingCount = 0.obs;
  final RxString lastSyncedAt = "Just now".obs;

  Timer? _periodicSyncTimer;

  @override
  void onInit() {
    super.onInit();
    refreshPendingCount();
    // Start periodic connectivity check & sync timer
    _periodicSyncTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (isOnline.value && pendingCount.value > 0 && !isSyncing.value) {
        syncPendingActions();
      }
    });
  }

  @override
  void onClose() {
    _periodicSyncTimer?.cancel();
    super.onClose();
  }

  /// Update pending queue count from local storage
  void refreshPendingCount() {
    pendingCount.value = OfflineStorageService.instance.getPendingCount();
  }

  /// Toggle manual online/offline simulation mode for demo/testing
  void toggleOfflineMode() {
    isOnline.value = !isOnline.value;
    if (isOnline.value) {
      THelperFunctions.showSnackBar("Network restored. Syncing offline data...");
      syncPendingActions();
    } else {
      THelperFunctions.showSnackBar("App switched to Offline Mode. Actions will be queued locally.");
    }
  }

  /// Queue an action to be saved locally & synced when online
  Future<void> enqueueAction({
    required String actionType,
    required Map<String, dynamic> payload,
    String? userMessage,
  }) async {
    await OfflineStorageService.instance.enqueueAction(actionType, payload);
    refreshPendingCount();

    if (userMessage != null && userMessage.isNotEmpty) {
      if (!isOnline.value) {
        THelperFunctions.showSnackBar("$userMessage (Saved Offline)");
      } else {
        THelperFunctions.showSnackBar(userMessage);
      }
    }

    if (isOnline.value && !isSyncing.value) {
      syncPendingActions();
    }
  }

  /// Sync all pending actions with backend
  Future<void> syncPendingActions() async {
    if (!isOnline.value) {
      THelperFunctions.showSnackBar("Cannot sync while offline.");
      return;
    }

    final pending = OfflineStorageService.instance.getPendingActions();
    if (pending.isEmpty) {
      refreshPendingCount();
      return;
    }

    isSyncing.value = true;
    int successCount = 0;
    int failCount = 0;

    for (final action in pending) {
      try {
        if (kDebugMode) {
          print("Syncing action ${action.id} of type ${action.actionType}...");
        }

        // Simulate network delay for API request
        await Future.delayed(const Duration(milliseconds: 600));

        // Mark action as synced in local storage
        await OfflineStorageService.instance.markActionSynced(action.id);
        successCount++;
      } catch (e) {
        failCount++;
        await OfflineStorageService.instance.markActionFailed(action.id, e.toString());
        if (kDebugMode) {
          print("Failed to sync action ${action.id}: $e");
        }
      }
    }

    // Clean up completed actions from storage
    await OfflineStorageService.instance.clearSyncedActions();
    refreshPendingCount();

    isSyncing.value = false;
    final now = DateTime.now();
    lastSyncedAt.value = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    if (successCount > 0) {
      THelperFunctions.showSnackBar("Successfully synced $successCount offline actions with server!");
    } else if (failCount > 0) {
      THelperFunctions.showSnackBar("Failed to sync $failCount actions. Will retry shortly.");
    }
  }
}
