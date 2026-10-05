// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_dao.dart';

// ignore_for_file: type=lint
mixin _$AttendanceDaoMixin on DatabaseAccessor<AppDatabase> {
  $AttendanceTableTable get attendanceTable => attachedDatabase.attendanceTable;
  $TodayAttendanceTableTable get todayAttendanceTable =>
      attachedDatabase.todayAttendanceTable;
  AttendanceDaoManager get managers => AttendanceDaoManager(this);
}

class AttendanceDaoManager {
  final _$AttendanceDaoMixin _db;
  AttendanceDaoManager(this._db);
  $$AttendanceTableTableTableManager get attendanceTable =>
      $$AttendanceTableTableTableManager(
          _db.attachedDatabase, _db.attendanceTable);
  $$TodayAttendanceTableTableTableManager get todayAttendanceTable =>
      $$TodayAttendanceTableTableTableManager(
          _db.attachedDatabase, _db.todayAttendanceTable);
}
