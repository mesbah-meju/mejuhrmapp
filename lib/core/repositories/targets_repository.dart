import 'package:drift/drift.dart' as drift;

import 'package:auth_ui_app/core/database/app_database.dart';
import 'package:auth_ui_app/features/hrm/models/target_model.dart';
import 'package:auth_ui_app/services/auth_service.dart';
import 'package:auth_ui_app/services/hrm_api_service.dart';

class TargetsRepository {
  static final TargetsRepository instance = TargetsRepository._internal();
  TargetsRepository._internal();

  final AppDatabase _db = AppDatabase.instance;

  Stream<List<TargetsTableData>> watchTargets() {
    final tenantId = AuthService.instance.getCurrentTenantId();
    final userId = AuthService.instance.getCurrentUserId();
    return _db.targetsDao.watchTargets(tenantId: tenantId, userId: userId);
  }

  Future<void> refreshTargets() async {
    final response = await HrmApiService.instance.getTargets();
    if (response.isSuccess && response.data != null) {
      final tenantId = AuthService.instance.getCurrentTenantId();
      final userId = AuthService.instance.getCurrentUserId();
      final targets = response.data!;

      final companions = targets.map((t) {
        return TargetsTableCompanion(
          localId: drift.Value("server_target_${t.id}"),
          serverId: drift.Value(t.id),
          tenantId: drift.Value(tenantId),
          userId: drift.Value(userId),
          title: drift.Value(t.title),
          targetType: drift.Value(t.targetType),
          targetValue: drift.Value(t.targetValue),
          achievedValue: drift.Value(t.achievedValue),
          progress: drift.Value(t.progress),
          unit: drift.Value(t.unit),
          startDate: drift.Value(t.startDate),
          endDate: drift.Value(t.endDate),
          status: drift.Value(t.status),
          notes: drift.Value(t.notes),
          syncState: const drift.Value('synced'),
          fetchedAt: drift.Value(DateTime.now()),
        );
      }).toList();

      await _db.targetsDao.replaceTargets(
        tenantId: tenantId,
        userId: userId,
        targets: companions,
      );
    }
  }
}
