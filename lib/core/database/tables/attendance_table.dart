import 'package:drift/drift.dart';

@TableIndex(name: 'idx_att_tenant_user_date', columns: {#tenantId, #userId, #date})
@TableIndex(name: 'idx_att_sync_state', columns: {#syncState})
class AttendanceTable extends Table {
  TextColumn get localId => text()(); // UUID
  IntColumn get serverId => integer().nullable()();
  IntColumn get tenantId => integer()();
  IntColumn get userId => integer()();
  TextColumn get date => text()(); // YYYY-MM-DD
  TextColumn get clockIn => text().nullable()();
  TextColumn get clockOut => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('present'))();
  TextColumn get calculatedStatus => text().nullable()();
  BoolColumn get isLate => boolean().withDefault(const Constant(false))();
  BoolColumn get isEarly => boolean().withDefault(const Constant(false))();
  TextColumn get totalHours => text().withDefault(const Constant('0.00 hours'))();
  RealColumn get totalHoursNumeric => real().withDefault(const Constant(0.0))();
  TextColumn get breakHours => text().nullable()();
  RealColumn get breakHoursNumeric => real().withDefault(const Constant(0.0))();
  TextColumn get overtimeHours => text().nullable()();
  RealColumn get overtimeHoursNumeric => real().withDefault(const Constant(0.0))();
  RealColumn get overtimeAmount => real().withDefault(const Constant(0.0))();
  TextColumn get notes => text().nullable()();
  TextColumn get checkInLocationJson => text().nullable()();
  TextColumn get checkOutLocationJson => text().nullable()();
  TextColumn get checkInBranchJson => text().nullable()();
  TextColumn get checkOutBranchJson => text().nullable()();
  TextColumn get shiftJson => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  RealColumn get accuracy => real().nullable()();
  TextColumn get syncState => text().withDefault(const Constant('synced'))(); // synced, pending_sync, conflict, failed
  DateTimeColumn get localUpdatedAt => dateTime()();
  DateTimeColumn get serverUpdatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {localId};
}
