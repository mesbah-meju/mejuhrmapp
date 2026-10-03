// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profiles_dao.dart';

// ignore_for_file: type=lint
mixin _$UserProfilesDaoMixin on DatabaseAccessor<AppDatabase> {
  $UserProfilesTableTable get userProfilesTable =>
      attachedDatabase.userProfilesTable;
  UserProfilesDaoManager get managers => UserProfilesDaoManager(this);
}

class UserProfilesDaoManager {
  final _$UserProfilesDaoMixin _db;
  UserProfilesDaoManager(this._db);
  $$UserProfilesTableTableTableManager get userProfilesTable =>
      $$UserProfilesTableTableTableManager(
          _db.attachedDatabase, _db.userProfilesTable);
}
