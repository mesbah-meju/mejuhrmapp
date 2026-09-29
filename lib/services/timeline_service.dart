import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';

class ActivityEvent {
  final String id;
  final String uuid;
  final String eventType;
  final String title;
  final String description;
  final Map<String, dynamic> metadata;
  final DateTime eventAt;
  final String status; // 'completed', 'pending', 'approved', 'rejected'
  final bool isOffline;

  ActivityEvent({
    required this.id,
    required this.uuid,
    required this.eventType,
    required this.title,
    required this.description,
    required this.metadata,
    required this.eventAt,
    this.status = 'completed',
    this.isOffline = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'uuid': uuid,
        'eventType': eventType,
        'title': title,
        'description': description,
        'metadata': metadata,
        'eventAt': eventAt.toIso8601String(),
        'status': status,
        'isOffline': isOffline,
      };

  factory ActivityEvent.fromJson(Map<String, dynamic> json) => ActivityEvent(
        id: json['id'] as String,
        uuid: json['uuid'] as String,
        eventType: json['eventType'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
        eventAt: DateTime.parse(json['eventAt'] as String),
        status: json['status'] as String? ?? 'completed',
        isOffline: json['isOffline'] as bool? ?? false,
      );

  IconData get icon {
    switch (eventType) {
      case 'attendance.clock_in':
        return Iconsax.login;
      case 'attendance.clock_out':
        return Iconsax.logout;
      case 'attendance.break_started':
      case 'attendance.break_ended':
        return Iconsax.timer_pause;
      case 'task.created':
      case 'task.started':
        return Iconsax.task;
      case 'task.completed':
        return Iconsax.task_square;
      case 'sales.entry_created':
        return Iconsax.shopping_cart;
      case 'sales.entry_approved':
        return Iconsax.verify;
      case 'sales.entry_rejected':
        return Iconsax.close_circle;
      case 'target.achieved':
      case 'target.over_achieved':
        return Iconsax.award;
      case 'payroll.generated':
      case 'payroll.paid':
        return Iconsax.wallet_3;
      case 'approval.requested':
        return Iconsax.clock;
      case 'approval.approved':
        return Iconsax.tick_circle;
      case 'approval.rejected':
        return Iconsax.close_square;
      default:
        return Iconsax.activity;
    }
  }

  Color get color {
    switch (eventType) {
      case 'attendance.clock_in':
        return const Color(0xFF2563EB); // Blue
      case 'attendance.clock_out':
        return const Color(0xFF64748B); // Slate
      case 'task.completed':
        return const Color(0xFF059669); // Emerald
      case 'sales.entry_created':
        return const Color(0xFF0284C7); // Sky
      case 'sales.entry_approved':
        return const Color(0xFF16A34A); // Green
      case 'target.achieved':
        return const Color(0xFFD97706); // Amber
      case 'target.over_achieved':
        return const Color(0xFF7C3AED); // Violet
      case 'payroll.paid':
        return const Color(0xFF0D9488); // Teal
      case 'approval.requested':
        return const Color(0xFFEA580C); // Orange
      case 'approval.rejected':
      case 'sales.entry_rejected':
        return const Color(0xFFDC2626); // Red
      default:
        return const Color(0xFF475569);
    }
  }
}

class TimelineService {
  static final TimelineService instance = TimelineService._internal();
  TimelineService._internal();

  final GetStorage _storage = GetStorage();
  static const String _storageKey = 'cached_employee_activity_events';

  /// Get timeline activity events (grouped or list)
  List<ActivityEvent> getEvents() {
    final rawList = _storage.read<List>(_storageKey) ?? [];
    if (rawList.isEmpty) {
      // Demo Initial Events
      final now = DateTime.now();
      return [
        ActivityEvent(
          id: '1',
          uuid: '01K-EVT-001',
          eventType: 'attendance.clock_in',
          title: 'Clocked In',
          description: 'Head Office (Geofence Verified)',
          metadata: {'location': 'Head Office', 'lat': 23.8103, 'lng': 90.4125},
          eventAt: now.subtract(const Duration(hours: 8, minutes: 30)),
        ),
        ActivityEvent(
          id: '2',
          uuid: '01K-EVT-002',
          eventType: 'task.completed',
          title: 'Task Completed',
          description: 'Client Follow-up Calls (5 Leads)',
          metadata: {'task_id': 1},
          eventAt: now.subtract(const Duration(hours: 7, minutes: 15)),
        ),
        ActivityEvent(
          id: '3',
          uuid: '01K-EVT-003',
          eventType: 'sales.entry_created',
          title: 'Sales Entry Submitted',
          description: 'Product A — 5 units (Pending Approval)',
          metadata: {'amount': 5, 'unit': 'units', 'product': 'Product A'},
          eventAt: now.subtract(const Duration(hours: 6, minutes: 10)),
          status: 'pending',
        ),
        ActivityEvent(
          id: '4',
          uuid: '01K-EVT-004',
          eventType: 'task.completed',
          title: 'Task Completed',
          description: 'Prepare Sales Report',
          metadata: {'task_id': 2},
          eventAt: now.subtract(const Duration(hours: 4, minutes: 45)),
        ),
        ActivityEvent(
          id: '5',
          uuid: '01K-EVT-005',
          eventType: 'sales.entry_approved',
          title: 'Sales Entry Approved',
          description: 'BDT 12,500 for ABC Ltd. approved by Manager',
          metadata: {'amount': 12500, 'client': 'ABC Ltd.'},
          eventAt: now.subtract(const Duration(hours: 3, minutes: 20)),
          status: 'approved',
        ),
        ActivityEvent(
          id: '6',
          uuid: '01K-EVT-006',
          eventType: 'target.achieved',
          title: 'Sales Target Achieved',
          description: 'BDT 100,000 / BDT 100,000 (100% Target Reached)',
          metadata: {'target': 100000, 'achieved': 100000},
          eventAt: now.subtract(const Duration(hours: 2, minutes: 15)),
        ),
        ActivityEvent(
          id: '7',
          uuid: '01K-EVT-007',
          eventType: 'target.over_achieved',
          title: 'Target Over-Achieved 🎉',
          description: 'BDT 112,000 / BDT 100,000 (112% Achieved)',
          metadata: {'target': 100000, 'achieved': 112000},
          eventAt: now.subtract(const Duration(hours: 1, minutes: 0)),
        ),
        ActivityEvent(
          id: '8',
          uuid: '01K-EVT-008',
          eventType: 'attendance.clock_out',
          title: 'Clocked Out',
          description: 'Total working time: 8h 30m',
          metadata: {'total_hours': '8h 30m'},
          eventAt: now.subtract(const Duration(minutes: 15)),
        ),
      ];
    }

    return rawList
        .map((item) => ActivityEvent.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  /// Add a new activity event
  Future<void> logEvent(ActivityEvent event) async {
    final currentEvents = getEvents();
    currentEvents.insert(0, event);
    final raw = currentEvents.map((e) => e.toJson()).toList();
    await _storage.write(_storageKey, raw);
  }
}
