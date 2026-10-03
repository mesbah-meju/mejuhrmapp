import 'package:drift/drift.dart';

@TableIndex(name: 'idx_ops_status_tenant', columns: {#status, #tenantId})
@TableIndex(name: 'idx_ops_next_retry', columns: {#nextRetryAt})
@TableIndex(name: 'idx_ops_created', columns: {#createdAt})
@TableIndex(name: 'idx_ops_entity_local', columns: {#entityLocalId})
@TableIndex(name: 'idx_ops_type', columns: {#operationType})
class OfflineOperations extends Table {
  TextColumn get id => text()(); // UUID client generated
  IntColumn get tenantId => integer()();
  IntColumn get userId => integer()();
  TextColumn get operationType => text()(); // 'attendance_checkin', 'attendance_checkout', 'task_toggle', etc.
  TextColumn get entityType => text()(); // 'attendance', 'task', etc.
  TextColumn get entityLocalId => text().nullable()();
  IntColumn get entityServerId => integer().nullable()();
  TextColumn get payload => text()(); // JSON String
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending, syncing, retryWaiting, synced, failed, blocked, cancelled
  IntColumn get priority => integer().withDefault(const Constant(0))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  IntColumn get maxRetries => integer().withDefault(const Constant(5))();
  DateTimeColumn get nextRetryAt => dateTime().nullable()();
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();
  TextColumn get lastError => text().nullable()();
  TextColumn get errorCode => text().nullable()();
  TextColumn get dependsOnOperationId => text().nullable()();
  TextColumn get idempotencyKey => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
