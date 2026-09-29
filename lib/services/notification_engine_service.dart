import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';

class AppNotification {
  final String id;
  final String uuid;
  final String category; // 'attendance', 'task', 'target', 'payroll', 'approval', 'sync'
  final String title;
  final String body;
  final Map<String, dynamic> data;
  final String? deepLinkRoute; // e.g. '/tasks', '/targets', '/payroll', '/approvals'
  final DateTime createdAt;
  bool isRead;

  AppNotification({
    required this.id,
    required this.uuid,
    required this.category,
    required this.title,
    required this.body,
    required this.data,
    this.deepLinkRoute,
    required this.createdAt,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'uuid': uuid,
        'category': category,
        'title': title,
        'body': body,
        'data': data,
        'deepLinkRoute': deepLinkRoute,
        'createdAt': createdAt.toIso8601String(),
        'isRead': isRead,
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
        id: json['id'] as String,
        uuid: json['uuid'] as String,
        category: json['category'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        data: Map<String, dynamic>.from(json['data'] as Map? ?? {}),
        deepLinkRoute: json['deepLinkRoute'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        isRead: json['isRead'] as bool? ?? false,
      );

  IconData get icon {
    switch (category) {
      case 'attendance':
        return Iconsax.location;
      case 'task':
        return Iconsax.task_square;
      case 'target':
        return Iconsax.award;
      case 'payroll':
        return Iconsax.wallet_3;
      case 'approval':
        return Iconsax.verify;
      case 'sync':
        return Iconsax.cloud_change;
      default:
        return Iconsax.notification;
    }
  }

  Color get color {
    switch (category) {
      case 'attendance':
        return const Color(0xFF2563EB);
      case 'task':
        return const Color(0xFF059669);
      case 'target':
        return const Color(0xFFD97706);
      case 'payroll':
        return const Color(0xFF7C3AED);
      case 'approval':
        return const Color(0xFFEA580C);
      case 'sync':
        return const Color(0xFF0284C7);
      default:
        return const Color(0xFF475569);
    }
  }
}

class NotificationEngineService {
  static final NotificationEngineService instance = NotificationEngineService._internal();
  NotificationEngineService._internal();

  final GetStorage _storage = GetStorage();
  static const String _storageKey = 'cached_app_notifications';

  /// Get list of notifications
  List<AppNotification> getNotifications() {
    final raw = _storage.read<List>(_storageKey) ?? [];
    if (raw.isEmpty) {
      final now = DateTime.now();
      return [
        AppNotification(
          id: '1',
          uuid: '01K-NOTIF-001',
          category: 'target',
          title: 'Target Achieved! 🎯',
          body: 'Congratulations! You reached today\'s BDT 100,000 sales target.',
          data: {'target_id': 1},
          deepLinkRoute: '/targets',
          createdAt: now.subtract(const Duration(hours: 1)),
          isRead: false,
        ),
        AppNotification(
          id: '2',
          uuid: '01K-NOTIF-002',
          category: 'approval',
          title: 'Manual Sale Approved',
          body: 'Your BDT 12,500 sales entry for ABC Ltd. was approved by Manager.',
          data: {'approval_id': '1'},
          deepLinkRoute: '/approvals',
          createdAt: now.subtract(const Duration(hours: 3)),
          isRead: false,
        ),
        AppNotification(
          id: '3',
          uuid: '01K-NOTIF-003',
          category: 'task',
          title: 'Task Overdue Reminder',
          body: '"Client Follow-up Calls" deadline is approaching.',
          data: {'task_id': 1},
          deepLinkRoute: '/tasks',
          createdAt: now.subtract(const Duration(hours: 5)),
          isRead: true,
        ),
        AppNotification(
          id: '4',
          uuid: '01K-NOTIF-004',
          category: 'payroll',
          title: 'Payroll Generated',
          body: 'Salary payslip for September 2026 is now available.',
          data: {'period': 'Sep 2026'},
          deepLinkRoute: '/payroll',
          createdAt: now.subtract(const Duration(days: 1)),
          isRead: true,
        ),
      ];
    }

    return raw
        .map((item) => AppNotification.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  /// Get unread notification count
  int getUnreadCount() {
    return getNotifications().where((n) => !n.isRead).length;
  }

  /// Mark single notification as read
  Future<void> markAsRead(String id) async {
    final list = getNotifications();
    final item = list.firstWhere((n) => n.id == id || n.uuid == id, orElse: () => list.first);
    item.isRead = true;
    await _storage.write(_storageKey, list.map((e) => e.toJson()).toList());
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    final list = getNotifications();
    for (var item in list) {
      item.isRead = true;
    }
    await _storage.write(_storageKey, list.map((e) => e.toJson()).toList());
  }

  /// Push new notification
  Future<void> addNotification(AppNotification notif) async {
    final list = getNotifications();
    list.insert(0, notif);
    await _storage.write(_storageKey, list.map((e) => e.toJson()).toList());
  }
}
