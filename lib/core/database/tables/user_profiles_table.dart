import 'package:drift/drift.dart';

class UserProfilesTable extends Table {
  IntColumn get userId => integer()();
  IntColumn get tenantId => integer()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get employeeCode => text().nullable()();
  TextColumn get role => text()();
  TextColumn get department => text().nullable()();
  TextColumn get designation => text().nullable()();
  TextColumn get branchName => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get loginType => text()();
  TextColumn get rawUserJson => text().nullable()();
  TextColumn get rawEmployeeJson => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {userId, tenantId};
}
