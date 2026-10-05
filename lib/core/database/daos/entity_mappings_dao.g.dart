// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_mappings_dao.dart';

// ignore_for_file: type=lint
mixin _$EntityMappingsDaoMixin on DatabaseAccessor<AppDatabase> {
  $EntityMappingsTableTable get entityMappingsTable =>
      attachedDatabase.entityMappingsTable;
  EntityMappingsDaoManager get managers => EntityMappingsDaoManager(this);
}

class EntityMappingsDaoManager {
  final _$EntityMappingsDaoMixin _db;
  EntityMappingsDaoManager(this._db);
  $$EntityMappingsTableTableTableManager get entityMappingsTable =>
      $$EntityMappingsTableTableTableManager(
          _db.attachedDatabase, _db.entityMappingsTable);
}
