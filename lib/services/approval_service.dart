import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

import 'package:auth_ui_app/services/company_policy_service.dart';
import 'package:auth_ui_app/services/timeline_service.dart';

enum ApprovalStatus { pending, approved, rejected, cancelled }

class ApprovalRequest {
  final String id;
  final String uuid;
  final String requestedBy;
  final String employeeName;
  final String approvalType; // 'manual_sales', 'attendance_correction', 'overtime', 'commission'
  final String entityType;
  final String entityId;
  final String entityUuid;
  final double value;
  final String valueDisplay;
  final String sourceInfo;
  final String reason;
  final Map<String, dynamic> metadata;
  final DateTime requestedAt;
  ApprovalStatus status;
  String? reviewedBy;
  DateTime? reviewedAt;
  String? reviewComment;

  ApprovalRequest({
    required this.id,
    required this.uuid,
    required this.requestedBy,
    required this.employeeName,
    required this.approvalType,
    required this.entityType,
    required this.entityId,
    required this.entityUuid,
    required this.value,
    required this.valueDisplay,
    required this.sourceInfo,
    required this.reason,
    required this.metadata,
    required this.requestedAt,
    this.status = ApprovalStatus.pending,
    this.reviewedBy,
    this.reviewedAt,
    this.reviewComment,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'uuid': uuid,
        'requestedBy': requestedBy,
        'employeeName': employeeName,
        'approvalType': approvalType,
        'entityType': entityType,
        'entityId': entityId,
        'entityUuid': entityUuid,
        'value': value,
        'valueDisplay': valueDisplay,
        'sourceInfo': sourceInfo,
        'reason': reason,
        'metadata': metadata,
        'requestedAt': requestedAt.toIso8601String(),
        'status': status.name,
        'reviewedBy': reviewedBy,
        'reviewedAt': reviewedAt?.toIso8601String(),
        'reviewComment': reviewComment,
      };

  factory ApprovalRequest.fromJson(Map<String, dynamic> json) => ApprovalRequest(
        id: json['id'] as String,
        uuid: json['uuid'] as String,
        requestedBy: json['requestedBy'] as String,
        employeeName: json['employeeName'] as String,
        approvalType: json['approvalType'] as String,
        entityType: json['entityType'] as String,
        entityId: json['entityId'] as String,
        entityUuid: json['entityUuid'] as String,
        value: (json['value'] as num).toDouble(),
        valueDisplay: json['valueDisplay'] as String,
        sourceInfo: json['sourceInfo'] as String,
        reason: json['reason'] as String,
        metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
        requestedAt: DateTime.parse(json['requestedAt'] as String),
        status: ApprovalStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => ApprovalStatus.pending,
        ),
        reviewedBy: json['reviewedBy'] as String?,
        reviewedAt: json['reviewedAt'] != null ? DateTime.parse(json['reviewedAt'] as String) : null,
        reviewComment: json['reviewComment'] as String?,
      );
}

class ApprovalService {
  static final ApprovalService instance = ApprovalService._internal();
  ApprovalService._internal();

  final GetStorage _storage = GetStorage();
  static const String _storageKey = 'cached_approval_requests';

