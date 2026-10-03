import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/user_profiles_table.dart';

part 'user_profiles_dao.g.dart';

@DriftAccessor(tables: [UserProfilesTable])
class UserProfilesDao extends DatabaseAccessor<AppDatabase> with _$UserProfilesDaoMixin {
  UserProfilesDao(super.db);

  Stream<UserProfilesTableData?> watchProfile({required int tenantId, required int userId}) {
    return (select(userProfilesTable)
          ..where((t) => t.tenantId.equals(tenantId) & t.userId.equals(userId)))
        .watchSingleOrNull();
  }

  Future<UserProfilesTableData?> getProfile({required int tenantId, required int userId}) {
    return (select(userProfilesTable)
          ..where((t) => t.tenantId.equals(tenantId) & t.userId.equals(userId)))
        .getSingleOrNull();
  }

  Future<void> saveProfile(UserProfilesTableCompanion profile) {
    return into(userProfilesTable).insertOnConflictUpdate(profile);
  }

  Future<int> clearProfile({required int tenantId, required int userId}) {
    return (delete(userProfilesTable)
          ..where((t) => t.tenantId.equals(tenantId) & t.userId.equals(userId)))
        .go();
  }
}
