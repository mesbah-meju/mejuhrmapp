import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:auth_ui_app/utils/constants/api_constants.dart';

class CompanyPolicyService {
  static final CompanyPolicyService instance = CompanyPolicyService._internal();
  CompanyPolicyService._internal();

  final GetStorage _storage = GetStorage();

  // Default Tenant Policies
  final Map<String, dynamic> _defaultPolicies = {
    // Attendance Policies
    'attendance_geofence_required': true,
    'attendance_offline_allowed': true,
    'attendance_offline_requires_approval': true,
    'attendance_clock_out_confirmation': true,
    'attendance_late_threshold_minutes': 15,
    'attendance_break_enabled': true,

    // Task Policies
    'task_employee_can_create': true,
    'task_offline_completion_allowed': true,
    'task_completion_requires_note': false,
    'task_overdue_reminders_enabled': true,

    // Target Policies
    'target_manual_sales_allowed': true,
    'target_manual_sales_requires_approval': true, // Defaults to ON per policy
    'target_offline_sales_allowed': true,
    'target_allow_overachievement': true,

    // Payroll Policies
    'payroll_show_estimated': true,
    'payroll_show_commission': true,
    'payroll_show_deductions': true,
    'payroll_show_loans': true,

    // Performance Weight Policies (Total 100%)
    'performance_attendance_weight': 20,
    'performance_tasks_weight': 25,
    'performance_sales_weight': 45,
    'performance_manager_rating_weight': 10,

    // Notification Policies
    'notification_attendance_reminder_enabled': true,
    'notification_attendance_reminder_time': '09:00 AM',
    'notification_task_due_minutes_before': 30,
    'notification_target_progress_milestones': [80, 100, 110],
  };

  /// Initialize and load policies
  Map<String, dynamic> getPolicies() {
    final cached = _storage.read(ApiConstants.storagePoliciesKey);
    if (cached is Map) {
      return Map<String, dynamic>.from(cached);
    }
    return Map<String, dynamic>.from(_defaultPolicies);
  }

  /// Update cached policies from bootstrap or sync
  Future<void> updatePolicies(Map<String, dynamic> newPolicies) async {
    try {
      final current = getPolicies();
      current.addAll(newPolicies);
      await _storage.write(ApiConstants.storagePoliciesKey, current);
    } catch (e) {
      if (kDebugMode) print("Error saving policies: $e");
    }
  }

  // Convenience Policy Getters
  bool get requiresManualSalesApproval {
    final policies = getPolicies();
    return policies['target_manual_sales_requires_approval'] as bool? ?? true;
  }

  bool get canUseOfflineAttendance {
    final policies = getPolicies();
    return policies['attendance_offline_allowed'] as bool? ?? true;
  }

  bool get requiresOfflineAttendanceApproval {
    final policies = getPolicies();
    return policies['attendance_offline_requires_approval'] as bool? ?? true;
  }

  bool get canEmployeeCreateTask {
    final policies = getPolicies();
    return policies['task_employee_can_create'] as bool? ?? true;
  }

  Map<String, int> get performanceWeights {
    final policies = getPolicies();
    return {
      'attendance': policies['performance_attendance_weight'] as int? ?? 20,
      'tasks': policies['performance_tasks_weight'] as int? ?? 25,
      'sales': policies['performance_sales_weight'] as int? ?? 45,
      'rating': policies['performance_manager_rating_weight'] as int? ?? 10,
    };
  }
}
