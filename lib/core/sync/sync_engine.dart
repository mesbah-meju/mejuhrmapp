import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;

import 'package:auth_ui_app/core/database/app_database.dart';
import 'package:auth_ui_app/core/sync/handlers/attendance_checkin_handler.dart';
import 'package:auth_ui_app/core/sync/handlers/attendance_checkout_handler.dart';
import 'package:auth_ui_app/core/sync/handlers/task_complete_handler.dart';
import 'package:auth_ui_app/core/sync/handlers/task_toggle_handler.dart';
import 'package:auth_ui_app/core/sync/sync_operation_handler.dart';
import 'package:auth_ui_app/core/sync/sync_result.dart';
import 'package:auth_ui_app/core/repositories/attendance_repository.dart';
import 'package:auth_ui_app/services/auth_service.dart';
import 'package:auth_ui_app/services/connectivity_service.dart';

class SyncEngine {
  static final SyncEngine instance = SyncEngine._internal();
  SyncEngine._internal() {
    _registerDefaultHandlers();
  }

  final AppDatabase _db = AppDatabase.instance;
  final Map<String, SyncOperationHandler> _handlers = {};
  final _uuid = const Uuid();

  bool _isProcessing = false;
  final ValueNotifier<bool> isSyncingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<DateTime?> lastSyncNotifier = ValueNotifier<DateTime?>(null);

  void _registerDefaultHandlers() {
    registerHandler(AttendanceCheckInHandler());
    registerHandler(AttendanceCheckOutHandler());
    registerHandler(TaskToggleHandler());
    registerHandler(TaskCompleteHandler());
  }

  /// Register custom or new operation handlers
  void registerHandler(SyncOperationHandler handler) {
    _handlers[handler.operationType] = handler;
  }

  /// Enqueue an offline operation into SQLite Drift queue with idempotency protection
  Future<OfflineOperation> enqueueOperation({
    required String operationType,
    required String entityType,
    required Map<String, dynamic> payload,
    String? entityLocalId,
    int? entityServerId,
    String? dependsOnOperationId,
    int priority = 0,
    int maxRetries = SyncRetryPolicy.defaultMaxRetries,
    int? tenantId,
    int? userId,
  }) async {
    final currentTenantId = tenantId ?? AuthService.instance.getCurrentTenantId();
    final currentUserId = userId ?? AuthService.instance.getCurrentUserId();
    final opId = _uuid.v4();
    final idempotencyKey = _uuid.v4();
    final now = DateTime.now();

    final companion = OfflineOperationsCompanion(
      id: drift.Value(opId),
      tenantId: drift.Value(currentTenantId),
      userId: drift.Value(currentUserId),
      operationType: drift.Value(operationType),
      entityType: drift.Value(entityType),
      entityLocalId: drift.Value(entityLocalId),
      entityServerId: drift.Value(entityServerId),
      payload: drift.Value(jsonEncode(payload)),
      status: const drift.Value('pending'),
      priority: drift.Value(priority),
      retryCount: const drift.Value(0),
      maxRetries: drift.Value(maxRetries),
      dependsOnOperationId: drift.Value(dependsOnOperationId),
      idempotencyKey: drift.Value(idempotencyKey),
      createdAt: drift.Value(now),
      updatedAt: drift.Value(now),
    );

    await _db.offlineOperationsDao.insertOperation(companion);

    final op = await _db.offlineOperationsDao.getOperationById(opId);

    // Trigger sync process immediately if online
    if (ConnectivityService.instance.isOnline) {
      processQueue();
    }

    return op!;
  }

