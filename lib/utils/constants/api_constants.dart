class ApiConstants {
  ApiConstants._();

  /// Laravel HRM Base URL
  static const String baseUrl = "https://hrm.mesbahuddin.info";

  /// Mobile API Version 1 Base URL
  static const String v1BaseUrl = "$baseUrl/api/app/v1";

  /// Authentication Endpoints
  static const String loginEndpoint = "$v1BaseUrl/login";
  static const String bootstrapEndpoint = "$v1BaseUrl/bootstrap";
  static const String registerEndpoint = "$v1BaseUrl/register";
  static const String logoutEndpoint = "$v1BaseUrl/logout";
  static const String userProfileEndpoint = "$v1BaseUrl/user";
  static const String forgotPasswordEndpoint = "$v1BaseUrl/forgot-password";

  /// Mobile Module Endpoints (v1)
  static const String attendanceEventsEndpoint = "$v1BaseUrl/attendance/events";
  static const String tasksEndpoint = "$v1BaseUrl/tasks";
  static const String targetsEndpoint = "$v1BaseUrl/targets";
  static const String targetEntriesEndpoint = "$v1BaseUrl/target-entries";
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
  static const String storageRememberEmailKey = "hrm_remember_email";
  static const String storageIsLoggedInKey = "hrm_is_logged_in";
  static const String storageUserModeKey = "hrm_active_user_mode"; // 'staff' or 'manager'
  static const String storageDeviceIdKey = "hrm_device_identifier";
  static const String storagePoliciesKey = "hrm_cached_policies";
}
