import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/offline_operations_table.dart';

part 'offline_operations_dao.g.dart';

@DriftAccessor(tables: [OfflineOperations])
class OfflineOperationsDao extends DatabaseAccessor<AppDatabase> with _$OfflineOperationsDaoMixin {
  OfflineOperationsDao(super.db);

  /// Watch all operations for current tenant
  Stream<List<OfflineOperation>> watchOperationsForTenant(int tenantId) {
    return (select(offlineOperations)
          ..where((t) => t.tenantId.equals(tenantId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// Watch pending and active sync queue count
  Stream<int> watchPendingCount(int tenantId) {
    final query = select(offlineOperations)
      ..where((t) =>
          t.tenantId.equals(tenantId) &
          t.status.isNotIn(['synced', 'cancelled']));
    return query.watch().map((list) => list.length);
  }

  /// Get next batch of actionable operations (ordered by priority desc, createdAt asc)
  Future<List<OfflineOperation>> getNextActionableOperations({
    required int tenantId,
    int limit = 10,
  }) {
    final now = DateTime.now();
    return (select(offlineOperations)
          ..where((t) =>
              t.tenantId.equals(tenantId) &
              (t.status.equals('pending') |
                  (t.status.equals('retryWaiting') &
                      (t.nextRetryAt.isNull() | t.nextRetryAt.isSmallerOrEqualValue(now)))))
          ..orderBy([
            (t) => OrderingTerm.desc(t.priority),
            (t) => OrderingTerm.asc(t.createdAt),
          ])
          ..limit(limit))
        .get();
  }

  /// Get operation by ID
  Future<OfflineOperation?> getOperationById(String id) {
    return (select(offlineOperations)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Insert or replace operation (idempotent)
  Future<void> insertOperation(OfflineOperationsCompanion op) {
    return into(offlineOperations).insertOnConflictUpdate(op);
  }

  /// Update operation status
  Future<void> updateOperationStatus({
    required String id,
    required String status,
    DateTime? lastAttemptAt,
    DateTime? nextRetryAt,
    String? lastError,
    String? errorCode,
    int? retryCount,
    DateTime? syncedAt,
  }) {
    return (update(offlineOperations)..where((t) => t.id.equals(id))).write(
      OfflineOperationsCompanion(
        status: Value(status),
        updatedAt: Value(DateTime.now()),
        lastAttemptAt: lastAttemptAt != null ? Value(lastAttemptAt) : const Value.absent(),
        nextRetryAt: Value(nextRetryAt),
        lastError: Value(lastError),
        errorCode: Value(errorCode),
        retryCount: retryCount != null ? Value(retryCount) : const Value.absent(),
        syncedAt: syncedAt != null ? Value(syncedAt) : const Value.absent(),
      ),
    );
  }

  /// Recover any stale operations stuck in 'syncing' state on app launch/crash recovery
  Future<int> recoverStaleSyncingOperations(int tenantId) async {
    final updated = await (update(offlineOperations)
          ..where((t) => t.tenantId.equals(tenantId) & t.status.equals('syncing')))
        .write(
      OfflineOperationsCompanion(
        status: const Value('pending'),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return updated;
  }

  /// Block all operations depending on a failed operation
  Future<int> blockDependentOperations(String parentOperationId) {
    return (update(offlineOperations)
          ..where((t) =>
              t.dependsOnOperationId.equals(parentOperationId) &
              t.status.isIn(['pending', 'retryWaiting'])))
        .write(
      OfflineOperationsCompanion(
        status: const Value('blocked'),
        lastError: const Value('Blocked by prerequisite operation failure'),
        errorCode: const Value('dependency_failed'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Retry all failed operations for tenant
  Future<int> retryAllFailedOperations(int tenantId) {
    return (update(offlineOperations)
          ..where((t) =>
              t.tenantId.equals(tenantId) &
              (t.status.equals('failed') | t.status.equals('blocked'))))
        .write(
      OfflineOperationsCompanion(
        status: const Value('pending'),
        retryCount: const Value(0),
        nextRetryAt: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Delete synced operations older than given duration
  Future<int> purgeOldSyncedOperations({Duration olderThan = const Duration(days: 7)}) {
    final cutoff = DateTime.now().subtract(olderThan);
    return (delete(offlineOperations)
          ..where((t) => t.status.equals('synced') & t.syncedAt.isSmallerOrEqualValue(cutoff)))
        .go();
  }

  /// Delete a specific operation if cancelled
  Future<int> deleteOperation(String id) {
    return (delete(offlineOperations)..where((t) => t.id.equals(id))).go();
  }
}
