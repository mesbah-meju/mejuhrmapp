import 'package:drift/drift.dart';

class DashboardSnapshotsTable extends Table {
  IntColumn get tenantId => integer()();
  IntColumn get userId => integer()();
  TextColumn get snapshotType => text()(); // 'staff_dashboard', 'manager_dashboard'
  TextColumn get dataJson => text()();
  DateTimeColumn get fetchedAt => dateTime()();
  DateTimeColumn get expiresAt => dateTime()();

  @override
  Set<Column> get primaryKey => {tenantId, userId, snapshotType};
}
