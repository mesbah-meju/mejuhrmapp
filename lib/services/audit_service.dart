import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

import 'package:auth_ui_app/services/device_session_service.dart';

class AuditLogRecord {
  final String id;
  final String uuid;
  final String actorId;
  final String actorType; // 'employee', 'manager', 'admin', 'system'
  final String event;
  final String entityType;
  final String entityId;
  final String entityUuid;
  final Map<String, dynamic>? oldValues;
  final Map<String, dynamic>? newValues;
  final Map<String, dynamic>? metadata;
  final String deviceId;
  final String operationUuid;
  final bool isOfflineAction;
  final DateTime deviceActionAt;
  final DateTime serverReceivedAt;

  AuditLogRecord({
    required this.id,
    required this.uuid,
    required this.actorId,
    this.actorType = 'employee',
    required this.event,
    required this.entityType,
    required this.entityId,
    required this.entityUuid,
    this.oldValues,
    this.newValues,
    this.metadata,
    required this.deviceId,
    required this.operationUuid,
    required this.isOfflineAction,
    required this.deviceActionAt,
    required this.serverReceivedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'uuid': uuid,
        'actorId': actorId,
        'actorType': actorType,
        'event': event,
        'entityType': entityType,
        'entityId': entityId,
        'entityUuid': entityUuid,
        'oldValues': oldValues,
        'newValues': newValues,
        'metadata': metadata,
        'deviceId': deviceId,
        'operationUuid': operationUuid,
        'isOfflineAction': isOfflineAction,
        'deviceActionAt': deviceActionAt.toIso8601String(),
        'serverReceivedAt': serverReceivedAt.toIso8601String(),
      };

  factory AuditLogRecord.fromJson(Map<String, dynamic> json) => AuditLogRecord(
        id: json['id'] as String,
        uuid: json['uuid'] as String,
        actorId: json['actorId'] as String,
        actorType: json['actorType'] as String? ?? 'employee',
        event: json['event'] as String,
        entityType: json['entityType'] as String,
        entityId: json['entityId'] as String,
        entityUuid: json['entityUuid'] as String,
        oldValues: json['oldValues'] != null ? Map<String, dynamic>.from(json['oldValues'] as Map) : null,
        newValues: json['newValues'] != null ? Map<String, dynamic>.from(json['newValues'] as Map) : null,
        metadata: json['metadata'] != null ? Map<String, dynamic>.from(json['metadata'] as Map) : null,
        deviceId: json['deviceId'] as String,
        operationUuid: json['operationUuid'] as String,
        isOfflineAction: json['isOfflineAction'] as bool? ?? false,
        deviceActionAt: DateTime.parse(json['deviceActionAt'] as String),
        serverReceivedAt: DateTime.parse(json['serverReceivedAt'] as String),
      );
}

class AuditService {
  static final AuditService instance = AuditService._internal();
  AuditService._internal();

  final GetStorage _storage = GetStorage();
  static const String _storageKey = 'cached_immutable_audit_logs';

  /// Mask sensitive keys before logging
  Map<String, dynamic>? _maskSensitiveData(Map<String, dynamic>? data) {
    if (data == null) return null;
    final Map<String, dynamic> cleaned = Map<String, dynamic>.from(data);
    const sensitiveKeys = ['password', 'token', 'access_token', 'refresh_token', 'secret', 'pin', 'credit_card'];

    for (var key in cleaned.keys.toList()) {
      if (sensitiveKeys.any((s) => key.toLowerCase().contains(s))) {
        cleaned[key] = '***MASKED***';
      }
    }
    return cleaned;
  }

  /// Get list of immutable audit records
  List<AuditLogRecord> getAuditLogs() {
    final raw = _storage.read<List>(_storageKey) ?? [];
    if (raw.isEmpty) {
      final now = DateTime.now();
      final devId = DeviceSessionService.instance.getDeviceId();
      return [
        AuditLogRecord(
          id: '1',
          uuid: '01K-AUD-001',
          actorId: 'EMP-00125',
          actorType: 'employee',
          event: 'Created Manual Sales Entry',
          entityType: 'sales_entry',
          entityId: '101',
          entityUuid: '01K-SALE-001',
          newValues: {'amount': 12500, 'client': 'ABC Ltd.'},
          metadata: {'approval_required': true},
          deviceId: devId,
          operationUuid: '01K-OP-9001',
          isOfflineAction: true,
          deviceActionAt: now.subtract(const Duration(hours: 3)),
          serverReceivedAt: now.subtract(const Duration(hours: 2)),
        ),
        AuditLogRecord(
          id: '2',
          uuid: '01K-AUD-002',
          actorId: 'MGR-00001',
          actorType: 'manager',
          event: 'Approved Manual Sales Entry',
          entityType: 'approval_request',
          entityId: '1',
          entityUuid: '01K-APR-001',
          oldValues: {'status': 'pending'},
          newValues: {'status': 'approved'},
          deviceId: devId,
          operationUuid: '01K-OP-9002',
          isOfflineAction: false,
          deviceActionAt: now.subtract(const Duration(hours: 1)),
          serverReceivedAt: now.subtract(const Duration(hours: 1)),
        ),
      ];
    }

    return raw
        .map((item) => AuditLogRecord.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  /// Record a new immutable audit log event
  Future<void> logAuditEvent({
    required String event,
    required String entityType,
    required String entityId,
    required String entityUuid,
    required String operationUuid,
    Map<String, dynamic>? oldValues,
    Map<String, dynamic>? newValues,
    Map<String, dynamic>? metadata,
    bool isOfflineAction = false,
  }) async {
    final logs = getAuditLogs();
    final now = DateTime.now();

    final record = AuditLogRecord(
      id: now.microsecondsSinceEpoch.toString(),
      uuid: "01K-AUD-${now.millisecondsSinceEpoch}",
      actorId: 'EMP-00125',
      actorType: 'employee',
      event: event,
      entityType: entityType,
      entityId: entityId,
      entityUuid: entityUuid,
      oldValues: _maskSensitiveData(oldValues),
      newValues: _maskSensitiveData(newValues),
      metadata: _maskSensitiveData(metadata),
      deviceId: DeviceSessionService.instance.getDeviceId(),
      operationUuid: operationUuid,
      isOfflineAction: isOfflineAction,
      deviceActionAt: now,
      serverReceivedAt: now,
    );

    logs.insert(0, record);
    await _storage.write(_storageKey, logs.map((e) => e.toJson()).toList());
  }
}
