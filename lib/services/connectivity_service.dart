import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:auth_ui_app/core/sync/sync_engine.dart';

class ConnectivityService with WidgetsBindingObserver {
  static final ConnectivityService instance = ConnectivityService._internal();
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _healthProbeTimer;

  final ValueNotifier<bool> networkAvailableNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> apiReachableNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> manualOfflineModeNotifier = ValueNotifier<bool>(false);

  /// Computed boolean for whether app is fully online and ready for API requests
  bool get isOnline =>
      networkAvailableNotifier.value &&
      apiReachableNotifier.value &&
      !manualOfflineModeNotifier.value;

  /// Computed boolean for whether device has an active network interface
  bool get hasNetworkInterface => networkAvailableNotifier.value;

  /// Computed boolean for manual offline simulation
  bool get isManualOffline => manualOfflineModeNotifier.value;

  /// Initialize connectivity listeners and lifecycle observers
  Future<void> initialize() async {
    WidgetsBinding.instance.addObserver(this);

    // Initial interface check
    try {
      final results = await _connectivity.checkConnectivity();
      _updateInterfaceStatus(results);
    } catch (_) {}

    // Listen to interface changes (Wifi, Cellular, None)
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((results) {
      _updateInterfaceStatus(results);
    });

    // Start background health probe every 30 seconds
    _healthProbeTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (networkAvailableNotifier.value && !manualOfflineModeNotifier.value) {
        checkInternetAccess();
      }
    });

    // Initial internet probe
    await checkInternetAccess();
  }

  void _updateInterfaceStatus(List<ConnectivityResult> results) {
    final hasInterface = results.any((r) => r != ConnectivityResult.none);
    final previousState = networkAvailableNotifier.value;
    networkAvailableNotifier.value = hasInterface;

    if (hasInterface && !previousState) {
      if (kDebugMode) print("[ConnectivityService] Network interface restored. Probing API...");
      checkInternetAccess();
    } else if (!hasInterface) {
      apiReachableNotifier.value = false;
      if (kDebugMode) print("[ConnectivityService] Network interface disconnected.");
    }
  }

  /// Probe actual internet / DNS reachability
  Future<bool> checkInternetAccess() async {
    if (manualOfflineModeNotifier.value) {
      return false;
    }

    try {
      final lookup = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 4));
      final isReachable = lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty;

      final previous = apiReachableNotifier.value;
      apiReachableNotifier.value = isReachable;

      if (isReachable && !previous) {
        if (kDebugMode) print("[ConnectivityService] Internet access confirmed! Triggering sync queue...");
        SyncEngine.instance.processQueue();
      }
      return isReachable;
    } catch (_) {
      apiReachableNotifier.value = false;
      return false;
    }
  }

  /// Hook called by ApiClient on successful HTTP response
  void reportNetworkSuccess() {
    if (!apiReachableNotifier.value) {
      apiReachableNotifier.value = true;
      SyncEngine.instance.processQueue();
    }
  }

  /// Hook called by ApiClient on network socket / timeout failure
  void reportNetworkFailure(dynamic error) {
    if (error is SocketException || error is TimeoutException) {
      apiReachableNotifier.value = false;
    }
  }

  /// Toggle manual offline simulation
  void toggleManualOffline() {
    manualOfflineModeNotifier.value = !manualOfflineModeNotifier.value;
    if (!manualOfflineModeNotifier.value) {
      checkInternetAccess();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (kDebugMode) print("[ConnectivityService] App resumed from background. Checking sync queue...");
      checkInternetAccess();
      SyncEngine.instance.processQueue();
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivitySubscription?.cancel();
    _healthProbeTimer?.cancel();
  }
}
