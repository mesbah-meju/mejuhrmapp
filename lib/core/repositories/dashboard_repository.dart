import 'dart:convert';
import 'package:drift/drift.dart' as drift;

import 'package:auth_ui_app/core/database/app_database.dart';
import 'package:auth_ui_app/services/auth_service.dart';
import 'package:auth_ui_app/services/hrm_api_service.dart';

class DashboardRepository {
  static final DashboardRepository instance = DashboardRepository._internal();
  DashboardRepository._internal();

  final AppDatabase _db = AppDatabase.instance;

  Stream<DashboardSnapshotsTableData?> watchDashboardSnapshot(String snapshotType) {
    final tenantId = AuthService.instance.getCurrentTenantId();
    final userId = AuthService.instance.getCurrentUserId();
    return _db.dashboardDao.watchSnapshot(
      tenantId: tenantId,
      userId: userId,
      snapshotType: snapshotType,
    );
  }

  Future<void> saveDashboardSnapshot({
    required String snapshotType,
    required Map<String, dynamic> data,
    Duration ttl = const Duration(hours: 1),
  }) async {
    final tenantId = AuthService.instance.getCurrentTenantId();
    final userId = AuthService.instance.getCurrentUserId();
    final now = DateTime.now();

    await _db.dashboardDao.saveSnapshot(
      DashboardSnapshotsTableCompanion(
        tenantId: drift.Value(tenantId),
        userId: drift.Value(userId),
        snapshotType: drift.Value(snapshotType),
        dataJson: drift.Value(jsonEncode(data)),
        fetchedAt: drift.Value(now),
        expiresAt: drift.Value(now.add(ttl)),
      ),
    );
  }
}
