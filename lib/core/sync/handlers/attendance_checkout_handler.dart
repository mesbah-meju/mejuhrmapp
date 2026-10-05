import 'dart:convert';
import 'package:auth_ui_app/core/database/app_database.dart';
import 'package:auth_ui_app/core/sync/sync_operation_handler.dart';
import 'package:auth_ui_app/core/sync/sync_result.dart';
import 'package:auth_ui_app/services/hrm_api_service.dart';

class AttendanceCheckOutHandler implements SyncOperationHandler {
  @override
  String get operationType => 'attendance_checkout';

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

    final response = await HrmApiService.instance.clockOut(
      latitude: lat,
      longitude: lng,
      accuracy: acc,
      notes: notes,
    );

    if (response.isSuccess) {
      final data = response.data;
      if (operation.entityLocalId != null) {
        await db.attendanceDao.updatePunchSyncState(
          localId: operation.entityLocalId!,
          syncState: 'synced',
          serverId: data?.attendanceId,
        );
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
      errorCode: 'checkout_rejected',
    );
  }
}