  /// Get list of approval requests
  List<ApprovalRequest> getRequests() {
    final raw = _storage.read<List>(_storageKey) ?? [];
    if (raw.isEmpty) {
      // Demo Approval Requests
      final now = DateTime.now();
      return [
        ApprovalRequest(
          id: '1',
          uuid: '01K-APR-001',
          requestedBy: 'EMP-00125',
          employeeName: 'Rahul Sharma',
          approvalType: 'manual_sales',
          entityType: 'sales_entry',
          entityId: '101',
          entityUuid: '01K-SALE-001',
          value: 12500,
          valueDisplay: 'BDT 12,500',
          sourceInfo: 'Manual Sales Entry — ABC Ltd.',
          reason: 'Direct client payment collected via bank transfer',
          metadata: {'client': 'ABC Ltd.', 'payment_method': 'Bank Transfer'},
          requestedAt: now.subtract(const Duration(hours: 2)),
          status: ApprovalStatus.pending,
        ),
        ApprovalRequest(
          id: '2',
          uuid: '01K-APR-002',
          requestedBy: 'EMP-00125',
          employeeName: 'Rahul Sharma',
          approvalType: 'manual_sales',
          entityType: 'sales_entry',
          entityId: '102',
          entityUuid: '01K-SALE-002',
          value: 5,
          valueDisplay: '5 units (Product A)',
          sourceInfo: 'Item Quantity Sales Entry',
          reason: 'Manual quantity log from showroom sale',
          metadata: {'product': 'Product A', 'quantity': 5},
          requestedAt: now.subtract(const Duration(hours: 4)),
          status: ApprovalStatus.pending,
        ),
        ApprovalRequest(
          id: '3',
          uuid: '01K-APR-003',
          requestedBy: 'EMP-00130',
          employeeName: 'Ananya Roy',
          approvalType: 'attendance_correction',
          entityType: 'attendance',
          entityId: '204',
          entityUuid: '01K-ATT-004',
          value: 0,
          valueDisplay: 'Clock-in Time Adjustment',
          sourceInfo: 'Geofence Offline Clock-in',
          reason: 'Network disconnect during morning field visit',
          metadata: {'requested_time': '09:05 AM', 'actual_time': '09:25 AM'},
          requestedAt: now.subtract(const Duration(hours: 5)),
          status: ApprovalStatus.approved,
          reviewedBy: 'System Administrator',
          reviewedAt: now.subtract(const Duration(hours: 3)),
          reviewComment: 'Verified with GPS logs',
        ),
      ];
    }

    return raw
        .map((item) => ApprovalRequest.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  /// Submit a new approval request
  Future<ApprovalRequest> submitRequest(ApprovalRequest req) async {
    final list = getRequests();
    list.insert(0, req);
    await _storage.write(_storageKey, list.map((e) => e.toJson()).toList());

    // Also log in activity timeline
    TimelineService.instance.logEvent(
      ActivityEvent(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        uuid: req.uuid,
        eventType: 'approval.requested',
        title: 'Approval Requested',
        description: '${req.valueDisplay} (${req.sourceInfo})',
        metadata: req.metadata,
        eventAt: DateTime.now(),
        status: 'pending',
      ),
    );

    return req;
  }

  /// Approve request (Manager action)
  Future<bool> approveRequest(String id, {String? comment}) async {
    final list = getRequests();
    final index = list.indexWhere((r) => r.id == id || r.uuid == id);
    if (index == -1) return false;

    final req = list[index];
    req.status = ApprovalStatus.approved;
    req.reviewedBy = 'Manager';
    req.reviewedAt = DateTime.now();
    req.reviewComment = comment ?? 'Approved by Manager';

    await _storage.write(_storageKey, list.map((e) => e.toJson()).toList());

    TimelineService.instance.logEvent(
      ActivityEvent(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        uuid: req.uuid,
        eventType: 'approval.approved',
        title: 'Request Approved',
        description: '${req.valueDisplay} approved by Manager',
        metadata: req.metadata,
        eventAt: DateTime.now(),
        status: 'approved',
      ),
    );

    return true;
  }

  /// Reject request (Manager action)
  Future<bool> rejectRequest(String id, {required String comment}) async {
    final list = getRequests();
    final index = list.indexWhere((r) => r.id == id || r.uuid == id);
    if (index == -1) return false;

    final req = list[index];
    req.status = ApprovalStatus.rejected;
    req.reviewedBy = 'Manager';
    req.reviewedAt = DateTime.now();
    req.reviewComment = comment;

    await _storage.write(_storageKey, list.map((e) => e.toJson()).toList());

    TimelineService.instance.logEvent(
      ActivityEvent(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        uuid: req.uuid,
        eventType: 'approval.rejected',
        title: 'Request Rejected',
        description: '${req.valueDisplay} rejected: $comment',
        metadata: req.metadata,
        eventAt: DateTime.now(),
        status: 'rejected',
      ),
    );

    return true;
  }
}
