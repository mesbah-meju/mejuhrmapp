import 'dart:convert';
import 'package:auth_ui_app/core/database/app_database.dart';
import 'package:auth_ui_app/core/sync/sync_operation_handler.dart';
import 'package:auth_ui_app/core/sync/sync_result.dart';
import 'package:auth_ui_app/services/hrm_api_service.dart';

class TaskCompleteHandler implements SyncOperationHandler {
  @override
  String get operationType => 'task_complete';

  @override
  Future<SyncResult> handle(OfflineOperation operation, AppDatabase db) async {
    Map<String, dynamic> payload = {};
    try {
      payload = jsonDecode(operation.payload) as Map<String, dynamic>;
    } catch (_) {}

    int serverTaskId = operation.entityServerId ?? 0;
    if (serverTaskId <= 0 && payload['branch_task_id'] != null) {
      serverTaskId = int.tryParse(payload['branch_task_id'].toString()) ?? 0;
    }

    if (serverTaskId <= 0 && operation.entityLocalId != null) {
      final mappedId = await db.entityMappingsDao.getServerId(operation.entityLocalId!);
      if (mappedId != null) serverTaskId = mappedId;
    }

    if (serverTaskId <= 0) {
      return SyncResult.permanentFailure(
        message: "Missing server task ID for task completion",
        errorCode: "missing_server_id",
      );
    }

    final notes = payload['notes']?.toString();
    final response = await HrmApiService.instance.toggleTaskComplete(
      branchTaskId: serverTaskId,
      notes: notes,
    );

    if (response.isSuccess) {
      if (operation.entityLocalId != null) {
        await db.tasksDao.updateCompletionState(
          localId: operation.entityLocalId!,
          isCompleted: true,
          status: 'completed',
          syncState: 'synced',
        );
      }

      return SyncResult.success(message: response.message, data: response.data);
    }

    if (SyncRetryPolicy.isRetryableStatus(response.statusCode)) {
      return SyncResult.retryableFailure(
        message: response.message,
        statusCode: response.statusCode,
        errorCode: 'network_server_error',
      );
    }

    return SyncResult.permanentFailure(
      message: response.message,
      statusCode: response.statusCode,
      errorCode: 'task_completion_rejected',
    );
  }
}
