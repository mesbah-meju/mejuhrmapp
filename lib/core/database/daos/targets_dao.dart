import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/targets_table.dart';

part 'targets_dao.g.dart';

@DriftAccessor(tables: [TargetsTable])
class TargetsDao extends DatabaseAccessor<AppDatabase> with _$TargetsDaoMixin {
  TargetsDao(super.db);

  Stream<List<TargetsTableData>> watchTargets({required int tenantId, required int userId}) {
    return (select(targetsTable)
          ..where((t) => t.tenantId.equals(tenantId) & t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.asc(t.title)]))
        .watch();
  }

  Future<void> replaceTargets({
    required int tenantId,
    required int userId,
    required List<TargetsTableCompanion> targets,
  }) async {
    await transaction(() async {
      await (delete(targetsTable)
            ..where((t) => t.tenantId.equals(tenantId) & t.userId.equals(userId)))
          .go();
      for (final t in targets) {
        await into(targetsTable).insert(t);
      }
    });
  }
}
