import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';

import 'package:auth_ui_app/core/database/app_database.dart';
import 'package:auth_ui_app/core/sync/sync_engine.dart';
import 'package:auth_ui_app/features/hrm/models/attendance_model.dart';
import 'package:auth_ui_app/services/auth_service.dart';
import 'package:auth_ui_app/services/hrm_api_service.dart';

class AttendanceRepository {
  static final AttendanceRepository instance = AttendanceRepository._internal();
  AttendanceRepository._internal();

  final AppDatabase _db = AppDatabase.instance;
  final _uuid = const Uuid();

  /// Watch Today Attendance Status from SQLite
  Stream<TodayAttendanceTableData?> watchTodayStatus() {
    final tenantId = AuthService.instance.getCurrentTenantId();
    final userId = AuthService.instance.getCurrentUserId();
    return _db.attendanceDao.watchTodayStatus(tenantId: tenantId, userId: userId);
  }

  /// Watch monthly attendance records from SQLite
  Stream<List<AttendanceTableData>> watchMonthlyHistory(int month, int year) {
    final tenantId = AuthService.instance.getCurrentTenantId();
    final userId = AuthService.instance.getCurrentUserId();
    final prefix = "$year-${month.toString().padLeft(2, '0')}";
    return _db.attendanceDao.watchAttendanceHistory(
      tenantId: tenantId,
      userId: userId,
      monthPrefix: prefix,
    );
  }

  /// Fetch and reconcile Today Attendance Status from Server into SQLite
  Future<TodayAttendanceStatus?> refreshTodayStatus() async {
    final response = await HrmApiService.instance.getTodayAttendance();
    if (response.isSuccess && response.data != null) {
      final status = response.data!;
      final tenantId = AuthService.instance.getCurrentTenantId();
      final userId = AuthService.instance.getCurrentUserId();

      await _db.attendanceDao.upsertTodayStatus(
        TodayAttendanceTableCompanion(
          tenantId: drift.Value(tenantId),
          userId: drift.Value(userId),
          date: drift.Value(status.date),
          isClockedIn: drift.Value(status.isClockedIn),
          canClockIn: drift.Value(status.canClockIn),
          canClockOut: drift.Value(status.canClockOut),
          attendanceId: drift.Value(status.attendanceId),
          clockIn: drift.Value(status.clockIn),
          clockOut: drift.Value(status.clockOut),
          totalHours: drift.Value(status.totalHours),
          totalHoursNumeric: drift.Value(status.totalHoursNumeric),
          breakHours: drift.Value(status.breakHours),
          overtimeHours: drift.Value(status.overtimeHours),
          status: drift.Value(status.status),
          isWorkingDay: drift.Value(status.isWorkingDay),
          isHoliday: drift.Value(status.isHoliday),
          holidayName: drift.Value(status.holidayName),
          isOnLeave: drift.Value(status.isOnLeave),
          isHalfDayLeave: drift.Value(status.isHalfDayLeave),
          leaveTitle: drift.Value(status.leaveTitle),
          checkInLocationJson: drift.Value(
            status.checkInLocation != null ? jsonEncode(status.checkInLocation!.toJson()) : null,
          ),
          checkInBranchJson: drift.Value(
            status.checkInBranch != null ? jsonEncode(status.checkInBranch!.toJson()) : null,
          ),
          shiftJson: drift.Value(
            status.shift != null ? jsonEncode(status.shift!.toJson()) : null,
          ),
          workingDaysMapJson: drift.Value(
            status.workingDaysMap != null ? jsonEncode(status.workingDaysMap) : null,
          ),
          fetchedAt: drift.Value(DateTime.now()),
        ),
      );
      return status;
    }
    return null;
  }

  /// Fetch and reconcile Monthly History from Server into SQLite
  Future<void> refreshHistory({int? month, int? year}) async {
    final response = await HrmApiService.instance.getAttendanceHistoryResponse(
      month: month,
      year: year,
    );

    if (response.isSuccess && response.data != null) {
      final tenantId = AuthService.instance.getCurrentTenantId();
      final userId = AuthService.instance.getCurrentUserId();
      final history = response.data!.history;

      final companions = history.map((record) {
        return AttendanceTableCompanion(
          localId: drift.Value("server_${record.id}"),
          serverId: drift.Value(record.id),
          tenantId: drift.Value(tenantId),
          userId: drift.Value(userId),
          date: drift.Value(record.date),
          clockIn: drift.Value(record.clockIn),
          clockOut: drift.Value(record.clockOut),
          status: drift.Value(record.status),
          calculatedStatus: drift.Value(record.calculatedStatus),
          isLate: drift.Value(record.isLate),
          isEarly: drift.Value(record.isEarly),
          totalHours: drift.Value(record.totalHours),
          totalHoursNumeric: drift.Value(record.totalHoursNumeric),
          breakHours: drift.Value(record.breakHours),
          breakHoursNumeric: drift.Value(record.breakHoursNumeric),
          overtimeHours: drift.Value(record.overtimeHours),
          overtimeHoursNumeric: drift.Value(record.overtimeHoursNumeric),
          overtimeAmount: drift.Value(record.overtimeAmount),
          notes: drift.Value(record.notes),
          checkInLocationJson: drift.Value(
            record.checkInLocation != null ? jsonEncode(record.checkInLocation!.toJson()) : null,
          ),
          checkOutLocationJson: drift.Value(
            record.checkOutLocation != null ? jsonEncode(record.checkOutLocation!.toJson()) : null,
          ),
          checkInBranchJson: drift.Value(
            record.checkInBranch != null ? jsonEncode(record.checkInBranch!.toJson()) : null,
          ),
          checkOutBranchJson: drift.Value(
            record.checkOutBranch != null ? jsonEncode(record.checkOutBranch!.toJson()) : null,
          ),
          shiftJson: drift.Value(
            record.shift != null ? jsonEncode(record.shift!.toJson()) : null,
          ),
          syncState: const drift.Value('synced'),
          localUpdatedAt: drift.Value(DateTime.now()),
          serverUpdatedAt: drift.Value(DateTime.now()),
        );
      }).toList();

      await _db.attendanceDao.reconcileServerHistory(
        tenantId: tenantId,
        userId: userId,
        serverRecords: companions,
      );
    }
  }

