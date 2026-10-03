import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;

import 'package:auth_ui_app/core/database/app_database.dart';
import 'package:auth_ui_app/services/auth_service.dart';

class LegacyGetStorageMigrator {
  static const String migrationMarkerKey = 'offline_storage_migrated_v1';
  static final _uuid = const Uuid();

  // Legacy GetStorage business keys
  static const String keyDashboardCache = 'cache_dashboard_data';
  static const String keyTasksCache = 'cache_tasks_data';
  static const String keyAttendanceCache = 'cache_attendance_data';
  static const String keyTargetsCache = 'cache_targets_data';
  static const String keyPayrollCache = 'cache_payroll_data';
  static const String keyUserProfileCache = 'cache_user_profile';
  static const String keyLocationsCache = 'cache_tenant_locations';
  static const String keyQueue = 'offline_pending_actions_queue';

  /// Execute one-time migration from legacy GetStorage to Drift SQLite database
  static Future<void> migrateIfNeeded() async {
    final storage = GetStorage();
    final isMigrated = storage.read<bool>(migrationMarkerKey) ?? false;
    if (isMigrated) return;

    if (kDebugMode) {
      print("[LegacyMigrator] Starting one-time migration from GetStorage to Drift SQLite...");
    }

    final db = AppDatabase.instance;
    final tenantId = AuthService.instance.getCurrentTenantId();
    final userId = AuthService.instance.getCurrentUserId();

    try {
      // 1. Migrate Pending Offline Actions Queue
      final rawQueue = storage.read<List>(keyQueue);
      if (rawQueue != null && rawQueue.isNotEmpty) {
        if (kDebugMode) {
          print("[LegacyMigrator] Migrating ${rawQueue.length} pending offline actions...");
        }

        for (final item in rawQueue) {
          try {
            final map = Map<String, dynamic>.from(item as Map);
            final actionType = map['actionType']?.toString() ?? 'unknown';
            final payload = map['payload'] is Map ? Map<String, dynamic>.from(map['payload'] as Map) : <String, dynamic>{};
            final createdAtStr = map['createdAt']?.toString();
            final createdAt = createdAtStr != null ? (DateTime.tryParse(createdAtStr) ?? DateTime.now()) : DateTime.now();
            final isSynced = map['synced'] == true;
            final lastError = map['lastError']?.toString();
            final syncAttempts = (map['syncAttempts'] as int?) ?? 0;

            String entityType = 'general';
            if (actionType.contains('attendance')) entityType = 'attendance';
            if (actionType.contains('task')) entityType = 'task';

            final isKnownOperation = [
              'attendance_checkin',
              'attendance_checkout',
              'task_toggle',
              'task_complete',
            ].contains(actionType);

            String status = 'pending';
            String? errorCode;
            if (isSynced) {
              status = 'synced';
            } else if (!isKnownOperation) {
              // CRITICAL: Unknown old action must NEVER be marked as synced!
              status = 'failed';
              errorCode = 'unsupported_operation';
            } else if (lastError != null) {
              status = 'retryWaiting';
            }

            final opId = map['id']?.toString() ?? _uuid.v4();
            final idempotencyKey = _uuid.v4();

            await db.offlineOperationsDao.insertOperation(
              OfflineOperationsCompanion(
                id: drift.Value(opId),
                tenantId: drift.Value(tenantId),
                userId: drift.Value(userId),
                operationType: drift.Value(actionType),
                entityType: drift.Value(entityType),
                payload: drift.Value(jsonEncode(payload)),
                status: drift.Value(status),
                retryCount: drift.Value(syncAttempts),
                lastError: drift.Value(lastError),
                errorCode: drift.Value(errorCode),
                idempotencyKey: drift.Value(idempotencyKey),
                createdAt: drift.Value(createdAt),
                updatedAt: drift.Value(DateTime.now()),
                syncedAt: isSynced ? drift.Value(DateTime.now()) : const drift.Value.absent(),
              ),
            );
          } catch (e) {
            if (kDebugMode) print("[LegacyMigrator] Error migrating action item: $e");
          }
        }
      }

      // 2. Migrate Cached Tenant Locations
      final rawLocations = storage.read<List>(keyLocationsCache);
      if (rawLocations != null && rawLocations.isNotEmpty) {
        final companions = rawLocations.map((item) {
          final map = Map<String, dynamic>.from(item as Map);
          return TenantLocationsTableCompanion(
            id: drift.Value(map['id'] is int ? map['id'] : int.tryParse(map['id']?.toString() ?? '1') ?? 1),
            tenantId: drift.Value(tenantId),
            locationName: drift.Value(map['name']?.toString() ?? map['location_name']?.toString() ?? 'Office'),
            address: drift.Value(map['address']?.toString()),
            latitude: drift.Value((map['latitude'] as num?)?.toDouble() ?? 23.8103),
            longitude: drift.Value((map['longitude'] as num?)?.toDouble() ?? 90.4125),
            radiusMeters: drift.Value((map['radius'] as num?)?.toDouble() ?? (map['radius_meters'] as num?)?.toDouble() ?? 150.0),
            isActive: const drift.Value(true),
            fetchedAt: drift.Value(DateTime.now()),
          );
        }).toList();

        await db.tenantLocationsDao.replaceLocations(tenantId, companions);
      }

      // 3. Mark migration complete and remove old business cache keys safely
      await storage.write(migrationMarkerKey, true);
      await storage.remove(keyQueue);
      await storage.remove(keyDashboardCache);
      await storage.remove(keyTasksCache);
      await storage.remove(keyAttendanceCache);
      await storage.remove(keyTargetsCache);
      await storage.remove(keyPayrollCache);
      await storage.remove(keyUserProfileCache);
      await storage.remove(keyLocationsCache);

      if (kDebugMode) {
        print("[LegacyMigrator] Migration successfully completed and marked v1.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("[LegacyMigrator] Error during migration: $e");
      }
    }
  }
}
