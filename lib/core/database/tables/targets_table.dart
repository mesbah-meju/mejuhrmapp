import 'package:drift/drift.dart';

@TableIndex(name: 'idx_targets_tenant_user', columns: {#tenantId, #userId})
class TargetsTable extends Table {
  TextColumn get localId => text()();
  IntColumn get serverId => integer().nullable()();
  IntColumn get tenantId => integer()();
  IntColumn get userId => integer()();
  TextColumn get title => text()();
  TextColumn get targetType => text()();
  RealColumn get targetValue => real()();
  RealColumn get achievedValue => real()();
  RealColumn get progress => real()();
  TextColumn get unit => text().nullable()();
  TextColumn get startDate => text().nullable()();
  TextColumn get endDate => text().nullable()();
  TextColumn get status => text()();
  TextColumn get notes => text().nullable()();
  TextColumn get syncState => text().withDefault(const Constant('synced'))();
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {localId};
}
