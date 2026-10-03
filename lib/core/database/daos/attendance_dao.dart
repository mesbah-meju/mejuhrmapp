import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/attendance_table.dart';
import '../tables/today_attendance_table.dart';

part 'attendance_dao.g.dart';

@DriftAccessor(tables: [AttendanceTable, TodayAttendanceTable])
class AttendanceDao extends DatabaseAccessor<AppDatabase> with _$AttendanceDaoMixin {
  AttendanceDao(super.db);

  /// Watch Today Attendance Status for current tenant & user
  Stream<TodayAttendanceTableData?> watchTodayStatus({required int tenantId, required int userId}) {
    return (select(todayAttendanceTable)
          ..where((t) => t.tenantId.equals(tenantId) & t.userId.equals(userId)))
        .watchSingleOrNull();
  }

  /// Get Today Attendance Status directly
  Future<TodayAttendanceTableData?> getTodayStatus({required int tenantId, required int userId}) {
    return (select(todayAttendanceTable)
          ..where((t) => t.tenantId.equals(tenantId) & t.userId.equals(userId)))
        .getSingleOrNull();
  }

  /// Upsert Today Attendance Status
  Future<void> upsertTodayStatus(TodayAttendanceTableCompanion status) {
    return into(todayAttendanceTable).insertOnConflictUpdate(status);
  }

  /// Watch Attendance History Records for a given month/year
  Stream<List<AttendanceTableData>> watchAttendanceHistory({
    required int tenantId,
    required int userId,
    required String monthPrefix, // e.g. "2026-10"
  }) {
    return (select(attendanceTable)
          ..where((t) =>
              t.tenantId.equals(tenantId) &
              t.userId.equals(userId) &
              t.date.like('$monthPrefix%'))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  /// Upsert Attendance Record
  Future<void> upsertAttendanceRecord(AttendanceTableCompanion record) {
    return into(attendanceTable).insertOnConflictUpdate(record);
  }

  /// Batch Reconcile Server Attendance History
  Future<void> reconcileServerHistory({
    required int tenantId,
    required int userId,
    required List<AttendanceTableCompanion> serverRecords,
  }) async {
    await transaction(() async {
      for (final record in serverRecords) {
        final dateVal = record.date.value;
        final existing = await (select(attendanceTable)
              ..where((t) =>
                  t.tenantId.equals(tenantId) &
                  t.userId.equals(userId) &
                  t.date.equals(dateVal)))
            .getSingleOrNull();

        if (existing != null) {
          if (existing.syncState != 'pending_sync') {
            await (update(attendanceTable)..where((t) => t.localId.equals(existing.localId)))
                .write(record.copyWith(localId: Value(existing.localId)));
          }
        } else {
          await into(attendanceTable).insertOnConflictUpdate(record);
        }
      }
    });
  }

  /// Update punch sync state
  Future<void> updatePunchSyncState({
    required String localId,
    required String syncState,
    int? serverId,
  }) {
    return (update(attendanceTable)..where((t) => t.localId.equals(localId))).write(
      AttendanceTableCompanion(
        syncState: Value(syncState),
        serverId: serverId != null ? Value(serverId) : const Value.absent(),
        localUpdatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Get attendance record by local UUID
  Future<AttendanceTableData?> getRecordByLocalId(String localId) {
    return (select(attendanceTable)..where((t) => t.localId.equals(localId))).getSingleOrNull();
  }
}
