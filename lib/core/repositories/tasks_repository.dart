import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';

import 'package:auth_ui_app/core/database/app_database.dart';
import 'package:auth_ui_app/core/sync/sync_engine.dart';
import 'package:auth_ui_app/features/hrm/models/task_model.dart';
import 'package:auth_ui_app/services/auth_service.dart';
import 'package:auth_ui_app/services/hrm_api_service.dart';

class TasksRepository {
  static final TasksRepository instance = TasksRepository._internal();
  TasksRepository._internal();

  final AppDatabase _db = AppDatabase.instance;
  final _uuid = const Uuid();

  /// Watch reactive stream of local tasks for current tenant & user
  Stream<List<TasksTableData>> watchTasks() {
    final tenantId = AuthService.instance.getCurrentTenantId();
    final userId = AuthService.instance.getCurrentUserId();
    return _db.tasksDao.watchTasks(tenantId: tenantId, userId: userId);
  }

  /// Refresh tasks from Server API and reconcile with local SQLite
  Future<void> refreshTasks() async {
    final response = await HrmApiService.instance.getTodayTasks();
    if (response.isSuccess && response.data != null) {
      final tenantId = AuthService.instance.getCurrentTenantId();
      final userId = AuthService.instance.getCurrentUserId();
      final tasks = response.data!.tasks;

      final companions = tasks.map((t) {
        return TasksTableCompanion(
          localId: drift.Value("server_task_${t.id}"),
          serverId: drift.Value(t.id),
          tenantId: drift.Value(tenantId),
          userId: drift.Value(userId),
          branchId: drift.Value(t.branchId),
          taskName: drift.Value(t.taskName),
          description: drift.Value(t.description),
          isCompleted: drift.Value(t.isCompleted),
          status: drift.Value(t.status),
          completedByMe: drift.Value(t.completedByMe),
          completedByOther: drift.Value(t.completedByOther),
          completedBy: drift.Value(t.completedBy),
          completedByName: drift.Value(t.completedByName),
          completedAt: drift.Value(t.completedAt),
          notes: drift.Value(t.notes),
          managerComment: drift.Value(t.managerComment),
          approvedByName: drift.Value(t.approvedByName),
          approvedAt: drift.Value(t.approvedAt),
          canToggle: drift.Value(t.canToggle),
          syncState: const drift.Value('synced'),
          localUpdatedAt: drift.Value(DateTime.now()),
          serverUpdatedAt: drift.Value(DateTime.now()),
        );
      }).toList();

      await _db.tasksDao.reconcileServerTasks(
        tenantId: tenantId,
        userId: userId,
        serverTasks: companions,
      );
    }
  }

  /// Toggle task completion optimistically and queue sync
  Future<void> toggleTaskComplete({
    required int branchTaskId,
    String? localId,
    String? notes,
  }) async {
    final tenantId = AuthService.instance.getCurrentTenantId();
    final userId = AuthService.instance.getCurrentUserId();

    TasksTableData? task;
    if (localId != null) {
      task = await _db.tasksDao.getTaskByLocalId(localId);
    } else {
      task = await _db.tasksDao.getTaskByServerId(branchTaskId, tenantId);
    }

    final targetLocalId = task?.localId ?? localId ?? _uuid.v4();
    final newCompleted = task != null ? !task.isCompleted : true;
    final newStatus = newCompleted ? 'completed' : 'pending';

    // 1. Optimistically update local SQLite
    await _db.tasksDao.upsertTask(
      TasksTableCompanion(
        localId: drift.Value(targetLocalId),
        serverId: drift.Value(branchTaskId),
        tenantId: drift.Value(tenantId),
        userId: drift.Value(userId),
        taskName: drift.Value(task?.taskName ?? 'Task #$branchTaskId'),
        isCompleted: drift.Value(newCompleted),
        status: drift.Value(newStatus),
        completedByMe: drift.Value(newCompleted),
        notes: drift.Value(notes ?? task?.notes),
        syncState: const drift.Value('pending_sync'),
        localUpdatedAt: drift.Value(DateTime.now()),
      ),
    );

    // 2. Queue durable operation in SyncEngine
    await SyncEngine.instance.enqueueOperation(
      operationType: 'task_toggle',
      entityType: 'task',
      entityLocalId: targetLocalId,
      entityServerId: branchTaskId,
      payload: {
        'branch_task_id': branchTaskId,
        'is_completed': newCompleted,
        if (notes != null) 'notes': notes,
      },
    );
  }
}
