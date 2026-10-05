import 'package:drift/drift.dart';

@TableIndex(name: 'idx_locations_tenant', columns: {#tenantId})
class TenantLocationsTable extends Table {
  IntColumn get id => integer()();
  IntColumn get tenantId => integer()();
  TextColumn get locationName => text()();
  TextColumn get address => text().nullable()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get radiusMeters => real()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get fetchedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id, tenantId};
}
