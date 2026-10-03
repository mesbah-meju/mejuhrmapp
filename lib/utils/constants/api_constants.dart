class ApiConstants {
  ApiConstants._();

  /// Laravel HRM Base URL
  static const String baseUrl = "https://hrm.mesbahuddin.info";

  /// Standard Laravel API Base URL
  static const String apiBaseUrl = "$baseUrl/api";

  /// Mobile API Version 1 Base URL
  static const String v1BaseUrl = "$baseUrl/api/app/v1";

  /// 1. Authentication & Dual-Login Flow Endpoints
  static const String loginEndpoint = "$apiBaseUrl/login";
  static const String loginManagerEndpoint = "$apiBaseUrl/login/manager";
  static const String loginStaffEndpoint = "$apiBaseUrl/login/staff";
  static const String userProfileEndpoint = "$apiBaseUrl/user";
  static const String refreshTokenEndpoint = "$apiBaseUrl/refresh";
  static const String logoutEndpoint = "$apiBaseUrl/logout";
  static const String forgotPasswordEndpoint = "$apiBaseUrl/forgot-password";
  static const String forgotPasswordManagerEndpoint = "$apiBaseUrl/forgot-password/manager";
  static const String forgotPasswordStaffEndpoint = "$apiBaseUrl/forgot-password/staff";
  static const String bootstrapEndpoint = "$v1BaseUrl/bootstrap";
  static const String registerEndpoint = "$v1BaseUrl/register";

  /// 2. Tenant Geofence Locations Endpoints
  static const String locationsEndpoint = "$apiBaseUrl/hrm/locations";
  static const String locationsRefreshEndpoint = "$apiBaseUrl/hrm/locations/refresh";
  static const String checkGeofenceEndpoint = "$apiBaseUrl/hrm/locations/check-geofence";

  /// 3. Attendance & Geofenced Clock In/Out Endpoints
  static const String clockInEndpoint = "$apiBaseUrl/hrm/clock-in";
  static const String clockOutEndpoint = "$apiBaseUrl/hrm/clock-out";
  static const String clockInOutEndpoint = "$apiBaseUrl/hrm/clock-in-out";
  static const String attendanceTodayEndpoint = "$apiBaseUrl/hrm/attendance/today";
  static const String attendanceHistoryEndpoint = "$apiBaseUrl/hrm/attendance/history";
  static const String attendanceSyncEndpoint = "$apiBaseUrl/hrm/attendance/sync";
  static const String attendanceReportEndpoint = "$apiBaseUrl/hrm/attendance/report";
  static const String attendanceEventsEndpoint = "$v1BaseUrl/attendance/events";

  /// 4. Tasks Endpoints (Branch Tasks & Completions)
  static const String tasksTodayEndpoint = "$apiBaseUrl/hrm/tasks/today";
  static const String tasksToggleCompleteEndpoint = "$apiBaseUrl/hrm/tasks/toggle-complete";
  static const String tasksCompleteEndpoint = "$apiBaseUrl/hrm/tasks/complete";
  static const String tasksAdditionalEndpoint = "$apiBaseUrl/hrm/tasks/additional";
  static const String tasksCreateAdditionalEndpoint = "$apiBaseUrl/hrm/tasks/create-additional";
  static const String tasksHistoryEndpoint = "$apiBaseUrl/hrm/tasks/history";
  static const String tasksReportEndpoint = "$apiBaseUrl/hrm/tasks/report";
  static const String managerTaskCompletionsEndpoint = "$apiBaseUrl/hrm/manager/tasks/completions";
  static const String managerTaskReviewEndpoint = "$apiBaseUrl/hrm/manager/tasks/review";
  static const String managerTasksReportEndpoint = "$apiBaseUrl/hrm/manager/tasks/report";
  static const String tasksEndpoint = "$v1BaseUrl/tasks";

  /// 5. Targets Endpoints (Performly Sales Targets & KPIs)
  static const String targetsEndpoint = "$apiBaseUrl/performly/targets";
  static const String myTargetsEndpoint = "$apiBaseUrl/performly/my-targets";
  static const String salesLogsEndpoint = "$apiBaseUrl/performly/sales-logs";
  static const String mySalesLogsEndpoint = "$apiBaseUrl/performly/sales-logs/my-logs";
  static const String performlyProductsEndpoint = "$apiBaseUrl/performly/products";
  static const String managerSalesLogsEndpoint = "$apiBaseUrl/performly/manager/sales-logs";
  static const String targetEntriesEndpoint = "$v1BaseUrl/target-entries";

  /// 6. Manager Panel Endpoints
  static const String managerEmployeeOptionsEndpoint = "$apiBaseUrl/hrm/manager/employees/options";
  static const String managerEmployeesEndpoint = "$apiBaseUrl/hrm/manager/employees";
  static const String managerDepartmentsEndpoint = "$apiBaseUrl/hrm/manager/employees/departments";
  static const String managerDesignationsEndpoint = "$apiBaseUrl/hrm/manager/employees/designations";
  static const String managerAttendancesEndpoint = "$apiBaseUrl/hrm/manager/attendances";
  static const String managerAttendanceOverviewEndpoint = "$apiBaseUrl/hrm/manager/attendances/overview";
  static const String managerAttendanceReportEndpoint = "$apiBaseUrl/hrm/manager/attendances/report";
  static const String managerLeavesEndpoint = "$apiBaseUrl/hrm/manager/leaves";
  static const String managerBranchTasksEndpoint = "$apiBaseUrl/hrm/manager/tasks";
  static const String managerTargetsEndpoint = "$apiBaseUrl/performly/manager/targets";

  /// Module Specific Legacy & Extended Endpoints
  static const String payrollEndpoint = "$v1BaseUrl/payroll";
  static const String timelineEndpoint = "$v1BaseUrl/timeline";
  static const String approvalsEndpoint = "$v1BaseUrl/approvals";
  static const String notificationsEndpoint = "$v1BaseUrl/notifications";
  static const String syncEndpoint = "$v1BaseUrl/sync";
  static const String devicesEndpoint = "$v1BaseUrl/devices";
  static const String policiesEndpoint = "$v1BaseUrl/policies";

  /// Mobile App Metadata
  static const String appVersion = "1.5.0";
  static const String appBuildNumber = "150";
  static const String minSupportedVersion = "1.3.0";

  /// Local Storage Keys
  static const String storageTokenKey = "hrm_auth_token";
  static const String storageUserKey = "hrm_user_data";
  static const String storageEmployeeKey = "hrm_employee_data";
  static const String storageTenantLocationsKey = "hrm_tenant_locations";
  static const String storageRememberEmailKey = "hrm_remember_email";
  static const String storageIsLoggedInKey = "hrm_is_logged_in";
  static const String storageUserModeKey = "hrm_active_user_mode"; // 'staff' or 'manager'
  static const String storageDeviceIdKey = "hrm_device_identifier";
  static const String storagePoliciesKey = "hrm_cached_policies";
}
