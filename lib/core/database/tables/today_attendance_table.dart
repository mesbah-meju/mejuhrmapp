import 'package:drift/drift.dart';

class TodayAttendanceTable extends Table {
  IntColumn get tenantId => integer()();
  IntColumn get userId => integer()();
  TextColumn get date => text()();
  BoolColumn get isClockedIn => boolean().withDefault(const Constant(false))();
  BoolColumn get canClockIn => boolean().withDefault(const Constant(true))();
  BoolColumn get canClockOut => boolean().withDefault(const Constant(false))();
  IntColumn get attendanceId => integer().nullable()();
  TextColumn get clockIn => text().nullable()();
  TextColumn get clockOut => text().nullable()();
  TextColumn get totalHours => text().withDefault(const Constant('0.00 hours'))();
  RealColumn get totalHoursNumeric => real().withDefault(const Constant(0.0))();
  TextColumn get breakHours => text().nullable()();
  TextColumn get overtimeHours => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('present'))();
  BoolColumn get isWorkingDay => boolean().withDefault(const Constant(true))();
  BoolColumn get isHoliday => boolean().withDefault(const Constant(false))();
  TextColumn get holidayName => text().nullable()();
  BoolColumn get isOnLeave => boolean().withDefault(const Constant(false))();
  BoolColumn get isHalfDayLeave => boolean().withDefault(const Constant(false))();
  TextColumn get leaveTitle => text().nullable()();
  TextColumn get checkInLocationJson => text().nullable()();
  TextColumn get checkInBranchJson => text().nullable()();
  TextColumn get shiftJson => text().nullable()();
  TextColumn get workingDaysMapJson => text().nullable()();
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {tenantId, userId};
}
