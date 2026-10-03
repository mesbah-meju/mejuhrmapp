import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/tasks_table.dart';

part 'tasks_dao.g.dart';

@DriftAccessor(tables: [TasksTable])
class TasksDao extends DatabaseAccessor<AppDatabase> with _$TasksDaoMixin {
  TasksDao(super.db);

  /// Watch tasks for tenant and user
  Stream<List<TasksTableData>> watchTasks({required int tenantId, required int userId}) {
    return (select(tasksTable)
          ..where((t) => t.tenantId.equals(tenantId) & t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.asc(t.taskName)]))
        .watch();
  }

  /// Get tasks list directly
  Future<List<TasksTableData>> getTasks({required int tenantId, required int userId}) {
    return (select(tasksTable)
          ..where((t) => t.tenantId.equals(tenantId) & t.userId.equals(userId)))
        .get();
  }

  /// Get single task by local UUID
  Future<TasksTableData?> getTaskByLocalId(String localId) {
    return (select(tasksTable)..where((t) => t.localId.equals(localId))).getSingleOrNull();
  }

  /// Get single task by server ID
  Future<TasksTableData?> getTaskByServerId(int serverId, int tenantId) {
    return (select(tasksTable)
          ..where((t) => t.serverId.equals(serverId) & t.tenantId.equals(tenantId)))
        .getSingleOrNull();
  }

  /// Upsert task record
  Future<void> upsertTask(TasksTableCompanion task) {
    return into(tasksTable).insertOnConflictUpdate(task);
  }

  /// Batch reconcile server tasks without clobbering unsynced local changes
  Future<void> reconcileServerTasks({
    required int tenantId,
    required int userId,
    required List<TasksTableCompanion> serverTasks,
  }) async {
    await transaction(() async {
      final localPendingTasks = await (select(tasksTable)
            ..where((t) =>
                t.tenantId.equals(tenantId) &
                t.userId.equals(userId) &
                t.syncState.equals('pending_sync')))
          .get();

      final pendingServerIds = localPendingTasks.map((t) => t.serverId).whereType<int>().toSet();
      final pendingLocalIds = localPendingTasks.map((t) => t.localId).toSet();

      for (final sTask in serverTasks) {
        final serverIdVal = sTask.serverId.value;
        if (serverIdVal != null && pendingServerIds.contains(serverIdVal)) {
          // Keep local pending state to avoid losing optimistic work
          continue;
        }

        // Look up by serverId first
        if (serverIdVal != null) {
          final existing = await (select(tasksTable)
                ..where((t) => t.serverId.equals(serverIdVal) & t.tenantId.equals(tenantId)))
              .getSingleOrNull();

          if (existing != null) {
            if (!pendingLocalIds.contains(existing.localId)) {
              await (update(tasksTable)..where((t) => t.localId.equals(existing.localId)))
                  .write(sTask.copyWith(localId: Value(existing.localId)));
            }
            continue;
          }
        }

        // Insert new task from server
        await into(tasksTable).insertOnConflictUpdate(sTask);
      }
    });
  }

  /// Optimistically update completion state
  Future<void> updateCompletionState({
    required String localId,
    required bool isCompleted,
    required String status,
    String? notes,
    required String syncState,
  }) {
    return (update(tasksTable)..where((t) => t.localId.equals(localId))).write(
      TasksTableCompanion(
        isCompleted: Value(isCompleted),
        status: Value(status),
        completedByMe: Value(isCompleted),
        notes: Value(notes),
        syncState: Value(syncState),
        localUpdatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Clear tasks for tenant/user
  Future<int> clearTasks({required int tenantId, required int userId}) {
    return (delete(tasksTable)
          ..where((t) => t.tenantId.equals(tenantId) & t.userId.equals(userId)))
        .go();
  }
}