  /// Perform Offline-First Clock In
  Future<String> clockIn({
    required double latitude,
    required double longitude,
    double? accuracy,
    String? notes,
  }) async {
    final tenantId = AuthService.instance.getCurrentTenantId();
    final userId = AuthService.instance.getCurrentUserId();
    final localId = _uuid.v4();
    final now = DateTime.now();
    final dateStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final timeStr = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

    // 1. Optimistically write to SQLite Attendance Table
    await _db.attendanceDao.upsertAttendanceRecord(
      AttendanceTableCompanion(
        localId: drift.Value(localId),
        tenantId: drift.Value(tenantId),
        userId: drift.Value(userId),
        date: drift.Value(dateStr),
        clockIn: drift.Value(timeStr),
        status: const drift.Value('present'),
        latitude: drift.Value(latitude),
        longitude: drift.Value(longitude),
        accuracy: accuracy != null ? drift.Value(accuracy) : const drift.Value.absent(),
        notes: notes != null ? drift.Value(notes) : const drift.Value.absent(),
        syncState: const drift.Value('pending_sync'),
        localUpdatedAt: drift.Value(now),
      ),
    );

    // 2. Optimistically update Today Status
    await _db.attendanceDao.upsertTodayStatus(
      TodayAttendanceTableCompanion(
        tenantId: drift.Value(tenantId),
        userId: drift.Value(userId),
        date: drift.Value(dateStr),
        isClockedIn: const drift.Value(true),
        canClockIn: const drift.Value(false),
        canClockOut: const drift.Value(true),
        clockIn: drift.Value(timeStr),
        status: const drift.Value('present'),
        fetchedAt: drift.Value(now),
      ),
    );

    // 3. Queue durable operation in SyncEngine
    await SyncEngine.instance.enqueueOperation(
      operationType: 'attendance_checkin',
      entityType: 'attendance',
      entityLocalId: localId,
      priority: 10, // Higher priority for check-in
      payload: {
        'id': localId,
        'type': 'clockin',
        'latitude': latitude,
        'longitude': longitude,
        'accuracy': accuracy ?? 12.0,
        'timestamp': now.toIso8601String(),
        if (notes != null) 'notes': notes,
      },
    );

    return localId;
  }

  /// Perform Offline-First Clock Out
  Future<String> clockOut({
    required double latitude,
    required double longitude,
    double? accuracy,
    String? notes,
    String? checkInOperationId,
  }) async {
    final tenantId = AuthService.instance.getCurrentTenantId();
    final userId = AuthService.instance.getCurrentUserId();
    final localId = _uuid.v4();
    final now = DateTime.now();
    final dateStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final timeStr = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

    // 1. Optimistically update Today Status in SQLite
    await _db.attendanceDao.upsertTodayStatus(
      TodayAttendanceTableCompanion(
        tenantId: drift.Value(tenantId),
        userId: drift.Value(userId),
        date: drift.Value(dateStr),
        isClockedIn: const drift.Value(false),
        canClockIn: const drift.Value(false),
        canClockOut: const drift.Value(false),
        clockOut: drift.Value(timeStr),
        status: const drift.Value('present'),
        fetchedAt: drift.Value(now),
      ),
    );

    // 2. Queue durable operation in SyncEngine with dependency on checkIn if applicable
    await SyncEngine.instance.enqueueOperation(
      operationType: 'attendance_checkout',
      entityType: 'attendance',
      entityLocalId: localId,
      dependsOnOperationId: checkInOperationId,
      priority: 9,
      payload: {
        'id': localId,
        'type': 'clockout',
        'latitude': latitude,
        'longitude': longitude,
        'accuracy': accuracy ?? 10.0,
        'timestamp': now.toIso8601String(),
        if (notes != null) 'notes': notes,
      },
    );

    return localId;
  }
}
