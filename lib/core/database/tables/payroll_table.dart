import 'package:drift/drift.dart';

@TableIndex(name: 'idx_payroll_tenant_user', columns: {#tenantId, #userId})
class PayrollRecordsTable extends Table {
  IntColumn get id => integer()();
  IntColumn get tenantId => integer()();
  IntColumn get userId => integer()();
  IntColumn get month => integer()();
  IntColumn get year => integer()();
  RealColumn get netSalary => real()();
  RealColumn get grossSalary => real()();
  RealColumn get deductions => real()();
  RealColumn get allowances => real()();
  TextColumn get status => text()();
  TextColumn get payslipUrl => text().nullable()();
  TextColumn get detailsJson => text().nullable()();
  DateTimeColumn get fetchedAt => dateTime()();
  DateTimeColumn get expiresAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id, tenantId};
}
