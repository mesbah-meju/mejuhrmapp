// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_operations_dao.dart';

// ignore_for_file: type=lint
mixin _$OfflineOperationsDaoMixin on DatabaseAccessor<AppDatabase> {
  $OfflineOperationsTable get offlineOperations =>
      attachedDatabase.offlineOperations;
  OfflineOperationsDaoManager get managers => OfflineOperationsDaoManager(this);
}

class OfflineOperationsDaoManager {
  final _$OfflineOperationsDaoMixin _db;
  OfflineOperationsDaoManager(this._db);
  $$OfflineOperationsTableTableManager get offlineOperations =>
      $$OfflineOperationsTableTableManager(
          _db.attachedDatabase, _db.offlineOperations);
}
