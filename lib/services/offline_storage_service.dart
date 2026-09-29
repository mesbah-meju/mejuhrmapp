import 'package:get_storage/get_storage.dart';
import 'package:flutter/foundation.dart';

class OfflineAction {
  final String id;
  final String actionType;
  final Map<String, dynamic> payload;
  final String createdAt;
  bool synced;
  int syncAttempts;
  String? lastError;

  OfflineAction({
    required this.id,
    required this.actionType,
    required this.payload,
    required this.createdAt,
    this.synced = false,
    this.syncAttempts = 0,
    this.lastError,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'actionType': actionType,
        'payload': payload,
        'createdAt': createdAt,
        'synced': synced,
        'syncAttempts': syncAttempts,
        'lastError': lastError,
      };

  factory OfflineAction.fromJson(Map<String, dynamic> json) => OfflineAction(
        id: json['id'] as String,
        actionType: json['actionType'] as String,
        payload: Map<String, dynamic>.from(json['payload'] as Map),
        createdAt: json['createdAt'] as String,
        synced: json['synced'] as bool? ?? false,
        syncAttempts: json['syncAttempts'] as int? ?? 0,
        lastError: json['lastError'] as String?,
      );
}

class OfflineStorageService {
  static final OfflineStorageService instance = OfflineStorageService._internal();
  OfflineStorageService._internal();

  final GetStorage _storage = GetStorage();
  static const String _queueKey = 'offline_pending_actions_queue';

  // Cache keys
  static const String keyDashboardCache = 'cache_dashboard_data';
  static const String keyTasksCache = 'cache_tasks_data';
  static const String keyAttendanceCache = 'cache_attendance_data';
  static const String keyTargetsCache = 'cache_targets_data';
  static const String keyPayrollCache = 'cache_payroll_data';
  static const String keyUserProfileCache = 'cache_user_profile';

  /// Save cached JSON data locally
  Future<void> saveCache(String key, dynamic data) async {
    try {
      await _storage.write(key, data);
    } catch (e) {
      if (kDebugMode) print('Error saving cache [$key]: $e');
    }
  }

  /// Retrieve cached JSON data
  dynamic getCache(String key) {
    try {
      return _storage.read(key);
    } catch (e) {
      if (kDebugMode) print('Error reading cache [$key]: $e');
      return null;
    }
  }

  /// Remove cached JSON data
  Future<void> removeCache(String key) async {
    await _storage.remove(key);
  }

  /// Add an offline action to the queue
  Future<OfflineAction> enqueueAction(String actionType, Map<String, dynamic> payload) async {
    final action = OfflineAction(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      actionType: actionType,
      payload: payload,
      createdAt: DateTime.now().toIso8601String(),
    );

    final List<dynamic> rawQueue = _storage.read<List>(_queueKey) ?? [];
    rawQueue.add(action.toJson());
    await _storage.write(_queueKey, rawQueue);
    return action;
  }

  /// Get list of pending offline actions
  List<OfflineAction> getPendingActions() {
    final List<dynamic> rawQueue = _storage.read<List>(_queueKey) ?? [];
    return rawQueue
        .map((item) => OfflineAction.fromJson(Map<String, dynamic>.from(item as Map)))
        .where((action) => !action.synced)
        .toList();
  }

  /// Get total count of pending actions
  int getPendingCount() {
    return getPendingActions().length;
  }

  /// Mark an action as successfully synced
  Future<void> markActionSynced(String id) async {
    final List<dynamic> rawQueue = _storage.read<List>(_queueKey) ?? [];
    final updated = rawQueue.map((item) {
      final map = Map<String, dynamic>.from(item as Map);
      if (map['id'] == id) {
        map['synced'] = true;
      }
      return map;
    }).toList();

    await _storage.write(_queueKey, updated);
  }

  /// Update action sync failure
  Future<void> markActionFailed(String id, String error) async {
    final List<dynamic> rawQueue = _storage.read<List>(_queueKey) ?? [];
    final updated = rawQueue.map((item) {
      final map = Map<String, dynamic>.from(item as Map);
      if (map['id'] == id) {
        map['syncAttempts'] = ((map['syncAttempts'] as int? ?? 0) + 1);
        map['lastError'] = error;
      }
      return map;
    }).toList();

    await _storage.write(_queueKey, updated);
  }

  /// Remove synced actions from local storage queue
  Future<void> clearSyncedActions() async {
    final List<dynamic> rawQueue = _storage.read<List>(_queueKey) ?? [];
    final pendingOnly = rawQueue.where((item) {
      final map = Map<String, dynamic>.from(item as Map);
      return map['synced'] != true;
    }).toList();

    await _storage.write(_queueKey, pendingOnly);
  }

  /// Purge entire offline queue
  Future<void> clearAllQueue() async {
    await _storage.remove(_queueKey);
  }
}
