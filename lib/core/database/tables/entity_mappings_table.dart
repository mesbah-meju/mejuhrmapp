import 'package:drift/drift.dart';

@TableIndex(name: 'idx_mappings_server', columns: {#serverId, #entityType, #tenantId})
class EntityMappingsTable extends Table {
  TextColumn get localId => text()();
  IntColumn get serverId => integer()();
  TextColumn get entityType => text()(); // 'task', 'attendance', etc.
  IntColumn get tenantId => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {localId};
}