  /// Process pending and retryable operations in SQLite queue
  Future<void> processQueue({bool forceAll = false}) async {
    if (_isProcessing) return;
    if (!ConnectivityService.instance.isOnline) return;

    _isProcessing = true;
    isSyncingNotifier.value = true;

    final tenantId = AuthService.instance.getCurrentTenantId();

    try {
      // Step 1: Recover any stale operations stuck in 'syncing' state
      await _db.offlineOperationsDao.recoverStaleSyncingOperations(tenantId);

      // Step 2: Fetch next actionable operations
      final operations = await _db.offlineOperationsDao.getNextActionableOperations(
        tenantId: tenantId,
        limit: 25,
      );

      if (operations.isEmpty) {
        _isProcessing = false;
        isSyncingNotifier.value = false;
        return;
      }

      if (kDebugMode) {
        print("[SyncEngine] Processing ${operations.length} actionable operations for tenant $tenantId");
      }

      for (final op in operations) {
        // Double check network
        if (!ConnectivityService.instance.isOnline) break;

        // Check dependency satisfaction
        if (op.dependsOnOperationId != null) {
          final parent = await _db.offlineOperationsDao.getOperationById(op.dependsOnOperationId!);
          if (parent != null) {
            if (parent.status == 'failed' || parent.status == 'cancelled') {
              // Block current operation
              await _db.offlineOperationsDao.updateOperationStatus(
                id: op.id,
                status: 'blocked',
                lastError: "Dependency operation ${parent.id} failed",
                errorCode: "dependency_failed",
              );
              continue;
            } else if (parent.status != 'synced') {
              // Parent still pending/syncing, skip for now
              continue;
            }
          }
        }

        // Handler lookup
        final handler = _handlers[op.operationType];
        if (handler == null) {
          // CRITICAL: NEVER mark unknown operations as synced!
          if (kDebugMode) {
            print("[SyncEngine] ERROR: Unknown operation type [${op.operationType}]. Marking as failed.");
          }
          await _db.offlineOperationsDao.updateOperationStatus(
            id: op.id,
            status: 'failed',
            lastError: "Unsupported operation handler: ${op.operationType}",
            errorCode: "unsupported_operation",
          );
          continue;
        }

        // Mark operation as syncing
        await _db.offlineOperationsDao.updateOperationStatus(
          id: op.id,
          status: 'syncing',
          lastAttemptAt: DateTime.now(),
        );

        try {
          final result = await handler.handle(op, _db);

          if (result.isSuccess) {
            await _db.offlineOperationsDao.updateOperationStatus(
              id: op.id,
              status: 'synced',
              syncedAt: DateTime.now(),
            );
            if (kDebugMode) {
              print("[SyncEngine] Operation ${op.id} [${op.operationType}] synced successfully.");
            }
          } else if (result.isRetryable && (op.retryCount + 1) < op.maxRetries) {
            final nextRetry = SyncRetryPolicy.calculateNextRetryTime(
              currentRetryCount: op.retryCount,
            );
            await _db.offlineOperationsDao.updateOperationStatus(
              id: op.id,
              status: 'retryWaiting',
              retryCount: op.retryCount + 1,
              nextRetryAt: nextRetry,
              lastError: result.message,
              errorCode: result.errorCode,
            );
            if (kDebugMode) {
              print("[SyncEngine] Operation ${op.id} failed temporarily. Retry ${op.retryCount + 1}/${op.maxRetries} scheduled at $nextRetry");
            }
          } else {
            // Permanent failure or max retries reached
            await _db.offlineOperationsDao.updateOperationStatus(
              id: op.id,
              status: 'failed',
              lastError: result.message,
              errorCode: result.errorCode ?? 'max_retries_exceeded',
            );
            // Cascade block dependent operations
            await _db.offlineOperationsDao.blockDependentOperations(op.id);
            if (kDebugMode) {
              print("[SyncEngine] Operation ${op.id} permanently failed: ${result.message}");
            }
          }
        } catch (e) {
          final isRetryable = op.retryCount + 1 < op.maxRetries;
          final nextRetry = isRetryable
              ? SyncRetryPolicy.calculateNextRetryTime(currentRetryCount: op.retryCount)
              : null;

          await _db.offlineOperationsDao.updateOperationStatus(
            id: op.id,
            status: isRetryable ? 'retryWaiting' : 'failed',
            retryCount: op.retryCount + 1,
            nextRetryAt: nextRetry,
            lastError: e.toString(),
            errorCode: 'execution_exception',
          );
        }
      }

      // Cleanup old synced records
      await _db.offlineOperationsDao.purgeOldSyncedOperations();

      // If any attendance operations were synced, refresh today attendance status from server
      final hasAttendanceSync = operations.any((o) => o.operationType.contains('attendance'));
      if (hasAttendanceSync && ConnectivityService.instance.isOnline) {
        try {
          await AttendanceRepository.instance.refreshTodayStatus();
        } catch (_) {}
      }

      lastSyncNotifier.value = DateTime.now();
    } catch (e) {
      if (kDebugMode) print("[SyncEngine] Exception during processQueue: $e");
    } finally {
      _isProcessing = false;
      isSyncingNotifier.value = false;
    }
  }

  /// Manually retry all failed or blocked operations
  Future<void> retryAllFailed() async {
    final tenantId = AuthService.instance.getCurrentTenantId();
    await _db.offlineOperationsDao.retryAllFailedOperations(tenantId);
    processQueue();
  }

  /// Cancel and remove an operation if safe
  Future<void> cancelOperation(String id) async {
    await _db.offlineOperationsDao.deleteOperation(id);
  }
}
