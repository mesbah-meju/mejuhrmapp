import 'dart:convert';
import 'package:auth_ui_app/core/database/app_database.dart';
import 'package:auth_ui_app/core/sync/sync_result.dart';

abstract class SyncOperationHandler {
  /// Unique operation type string (e.g. 'attendance_checkin', 'task_toggle')
  String get operationType;

  /// Execute the operation against remote API and reconcile with local SQLite
  Future<SyncResult> handle(OfflineOperation operation, AppDatabase db);
}
