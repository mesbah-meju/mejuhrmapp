// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'targets_dao.dart';

// ignore_for_file: type=lint
mixin _$TargetsDaoMixin on DatabaseAccessor<AppDatabase> {
  $TargetsTableTable get targetsTable => attachedDatabase.targetsTable;
  TargetsDaoManager get managers => TargetsDaoManager(this);
}

class TargetsDaoManager {
  final _$TargetsDaoMixin _db;
  TargetsDaoManager(this._db);
  $$TargetsTableTableTableManager get targetsTable =>
      $$TargetsTableTableTableManager(_db.attachedDatabase, _db.targetsTable);
}
