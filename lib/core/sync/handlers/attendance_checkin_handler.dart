import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:auth_ui_app/core/database/app_database.dart';
import 'package:auth_ui_app/core/sync/sync_operation_handler.dart';
import 'package:auth_ui_app/core/sync/sync_result.dart';
import 'package:auth_ui_app/services/hrm_api_service.dart';

class AttendanceCheckInHandler implements SyncOperationHandler {
  @override
  String get operationType => 'attendance_checkin';

  @override
  Future<SyncResult> handle(OfflineOperation operation, AppDatabase db) async {
    Map<String, dynamic> payload = {};
    try {
      payload = jsonDecode(operation.payload) as Map<String, dynamic>;
    } catch (_) {}

    final lat = (payload['latitude'] as num?)?.toDouble() ?? 23.8103;
    final lng = (payload['longitude'] as num?)?.toDouble() ?? 90.4125;
    final acc = (payload['accuracy'] as num?)?.toDouble();
    final notes = payload['notes']?.toString();

    final response = await HrmApiService.instance.clockIn(
      latitude: lat,
      longitude: lng,
      accuracy: acc,
      notes: notes,
    );

    if (response.isSuccess) {
      // Reconcile local SQLite record
      final data = response.data;
      if (operation.entityLocalId != null) {
        await db.attendanceDao.updatePunchSyncState(
          localId: operation.entityLocalId!,
          syncState: 'synced',
          serverId: data?.attendanceId,
        );

        if (data != null && (data.attendanceId ?? 0) > 0) {
          await db.entityMappingsDao.saveMapping(
            localId: operation.entityLocalId!,
            serverId: data.attendanceId!,
            entityType: 'attendance',
            tenantId: operation.tenantId,
          );
        }
      }

      return SyncResult.success(message: response.message, data: data?.toJson());
    }

    if (SyncRetryPolicy.isRetryableStatus(response.statusCode)) {
      return SyncResult.retryableFailure(
        message: response.message,
        statusCode: response.statusCode,
        errorCode: 'server_temporary_error',
      );
    }

    return SyncResult.permanentFailure(
      message: response.message,
      statusCode: response.statusCode,
      errorCode: 'geofence_or_policy_violation',
    );
  }
}
