import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/entity_mappings_table.dart';

part 'entity_mappings_dao.g.dart';

@DriftAccessor(tables: [EntityMappingsTable])
class EntityMappingsDao extends DatabaseAccessor<AppDatabase> with _$EntityMappingsDaoMixin {
  EntityMappingsDao(super.db);

  Future<void> saveMapping({
    required String localId,
    required int serverId,
    required String entityType,
    required int tenantId,
  }) {
    return into(entityMappingsTable).insertOnConflictUpdate(
      EntityMappingsTableCompanion(
        localId: Value(localId),
        serverId: Value(serverId),
        entityType: Value(entityType),
        tenantId: Value(tenantId),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int?> getServerId(String localId) async {
    final mapping = await (select(entityMappingsTable)..where((t) => t.localId.equals(localId))).getSingleOrNull();
    return mapping?.serverId;
  }

  Future<String?> getLocalId({
    required int serverId,
    required String entityType,
    required int tenantId,
  }) async {
    final mapping = await (select(entityMappingsTable)
          ..where((t) =>
              t.serverId.equals(serverId) &
              t.entityType.equals(entityType) &
              t.tenantId.equals(tenantId)))
        .getSingleOrNull();
    return mapping?.localId;
  }
}
