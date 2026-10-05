// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_dao.dart';

// ignore_for_file: type=lint
mixin _$DashboardDaoMixin on DatabaseAccessor<AppDatabase> {
  $DashboardSnapshotsTableTable get dashboardSnapshotsTable =>
      attachedDatabase.dashboardSnapshotsTable;
  DashboardDaoManager get managers => DashboardDaoManager(this);
}

class DashboardDaoManager {
  final _$DashboardDaoMixin _db;
  DashboardDaoManager(this._db);
  $$DashboardSnapshotsTableTableTableManager get dashboardSnapshotsTable =>
      $$DashboardSnapshotsTableTableTableManager(
          _db.attachedDatabase, _db.dashboardSnapshotsTable);
}
