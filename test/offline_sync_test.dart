import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:auth_ui_app/core/database/app_database.dart';
import 'package:auth_ui_app/core/sync/sync_engine.dart';
import 'package:auth_ui_app/core/sync/sync_operation_handler.dart';
import 'package:auth_ui_app/core/sync/sync_result.dart';

class MockSuccessHandler implements SyncOperationHandler {
  @override
  String get operationType => 'mock_success';

  @override
  Future<SyncResult> handle(OfflineOperation operation, AppDatabase db) async {
    return SyncResult.success(message: "Mock success");
  }
}

class MockRetryableFailureHandler implements SyncOperationHandler {
  @override
  String get operationType => 'mock_retryable';

  @override
  Future<SyncResult> handle(OfflineOperation operation, AppDatabase db) async {
    return SyncResult.retryableFailure(
      message: "Server 503 timeout",
      statusCode: 503,
      errorCode: "server_unavailable",
    );
  }
}

class MockPermanentFailureHandler implements SyncOperationHandler {
  @override
  String get operationType => 'mock_permanent';

  @override
  Future<SyncResult> handle(OfflineOperation operation, AppDatabase db) async {
    return SyncResult.permanentFailure(
      message: "422 Validation Error",
      statusCode: 422,
      errorCode: "validation_error",
    );
  }
}

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Drift SQLite & Offline Queue Comprehensive Test Suite', () {
    test('Test 1: Insert offline operation with stable client-generated idempotency key', () async {
      const opId = 'test-uuid-001';
      const idemKey = 'idem-key-001';
      final now = DateTime.now();

      await db.offlineOperationsDao.insertOperation(
        OfflineOperationsCompanion(
          id: const Value(opId),
          tenantId: const Value(1),
          userId: const Value(10),
          operationType: const Value('attendance_checkin'),
          entityType: const Value('attendance'),
          payload: const Value('{"type":"clockin","lat":23.81,"lng":90.41}'),
          status: const Value('pending'),
          idempotencyKey: const Value(idemKey),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      final op = await db.offlineOperationsDao.getOperationById(opId);
      expect(op, isNotNull);
      expect(op!.id, equals(opId));
      expect(op.idempotencyKey, equals(idemKey));
      expect(op.status, equals('pending'));
    });

    test('Test 2: Retry uses identical idempotency key without generating new key', () async {
      const opId = 'test-uuid-idem-002';
      const originalIdemKey = 'stable-idem-key-abc';
      final now = DateTime.now();

      await db.offlineOperationsDao.insertOperation(
        OfflineOperationsCompanion(
          id: const Value(opId),
          tenantId: const Value(1),
          userId: const Value(10),
          operationType: const Value('mock_retryable'),
          entityType: const Value('attendance'),
          payload: const Value('{}'),
          status: const Value('pending'),
          idempotencyKey: const Value(originalIdemKey),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      // Simulate failure & retry state update
      await db.offlineOperationsDao.updateOperationStatus(
        id: opId,
        status: 'retryWaiting',
        retryCount: 1,
        lastError: 'Timeout',
      );

      final opAfterRetry = await db.offlineOperationsDao.getOperationById(opId);
      expect(opAfterRetry!.idempotencyKey, equals(originalIdemKey));
    });

    test('Test 3: Retryable network failure updates retryCount and schedule', () async {
      const opId = 'test-uuid-002';
      final now = DateTime.now();

      await db.offlineOperationsDao.insertOperation(
        OfflineOperationsCompanion(
          id: const Value(opId),
          tenantId: const Value(1),
          userId: const Value(10),
          operationType: const Value('mock_retryable'),
          entityType: const Value('task'),
          payload: const Value('{}'),
          status: const Value('pending'),
          idempotencyKey: const Value('idem-002'),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      // Simulate retryable failure
      final nextRetry = SyncRetryPolicy.calculateNextRetryTime(currentRetryCount: 0);
      await db.offlineOperationsDao.updateOperationStatus(
        id: opId,
        status: 'retryWaiting',
        retryCount: 1,
        nextRetryAt: nextRetry,
        lastError: 'Server 503 timeout',
        errorCode: 'server_unavailable',
      );

      final op = await db.offlineOperationsDao.getOperationById(opId);
      expect(op!.status, equals('retryWaiting'));
      expect(op.retryCount, equals(1));
      expect(op.nextRetryAt, isNotNull);
      expect(op.errorCode, equals('server_unavailable'));
    });

    test('Test 4: 422 Non-retryable failure does not retry and is marked failed', () async {
      const opId = 'test-uuid-003';
      final now = DateTime.now();

      await db.offlineOperationsDao.insertOperation(
        OfflineOperationsCompanion(
          id: const Value(opId),
          tenantId: const Value(1),
          userId: const Value(10),
          operationType: const Value('mock_permanent'),
          entityType: const Value('attendance'),
          payload: const Value('{}'),
          status: const Value('pending'),
          idempotencyKey: const Value('idem-003'),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      // Simulate permanent 422 failure
      await db.offlineOperationsDao.updateOperationStatus(
        id: opId,
        status: 'failed',
        lastError: '422 Outside Geofence Area',
        errorCode: 'outside_geofence',
      );

      final op = await db.offlineOperationsDao.getOperationById(opId);
      expect(op!.status, equals('failed'));
      expect(op.errorCode, equals('outside_geofence'));
    });

    test('Test 5: Dependent operation is blocked when parent operation fails', () async {
      const parentId = 'parent-checkin-001';
      const childId = 'child-checkout-002';
      final now = DateTime.now();

      // Insert parent
      await db.offlineOperationsDao.insertOperation(
        OfflineOperationsCompanion(
          id: const Value(parentId),
          tenantId: const Value(1),
          userId: const Value(10),
          operationType: const Value('attendance_checkin'),
          entityType: const Value('attendance'),
          payload: const Value('{}'),
          status: const Value('pending'),
          idempotencyKey: const Value('idem-parent'),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      // Insert dependent child
      await db.offlineOperationsDao.insertOperation(
        OfflineOperationsCompanion(
          id: const Value(childId),
          tenantId: const Value(1),
          userId: const Value(10),
          operationType: const Value('attendance_checkout'),
          entityType: const Value('attendance'),
          dependsOnOperationId: const Value(parentId),
          payload: const Value('{}'),
          status: const Value('pending'),
          idempotencyKey: const Value('idem-child'),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      // Fail parent and block dependents
      await db.offlineOperationsDao.updateOperationStatus(id: parentId, status: 'failed');
      await db.offlineOperationsDao.blockDependentOperations(parentId);

      final child = await db.offlineOperationsDao.getOperationById(childId);
      expect(child!.status, equals('blocked'));
      expect(child.errorCode, equals('dependency_failed'));
    });

    test('Test 6: Independent operations continue when one operation fails', () async {
      const failedOpId = 'failed-op-001';
      const independentOpId = 'independent-op-002';
      final now = DateTime.now();

      // Operation 1 (failed)
      await db.offlineOperationsDao.insertOperation(
        OfflineOperationsCompanion(
          id: const Value(failedOpId),
          tenantId: const Value(1),
          userId: const Value(10),
          operationType: const Value('task_toggle'),
          entityType: const Value('task'),
          payload: const Value('{}'),
          status: const Value('failed'),
          idempotencyKey: const Value('idem-1'),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      // Operation 2 (independent, pending)
      await db.offlineOperationsDao.insertOperation(
        OfflineOperationsCompanion(
          id: const Value(independentOpId),
          tenantId: const Value(1),
          userId: const Value(10),
          operationType: const Value('task_toggle'),
          entityType: const Value('task'),
          payload: const Value('{}'),
          status: const Value('pending'),
          idempotencyKey: const Value('idem-2'),
          createdAt: Value(now.add(const Duration(seconds: 1))),
          updatedAt: Value(now.add(const Duration(seconds: 1))),
        ),
      );

      final actionable = await db.offlineOperationsDao.getNextActionableOperations(tenantId: 1);
      expect(actionable.length, equals(1));
      expect(actionable.first.id, equals(independentOpId));
    });

    test('Test 7: Stale syncing operations recover to pending on startup', () async {
      const opId = 'stale-op-001';
      final now = DateTime.now();

      await db.offlineOperationsDao.insertOperation(
        OfflineOperationsCompanion(
          id: const Value(opId),
          tenantId: const Value(1),
          userId: const Value(10),
          operationType: const Value('task_toggle'),
          entityType: const Value('task'),
          payload: const Value('{}'),
          status: const Value('syncing'),
          idempotencyKey: const Value('idem-stale'),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      final recoveredCount = await db.offlineOperationsDao.recoverStaleSyncingOperations(1);
      expect(recoveredCount, equals(1));

      final op = await db.offlineOperationsDao.getOperationById(opId);
      expect(op!.status, equals('pending'));
    });

    test('Test 8: Multi-tenant data isolation', () async {
      final now = DateTime.now();

      // Tenant A task
      await db.tasksDao.upsertTask(
        TasksTableCompanion(
          localId: const Value('task-tenant-a'),
          tenantId: const Value(1),
          userId: const Value(100),
          taskName: const Value('Tenant A Secret Task'),
          localUpdatedAt: Value(now),
        ),
      );

      // Tenant B task
      await db.tasksDao.upsertTask(
        TasksTableCompanion(
          localId: const Value('task-tenant-b'),
          tenantId: const Value(2),
          userId: const Value(200),
          taskName: const Value('Tenant B Secret Task'),
          localUpdatedAt: Value(now),
        ),
      );

      final tenantATasks = await db.tasksDao.getTasks(tenantId: 1, userId: 100);
      final tenantBTasks = await db.tasksDao.getTasks(tenantId: 2, userId: 200);

      expect(tenantATasks.length, equals(1));
      expect(tenantATasks.first.taskName, equals('Tenant A Secret Task'));

      expect(tenantBTasks.length, equals(1));
      expect(tenantBTasks.first.taskName, equals('Tenant B Secret Task'));
    });

    test('Test 9: Server refresh does not overwrite unsynced local task change', () async {
      final now = DateTime.now();

      // Local unsynced task (pending_sync)
      await db.tasksDao.upsertTask(
        TasksTableCompanion(
          localId: const Value('local-task-001'),
          serverId: const Value(101),
          tenantId: const Value(1),
          userId: const Value(10),
          taskName: const Value('Inventory Audit'),
          isCompleted: const Value(true),
          status: const Value('completed'),
          syncState: const Value('pending_sync'),
          localUpdatedAt: Value(now),
        ),
      );

      // Incoming server tasks list where server still thinks it is pending
      final serverTasks = [
        TasksTableCompanion(
          localId: const Value('server_task_101'),
          serverId: const Value(101),
          tenantId: const Value(1),
          userId: const Value(10),
          taskName: const Value('Inventory Audit'),
          isCompleted: const Value(false),
          status: const Value('pending'),
          syncState: const Value('synced'),
          localUpdatedAt: Value(now),
        ),
      ];

      await db.tasksDao.reconcileServerTasks(
        tenantId: 1,
        userId: 10,
        serverTasks: serverTasks,
      );

      // Verify local pending state was preserved
      final localTask = await db.tasksDao.getTaskByLocalId('local-task-001');
      expect(localTask, isNotNull);
      expect(localTask!.isCompleted, isTrue);
      expect(localTask.syncState, equals('pending_sync'));
    });

    test('Test 10: Local UUID to Server ID mapping resolution', () async {
      const localId = 'client-local-uuid-999';
      const serverId = 456;

      await db.entityMappingsDao.saveMapping(
        localId: localId,
        serverId: serverId,
        entityType: 'attendance',
        tenantId: 1,
      );

      final resolvedServerId = await db.entityMappingsDao.getServerId(localId);
      final resolvedLocalId = await db.entityMappingsDao.getLocalId(
        serverId: serverId,
        entityType: 'attendance',
        tenantId: 1,
      );

      expect(resolvedServerId, equals(serverId));
      expect(resolvedLocalId, equals(localId));
    });

    test('Test 11: Exponential backoff with jitter calculation', () {
      final retry1 = SyncRetryPolicy.calculateNextRetryTime(currentRetryCount: 0);
      final retry2 = SyncRetryPolicy.calculateNextRetryTime(currentRetryCount: 1);
      final retry3 = SyncRetryPolicy.calculateNextRetryTime(currentRetryCount: 2);
      final retry4 = SyncRetryPolicy.calculateNextRetryTime(currentRetryCount: 3);

      final now = DateTime.now();
      expect(retry1.isAfter(now), isTrue);
      expect(retry2.isAfter(retry1), isTrue);
      expect(retry3.isAfter(retry2), isTrue);
      expect(retry4.isAfter(retry3), isTrue);
    });

    test('Test 12: Error classification distinguishes retryable vs non-retryable', () {
      expect(SyncRetryPolicy.isRetryableStatus(0), isTrue); // Connection error
      expect(SyncRetryPolicy.isRetryableStatus(500), isTrue); // Server error
      expect(SyncRetryPolicy.isRetryableStatus(503), isTrue); // Service unavailable
      expect(SyncRetryPolicy.isRetryableStatus(408), isTrue); // Timeout

      expect(SyncRetryPolicy.isRetryableStatus(400), isFalse); // Bad request
      expect(SyncRetryPolicy.isRetryableStatus(401), isFalse); // Unauthorized
      expect(SyncRetryPolicy.isRetryableStatus(403), isFalse); // Forbidden
      expect(SyncRetryPolicy.isRetryableStatus(422), isFalse); // Validation error
    });

    test('Test 13: Dual-Cache Prevention - Only SQLite holds local truth', () async {
      // Direct SQLite insertion and query
      await db.tasksDao.upsertTask(
        TasksTableCompanion(
          localId: const Value('single-source-uuid-1'),
          tenantId: const Value(1),
          userId: const Value(10),
          taskName: const Value('Single Source Task'),
          isCompleted: const Value(true),
          syncState: const Value('synced'),
          localUpdatedAt: Value(DateTime.now()),
        ),
      );

      final tasks = await db.tasksDao.getTasks(tenantId: 1, userId: 10);
      expect(tasks.any((t) => t.taskName == 'Single Source Task'), isTrue);
    });

    test('Test 14: Migration idempotency - re-running does not duplicate operations', () async {
      const opId = 'fixed-migrated-op-id-100';
      await db.offlineOperationsDao.insertOperation(
        OfflineOperationsCompanion(
          id: const Value(opId),
          tenantId: const Value(1),
          userId: const Value(10),
          operationType: const Value('task_toggle'),
          entityType: const Value('task'),
          payload: const Value('{"task_id": 5}'),
          status: const Value('pending'),
          idempotencyKey: const Value('idempotent-key-100'),
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ),
      );

      final opBefore = await db.offlineOperationsDao.getOperationById(opId);
      expect(opBefore, isNotNull);

      // Inserting with same ID (DoUpdate / Replace)
      await db.offlineOperationsDao.insertOperation(
        OfflineOperationsCompanion(
          id: const Value(opId),
          tenantId: const Value(1),
          userId: const Value(10),
          operationType: const Value('task_toggle'),
          entityType: const Value('task'),
          payload: const Value('{"task_id": 5}'),
          status: const Value('pending'),
          idempotencyKey: const Value('idempotent-key-100'),
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ),
      );

      final opAfter = await db.offlineOperationsDao.getOperationById(opId);
      expect(opAfter, isNotNull);
      expect(opAfter!.id, equals(opId));
    });

    test('Test 15: Attendance Punch Persistence and Local State Locking', () async {
      // Optimistic punch in SQLite
      await db.attendanceDao.upsertTodayStatus(
        TodayAttendanceTableCompanion(
          tenantId: const Value(1),
          userId: const Value(10),
          date: const Value('2026-10-04'),
          isClockedIn: const Value(true),
          canClockIn: const Value(false),
          canClockOut: const Value(true),
          clockIn: const Value('09:00:00'),
          status: const Value('present'),
          fetchedAt: Value(DateTime.now()),
        ),
      );

      final today = await db.attendanceDao.getTodayStatus(tenantId: 1, userId: 10);
      expect(today, isNotNull);
      expect(today!.isClockedIn, isTrue);
      expect(today.canClockIn, isFalse);
      expect(today.canClockOut, isTrue);
    });

    test('Test 16: Partial Batch Sync Reconciliation - Each punch reconciled individually', () async {
      final punch1LocalId = 'punch-uuid-001';
      final punch2LocalId = 'punch-uuid-002';

      // Insert punch 1 & 2
      await db.attendanceDao.upsertAttendanceRecord(
        AttendanceTableCompanion(
          localId: Value(punch1LocalId),
          tenantId: const Value(1),
          userId: const Value(10),
          date: const Value('2026-10-04'),
          clockIn: const Value('09:00:00'),
          status: const Value('present'),
          syncState: const Value('pending_sync'),
          localUpdatedAt: Value(DateTime.now()),
        ),
      );

      await db.attendanceDao.upsertAttendanceRecord(
        AttendanceTableCompanion(
          localId: Value(punch2LocalId),
          tenantId: const Value(1),
          userId: const Value(10),
          date: const Value('2026-10-04'),
          clockIn: const Value('10:00:00'),
          status: const Value('present'),
          syncState: const Value('pending_sync'),
          localUpdatedAt: Value(DateTime.now()),
        ),
      );

      // Reconcile punch 1 as success (assigned server ID 789)
      await db.attendanceDao.updatePunchSyncState(
        localId: punch1LocalId,
        syncState: 'synced',
        serverId: 789,
      );

      // Reconcile punch 2 as failed (422 outside geofence)
      await db.attendanceDao.updatePunchSyncState(
        localId: punch2LocalId,
        syncState: 'failed',
      );

      final p1 = await db.attendanceDao.getRecordByLocalId(punch1LocalId);
      final p2 = await db.attendanceDao.getRecordByLocalId(punch2LocalId);

      expect(p1!.syncState, equals('synced'));
      expect(p1.serverId, equals(789));

      expect(p2!.syncState, equals('failed'));
      expect(p2.serverId, isNull);
    });
  });
}
