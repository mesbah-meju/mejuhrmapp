import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/payroll_table.dart';

part 'payroll_dao.g.dart';

@DriftAccessor(tables: [PayrollRecordsTable])
class PayrollDao extends DatabaseAccessor<AppDatabase> with _$PayrollDaoMixin {
  PayrollDao(super.db);

  Stream<List<PayrollRecordsTableData>> watchPayrollRecords({required int tenantId, required int userId}) {
    return (select(payrollRecordsTable)
          ..where((t) => t.tenantId.equals(tenantId) & t.userId.equals(userId))
          ..orderBy([
            (t) => OrderingTerm.desc(t.year),
            (t) => OrderingTerm.desc(t.month),
          ]))
        .watch();
  }

  Future<void> replacePayrollRecords({
    required int tenantId,
    required int userId,
    required List<PayrollRecordsTableCompanion> records,
  }) async {
    await transaction(() async {
      await (delete(payrollRecordsTable)
            ..where((t) => t.tenantId.equals(tenantId) & t.userId.equals(userId)))
          .go();
      for (final r in records) {
        await into(payrollRecordsTable).insert(r);
      }
    });
  }
}
