import 'package:drift/drift.dart';

import 'connection/connection.dart';
import 'daos/attendance_dao.dart';
import 'daos/dashboard_dao.dart';
import 'daos/entity_mappings_dao.dart';
import 'daos/offline_operations_dao.dart';
import 'daos/payroll_dao.dart';
import 'daos/targets_dao.dart';
import 'daos/tasks_dao.dart';
import 'daos/tenant_locations_dao.dart';
import 'daos/user_profiles_dao.dart';
import 'tables/attendance_table.dart';
import 'tables/dashboard_snapshots_table.dart';
import 'tables/entity_mappings_table.dart';
import 'tables/offline_operations_table.dart';
import 'tables/payroll_table.dart';
import 'tables/targets_table.dart';
import 'tables/tasks_table.dart';
import 'tables/tenant_locations_table.dart';
import 'tables/today_attendance_table.dart';
import 'tables/user_profiles_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    OfflineOperations,
    TasksTable,
    AttendanceTable,
    TodayAttendanceTable,
    TargetsTable,
    TenantLocationsTable,
    PayrollRecordsTable,
    DashboardSnapshotsTable,
    UserProfilesTable,
    EntityMappingsTable,
  ],
  daos: [
    OfflineOperationsDao,
    TasksDao,
    AttendanceDao,
    TargetsDao,
    TenantLocationsDao,
    PayrollDao,
    DashboardDao,
    UserProfilesDao,
    EntityMappingsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  static AppDatabase? _instance;

  static AppDatabase get instance {
    _instance ??= AppDatabase();
    return _instance!;
  }

  AppDatabase([QueryExecutor? e]) : super(e ?? openDatabaseConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Safe incremental migrations for future releases
      },
      beforeOpen: (details) async {
        // Enable foreign keys if needed
        await customStatement('PRAGMA foreign_keys = ON;');
      },
    );
  }

  /// Close database instance (e.g. for testing)
  static Future<void> resetInstance() async {
    if (_instance != null) {
      await _instance!.close();
      _instance = null;
    }
  }
}
