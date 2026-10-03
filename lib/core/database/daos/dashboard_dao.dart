import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/dashboard_snapshots_table.dart';

part 'dashboard_dao.g.dart';

@DriftAccessor(tables: [DashboardSnapshotsTable])
class DashboardDao extends DatabaseAccessor<AppDatabase> with _$DashboardDaoMixin {
  DashboardDao(super.db);

  Stream<DashboardSnapshotsTableData?> watchSnapshot({
    required int tenantId,
    required int userId,
    required String snapshotType,
  }) {
    return (select(dashboardSnapshotsTable)
          ..where((t) =>
              t.tenantId.equals(tenantId) &
              t.userId.equals(userId) &
              t.snapshotType.equals(snapshotType)))
        .watchSingleOrNull();
  }

  Future<DashboardSnapshotsTableData?> getSnapshot({
    required int tenantId,
    required int userId,
    required String snapshotType,
  }) {
    return (select(dashboardSnapshotsTable)
          ..where((t) =>
              t.tenantId.equals(tenantId) &
              t.userId.equals(userId) &
              t.snapshotType.equals(snapshotType)))
        .getSingleOrNull();
  }

  Future<void> saveSnapshot(DashboardSnapshotsTableCompanion snapshot) {
    return into(dashboardSnapshotsTable).insertOnConflictUpdate(snapshot);
  }
}
