import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/tenant_locations_table.dart';

part 'tenant_locations_dao.g.dart';

@DriftAccessor(tables: [TenantLocationsTable])
class TenantLocationsDao extends DatabaseAccessor<AppDatabase> with _$TenantLocationsDaoMixin {
  TenantLocationsDao(super.db);

  Stream<List<TenantLocationsTableData>> watchLocations(int tenantId) {
    return (select(tenantLocationsTable)
          ..where((t) => t.tenantId.equals(tenantId) & t.isActive.equals(true)))
        .watch();
  }

  Future<List<TenantLocationsTableData>> getLocations(int tenantId) {
    return (select(tenantLocationsTable)
          ..where((t) => t.tenantId.equals(tenantId) & t.isActive.equals(true)))
        .get();
  }

  Future<void> replaceLocations(int tenantId, List<TenantLocationsTableCompanion> locations) async {
    await transaction(() async {
      await (delete(tenantLocationsTable)..where((t) => t.tenantId.equals(tenantId))).go();
      for (final loc in locations) {
        await into(tenantLocationsTable).insert(loc);
      }
    });
  }
}
