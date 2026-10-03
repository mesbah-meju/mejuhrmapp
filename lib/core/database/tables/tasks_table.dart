import 'package:drift/drift.dart';

@TableIndex(name: 'idx_tasks_tenant_user', columns: {#tenantId, #userId})
@TableIndex(name: 'idx_tasks_status', columns: {#status})
@TableIndex(name: 'idx_tasks_sync_state', columns: {#syncState})
class TasksTable extends Table {
  TextColumn get localId => text()(); // UUID
  IntColumn get serverId => integer().nullable()();
  IntColumn get tenantId => integer()();
  IntColumn get userId => integer()();
  IntColumn get branchId => integer().nullable()();
  TextColumn get taskName => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending, completed, approved, rejected
  BoolColumn get completedByMe => boolean().withDefault(const Constant(false))();
  BoolColumn get completedByOther => boolean().withDefault(const Constant(false))();
  IntColumn get completedBy => integer().nullable()();
  TextColumn get completedByName => text().nullable()();
  TextColumn get completedAt => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get managerComment => text().nullable()();
  TextColumn get approvedByName => text().nullable()();
  TextColumn get approvedAt => text().nullable()();
  BoolColumn get canToggle => boolean().withDefault(const Constant(true))();
  TextColumn get syncState => text().withDefault(const Constant('synced'))(); // synced, pending_sync, conflict
  DateTimeColumn get localUpdatedAt => dateTime()();
  DateTimeColumn get serverUpdatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {localId};
}
