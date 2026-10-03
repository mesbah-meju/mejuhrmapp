import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:auth_ui_app/core/database/app_database.dart';
import 'package:auth_ui_app/core/sync/sync_engine.dart';
import 'package:auth_ui_app/services/auth_service.dart';
import 'package:auth_ui_app/services/connectivity_service.dart';
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

  StreamSubscription<int>? _pendingSubscription;
  StreamSubscription<List<OfflineOperation>>? _operationsSubscription;
  final RxList<OfflineOperation> allOperations = <OfflineOperation>[].obs;

  @override
  void onInit() {
    super.onInit();
    _bindConnectivity();
    _bindDatabaseStream();
    _bindSyncEngineState();
  }

  @override
  void onClose() {
    _pendingSubscription?.cancel();
    _operationsSubscription?.cancel();
    super.onClose();
  }

  void _bindConnectivity() {
    // React to connectivity changes
    ConnectivityService.instance.apiReachableNotifier.addListener(_updateOnlineStatus);
    ConnectivityService.instance.networkAvailableNotifier.addListener(_updateOnlineStatus);
    ConnectivityService.instance.manualOfflineModeNotifier.addListener(_updateOnlineStatus);
    _updateOnlineStatus();
  }

  void _updateOnlineStatus() {
    isOnline.value = ConnectivityService.instance.isOnline;
  }

  void _bindSyncEngineState() {
    SyncEngine.instance.isSyncingNotifier.addListener(() {
      isSyncing.value = SyncEngine.instance.isSyncingNotifier.value;
    });

    SyncEngine.instance.lastSyncNotifier.addListener(() {
      final dt = SyncEngine.instance.lastSyncNotifier.value;
      if (dt != null) {
        lastSyncedAt.value = DateFormat('hh:mm a').format(dt);
      }
    });
  }

  void _bindDatabaseStream() {
    final tenantId = AuthService.instance.getCurrentTenantId();

    // Watch pending count
    _pendingSubscription = AppDatabase.instance.offlineOperationsDao
        .watchPendingCount(tenantId)
        .listen((count) {
      pendingCount.value = count;
    });

    // Watch all operations for Sync Center screen
    _operationsSubscription = AppDatabase.instance.offlineOperationsDao
        .watchOperationsForTenant(tenantId)
        .listen((ops) {
      allOperations.assignAll(ops);
    });
  }

  /// Re-bind streams when tenant or user changes
  void rebindTenant() {
    _pendingSubscription?.cancel();
    _operationsSubscription?.cancel();
    _bindDatabaseStream();
  }

  /// Toggle manual offline mode simulation
  void toggleOfflineMode() {
    ConnectivityService.instance.toggleManualOffline();
    _updateOnlineStatus();
    if (isOnline.value) {
      THelperFunctions.showSnackBar("Network restored. Syncing offline queue...");
      SyncEngine.instance.processQueue();
    } else {
      THelperFunctions.showSnackBar("App switched to Offline Mode. Actions will be queued locally in SQLite.");
    }
  }

  /// Queue an action into the SQLite Drift queue
  Future<void> enqueueAction({
    required String actionType,
    required Map<String, dynamic> payload,
    String? entityType,
    String? entityLocalId,
    int? entityServerId,
    String? userMessage,
    int priority = 0,
  }) async {
    await SyncEngine.instance.enqueueOperation(
      operationType: actionType,
      entityType: entityType ?? 'general',
      payload: payload,
      entityLocalId: entityLocalId,
      entityServerId: entityServerId,
      priority: priority,
    );

    if (userMessage != null && userMessage.isNotEmpty) {
      if (!isOnline.value) {
        THelperFunctions.showSnackBar("$userMessage (Saved in Local SQLite Queue)");
      } else {
        THelperFunctions.showSnackBar(userMessage);
      }
    }
  }

  /// Trigger sync now
  Future<void> syncPendingActions() async {
    if (!isOnline.value) {
      THelperFunctions.showSnackBar("Cannot sync while offline.");
      return;
    }
    await SyncEngine.instance.processQueue();
  }

  /// Retry all failed operations
  Future<void> retryAllFailed() async {
    await SyncEngine.instance.retryAllFailed();
  }

  /// Check connectivity and trigger sync
  Future<void> checkConnectivityAndSync() async {
    await ConnectivityService.instance.checkInternetAccess();
    if (isOnline.value) {
      await SyncEngine.instance.processQueue();
    }
  }

  /// Cancel specific operation
  Future<void> cancelOperation(String id) async {
    await SyncEngine.instance.cancelOperation(id);
  }
}
