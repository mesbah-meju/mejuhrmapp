import 'package:drift/drift.dart' as drift;

import 'package:auth_ui_app/core/database/app_database.dart';
import 'package:auth_ui_app/features/hrm/models/auth_response_model.dart';
import 'package:auth_ui_app/services/auth_service.dart';
import 'package:auth_ui_app/services/hrm_api_service.dart';

class TenantLocationsRepository {
  static final TenantLocationsRepository instance = TenantLocationsRepository._internal();
  TenantLocationsRepository._internal();

  final AppDatabase _db = AppDatabase.instance;

  Stream<List<TenantLocationsTableData>> watchLocations() {
    final tenantId = AuthService.instance.getCurrentTenantId();
    return _db.tenantLocationsDao.watchLocations(tenantId);
  }

  Future<List<TenantLocationsTableData>> getLocations() {
    final tenantId = AuthService.instance.getCurrentTenantId();
    return _db.tenantLocationsDao.getLocations(tenantId);
  }

  Future<void> refreshLocations() async {
    final response = await HrmApiService.instance.getTenantLocations(refresh: true);
    if (response.isSuccess && response.data != null) {
      final tenantId = AuthService.instance.getCurrentTenantId();
      final list = response.data!;

      final companions = list.map((loc) {
        return TenantLocationsTableCompanion(
          id: drift.Value(loc.id),
          tenantId: drift.Value(tenantId),
          locationName: drift.Value(loc.locationName),
          address: drift.Value(loc.address),
          latitude: drift.Value(loc.latitude),
          longitude: drift.Value(loc.longitude),
          radiusMeters: drift.Value(loc.radiusMeters),
          isActive: drift.Value(loc.isActive),
          fetchedAt: drift.Value(DateTime.now()),
        );
      }).toList();

      await _db.tenantLocationsDao.replaceLocations(tenantId, companions);
    }
  }
}
