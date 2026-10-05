// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payroll_dao.dart';

// ignore_for_file: type=lint
mixin _$PayrollDaoMixin on DatabaseAccessor<AppDatabase> {
  $PayrollRecordsTableTable get payrollRecordsTable =>
      attachedDatabase.payrollRecordsTable;
  PayrollDaoManager get managers => PayrollDaoManager(this);
}

class PayrollDaoManager {
  final _$PayrollDaoMixin _db;
  PayrollDaoManager(this._db);
  $$PayrollRecordsTableTableTableManager get payrollRecordsTable =>
      $$PayrollRecordsTableTableTableManager(
          _db.attachedDatabase, _db.payrollRecordsTable);
}
