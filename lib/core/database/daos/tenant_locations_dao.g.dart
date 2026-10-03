// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_locations_dao.dart';

// ignore_for_file: type=lint
mixin _$TenantLocationsDaoMixin on DatabaseAccessor<AppDatabase> {
  $TenantLocationsTableTable get tenantLocationsTable =>
      attachedDatabase.tenantLocationsTable;
  TenantLocationsDaoManager get managers => TenantLocationsDaoManager(this);
}

class TenantLocationsDaoManager {
  final _$TenantLocationsDaoMixin _db;
  TenantLocationsDaoManager(this._db);
  $$TenantLocationsTableTableTableManager get tenantLocationsTable =>
      $$TenantLocationsTableTableTableManager(
          _db.attachedDatabase, _db.tenantLocationsTable);
}
