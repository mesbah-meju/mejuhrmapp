import 'package:auth_ui_app/features/hrm/models/attendance_model.dart';
import 'package:auth_ui_app/features/hrm/models/auth_response_model.dart';
import 'package:auth_ui_app/features/hrm/models/geofence_model.dart';
import 'package:auth_ui_app/features/hrm/models/manager_models.dart';
import 'package:auth_ui_app/features/hrm/models/target_model.dart';
import 'package:auth_ui_app/features/hrm/models/task_model.dart';
import 'package:auth_ui_app/services/api_client.dart';
import 'package:auth_ui_app/utils/constants/api_constants.dart';

class HrmApiService {
  static final HrmApiService instance = HrmApiService._internal();
  HrmApiService._internal();

  final ApiClient _client = ApiClient.instance;

  // =========================================================================
  // 1. Authentication & Dual-Login Flow
  // =========================================================================

  /// 1.1 Login as Manager (hr, admin, manager roles)
  Future<ApiResponse<AuthDataModel>> loginManager({
    required String email,
    required String password,
    String? deviceName = 'Flutter-Mobile',
  }) async {
    return await _client.post<AuthDataModel>(
      ApiConstants.loginManagerEndpoint,
      body: {
        'email': email,
        'password': password,
        'device_name': deviceName,
        'login_type': 'manager',
      },
      fromJson: (json) => AuthDataModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 1.2 Login as Staff (regular employees)
  Future<ApiResponse<AuthDataModel>> loginStaff({
    required String email,
    required String password,
    String? deviceName = 'Flutter-Mobile',
  }) async {
    return await _client.post<AuthDataModel>(
      ApiConstants.loginStaffEndpoint,
      body: {
        'email': email,
        'password': password,
        'device_name': deviceName,
        'login_type': 'staff',
      },
      fromJson: (json) => AuthDataModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// Unified Login helper dispatching to role-based endpoint
  Future<ApiResponse<AuthDataModel>> login({
    required String email,
    required String password,
    String loginType = 'staff',
    String? deviceName = 'Flutter-Mobile',
  }) async {
    final endpoint = loginType.toLowerCase() == 'manager'
        ? ApiConstants.loginManagerEndpoint
        : ApiConstants.loginStaffEndpoint;

    return await _client.post<AuthDataModel>(
      endpoint,
      body: {
        'email': email,
        'password': password,
        'device_name': deviceName,
        'login_type': loginType,
      },
      fromJson: (json) => AuthDataModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 1.3 Get Authenticated Profile
  Future<ApiResponse<AuthDataModel>> getUserProfile() async {
    return await _client.get<AuthDataModel>(
      ApiConstants.userProfileEndpoint,
      fromJson: (json) {
        if (json is Map<String, dynamic>) {
          // If response wraps in 'user' / 'data'
          if (json.containsKey('user')) {
            return AuthDataModel.fromJson(json);
          }
          return AuthDataModel(
            user: UserModel.fromJson(json),
            token: _client.token ?? '',
            type: 'bearer',
            loginType: 'staff',
          );
        }
        return AuthDataModel.fromJson({});
      },
    );
  }

  /// 1.4 Token Refresh
  Future<ApiResponse<Map<String, dynamic>>> refreshToken() async {
    return await _client.post<Map<String, dynamic>>(
      ApiConstants.refreshTokenEndpoint,
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  /// 1.4 Logout
  Future<ApiResponse<dynamic>> logout() async {
    return await _client.post<dynamic>(
      ApiConstants.logoutEndpoint,
    );
  }

  // =========================================================================
  // 2. Tenant Geofence Locations API
  // =========================================================================

  /// 2.1 Get & Refresh Tenant Locations
  Future<ApiResponse<List<TenantLocationModel>>> getTenantLocations({bool refresh = false}) async {
    final endpoint = refresh ? ApiConstants.locationsRefreshEndpoint : ApiConstants.locationsEndpoint;

    return await _client.get<List<TenantLocationModel>>(
      endpoint,
      fromJson: (json) {
        List<dynamic> list = [];
        if (json is Map && json['locations'] is List) {
          list = json['locations'] as List;
        } else if (json is List) {
          list = json;
        }

        return list
            .map((item) => TenantLocationModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
      },
    );
  }

  /// 2.2 Verify Geofence Server-side
  Future<ApiResponse<GeofenceCheckResult>> checkGeofence({
    required double latitude,
    required double longitude,
    double? accuracy,
  }) async {
    return await _client.post<GeofenceCheckResult>(
      ApiConstants.checkGeofenceEndpoint,
      body: {
        'latitude': latitude,
        'longitude': longitude,
        if (accuracy != null) 'accuracy': accuracy,
      },
      fromJson: (json) => GeofenceCheckResult.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  // =========================================================================
  // 3. Attendance & Geofenced Clock In/Out
  // =========================================================================

  /// 3.1 Clock In with GPS
  Future<ApiResponse<AttendanceRecord>> clockIn({
    required double latitude,
    required double longitude,
    double? accuracy,
  }) async {
    return await _client.post<AttendanceRecord>(
      ApiConstants.clockInEndpoint,
      body: {
        'latitude': latitude,
        'longitude': longitude,
        if (accuracy != null) 'accuracy': accuracy,
      },
      fromJson: (json) => AttendanceRecord.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 3.2 Clock Out with GPS
  Future<ApiResponse<AttendanceRecord>> clockOut({
    required double latitude,
    required double longitude,
    double? accuracy,
  }) async {
    return await _client.post<AttendanceRecord>(
      ApiConstants.clockOutEndpoint,
      body: {
        'latitude': latitude,
        'longitude': longitude,
        if (accuracy != null) 'accuracy': accuracy,
      },
      fromJson: (json) => AttendanceRecord.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 3.3 Today's Attendance Status
  Future<ApiResponse<TodayAttendanceStatus>> getTodayAttendance() async {
    return await _client.get<TodayAttendanceStatus>(
      ApiConstants.attendanceTodayEndpoint,
      fromJson: (json) => TodayAttendanceStatus.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 3.4 Attendance History (Full Response with Summary & Records)
  Future<ApiResponse<AttendanceHistoryResponse>> getAttendanceHistoryResponse({
    int? month,
    int? year,
    String? startDate,
    String? endDate,
  }) async {
    final Map<String, String> params = {};
    if (month != null) params['month'] = month.toString();
    if (year != null) params['year'] = year.toString();
    if (startDate != null) params['start_date'] = startDate;
    if (endDate != null) params['end_date'] = endDate;

    return await _client.get<AttendanceHistoryResponse>(
      ApiConstants.attendanceHistoryEndpoint,
      queryParams: params,
      fromJson: (json) => AttendanceHistoryResponse.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 3.4 Attendance History (Records List Helper)
  Future<ApiResponse<List<AttendanceRecord>>> getAttendanceHistory({
    int? month,
    int? year,
    String? startDate,
    String? endDate,
  }) async {
    final response = await getAttendanceHistoryResponse(
      month: month,
      year: year,
      startDate: startDate,
      endDate: endDate,
    );

    return ApiResponse<List<AttendanceRecord>>(
      success: response.success,
      message: response.message,
      data: response.data?.history ?? [],
      errors: response.errors,
      statusCode: response.statusCode,
      rawJson: response.rawJson,
    );
  }

  // =========================================================================
  // 4. Tasks API (Branch Tasks & Completions)
  // =========================================================================

  /// 4.1 Get Today's Tasks & Summary
  Future<ApiResponse<TodayTasksResponse>> getTodayTasks() async {
    return await _client.get<TodayTasksResponse>(
      ApiConstants.tasksTodayEndpoint,
      fromJson: (json) => TodayTasksResponse.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 4.2 Complete or Toggle Task
  Future<ApiResponse<Map<String, dynamic>>> toggleTaskComplete({
    required int branchTaskId,
    String? notes,
  }) async {
    return await _client.post<Map<String, dynamic>>(
      ApiConstants.tasksToggleCompleteEndpoint,
      body: {
        'branch_task_id': branchTaskId,
        if (notes != null) 'notes': notes,
      },
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  /// 4.3 Staff: Personal Task Completion History (Full Response with Pagination)
  Future<ApiResponse<TaskHistoryResponse>> getTaskHistoryResponse({
    int? month,
    int? year,
    String? status,
    int perPage = 15,
  }) async {
    final Map<String, String> params = {
      'per_page': perPage.toString(),
    };
    if (month != null) params['month'] = month.toString();
    if (year != null) params['year'] = year.toString();
    if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
      params['status'] = status.toLowerCase();
    }

    return await _client.get<TaskHistoryResponse>(
      ApiConstants.tasksHistoryEndpoint,
      queryParams: params,
      fromJson: (json) => TaskHistoryResponse.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 4.3 Task History (Helper for list of items)
  Future<ApiResponse<List<TaskHistoryItemModel>>> getTaskHistory({
    int? month,
    int? year,
    String? status,
    int perPage = 15,
  }) async {
    final response = await getTaskHistoryResponse(
      month: month,
      year: year,
      status: status,
      perPage: perPage,
    );

    return ApiResponse<List<TaskHistoryItemModel>>(
      success: response.success,
      message: response.message,
      data: response.data?.items ?? [],
      errors: response.errors,
      statusCode: response.statusCode,
      rawJson: response.rawJson,
    );
  }

  /// 4.4 Manager Portal: List Task Completions for Review
  Future<ApiResponse<ManagerTaskCompletionsResponse>> getManagerTaskCompletions({
    String? date,
    int? month,
    int? branchId,
    String? status,
    int perPage = 20,
  }) async {
    final Map<String, String> params = {
      'per_page': perPage.toString(),
    };
    if (date != null) params['date'] = date;
    if (month != null) params['month'] = month.toString();
    if (branchId != null) params['branch_id'] = branchId.toString();
    if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
      params['status'] = status.toLowerCase();
    }

    return await _client.get<ManagerTaskCompletionsResponse>(
      ApiConstants.managerTaskCompletionsEndpoint,
      queryParams: params,
      fromJson: (json) => ManagerTaskCompletionsResponse.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 4.5 Manager Portal: Approve or Reject Task Completion
  Future<ApiResponse<Map<String, dynamic>>> reviewManagerTask({
    required int completionId,
    required String status, // 'approved' or 'rejected'
    String? comment,
  }) async {
    return await _client.post<Map<String, dynamic>>(
      ApiConstants.managerTaskReviewEndpoint,
      body: {
        'completion_id': completionId,
        'status': status,
        if (comment != null) 'manager_comment': comment,
      },
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  // =========================================================================
  // 5. Performly Target & Sales Performance Module
  // =========================================================================

  /// 5.1 Staff: My Targets & Performance Summary
  Future<ApiResponse<PerformlyTargetsResponse>> getMyTargets({String? status}) async {
    final Map<String, String> params = {};
    if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
      params['status'] = status.toLowerCase();
    }

    return await _client.get<PerformlyTargetsResponse>(
      ApiConstants.targetsEndpoint,
      queryParams: params,
      fromJson: (json) => PerformlyTargetsResponse.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 5.2 Staff: Target Detailed Breakdown
  Future<ApiResponse<TargetModel>> getTargetDetails(int targetId) async {
    return await _client.get<TargetModel>(
      "${ApiConstants.targetsEndpoint}/$targetId",
      fromJson: (json) => TargetModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 5.3 Staff: Log Sales / Achievement Progress
  Future<ApiResponse<Map<String, dynamic>>> logSale({
    int? targetId,
    required String logDate,
    required String entryType, // 'item_wise' or 'overall'
    int? productId,
    required double quantity,
    double? unitPrice,
    double? totalAmount,
    String? customerName,
    String? invoiceNo,
    String? notes,
  }) async {
    return await _client.post<Map<String, dynamic>>(
      ApiConstants.salesLogsEndpoint,
      body: {
        if (targetId != null) 'target_id': targetId,
        'log_date': logDate,
        'entry_type': entryType,
        if (productId != null) 'product_id': productId,
        'quantity': quantity,
        if (unitPrice != null) 'unit_price': unitPrice,
        if (totalAmount != null) 'total_amount': totalAmount,
        if (customerName != null) 'customer_name': customerName,
        if (invoiceNo != null) 'invoice_no': invoiceNo,
        if (notes != null) 'notes': notes,
      },
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  /// 5.4 Staff: My Sales Logs History
  Future<ApiResponse<SalesLogsHistoryResponse>> getMySalesLogs({
    String? status,
    int? month,
    int? year,
    int? targetId,
    int perPage = 15,
  }) async {
    final Map<String, String> params = {
      'per_page': perPage.toString(),
    };
    if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
      params['status'] = status.toLowerCase();
    }
    if (month != null) params['month'] = month.toString();
    if (year != null) params['year'] = year.toString();
    if (targetId != null) params['target_id'] = targetId.toString();

    return await _client.get<SalesLogsHistoryResponse>(
      ApiConstants.mySalesLogsEndpoint,
      queryParams: params,
      fromJson: (json) => SalesLogsHistoryResponse.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 5.5 Products / Items for Item-wise Selection
  Future<ApiResponse<List<PerformlyProductModel>>> getPerformlyProducts() async {
    return await _client.get<List<PerformlyProductModel>>(
      ApiConstants.performlyProductsEndpoint,
      fromJson: (json) {
        List<dynamic> list = [];
        if (json is Map && json['products'] is List) {
          list = json['products'] as List;
        } else if (json is List) {
          list = json;
        }

        return list
            .map((item) => PerformlyProductModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
      },
    );
  }

  /// 5.6 Manager Portal: List Submitted Sales Logs
  Future<ApiResponse<List<SalesLogModel>>> managerGetSalesLogs({String? status}) async {
    final Map<String, String> params = {};
    if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
      params['status'] = status.toLowerCase();
    }

    return await _client.get<List<SalesLogModel>>(
      ApiConstants.managerSalesLogsEndpoint,
      queryParams: params,
      fromJson: (json) {
        List<dynamic> list = [];
        if (json is Map && json['items'] is List) {
          list = json['items'] as List;
        } else if (json is List) {
          list = json;
        }

        return list
            .map((item) => SalesLogModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
      },
    );
  }

  /// 5.7 Manager Portal: Approve Sales Log
  Future<ApiResponse<Map<String, dynamic>>> managerApproveSalesLog(int logId) async {
    return await _client.post<Map<String, dynamic>>(
      "${ApiConstants.managerSalesLogsEndpoint}/$logId/approve",
      body: {},
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  /// 5.8 Manager Portal: Reject Sales Log
  Future<ApiResponse<Map<String, dynamic>>> managerRejectSalesLog(int logId, String reason) async {
    return await _client.post<Map<String, dynamic>>(
      "${ApiConstants.managerSalesLogsEndpoint}/$logId/reject",
      body: {'reason': reason},
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  // =========================================================================
  // 6. Manager Panel - Employee Management (Full CRUD + Security)
  // =========================================================================

  /// 6.1 Get Dropdowns / Options for Creating & Editing Staff
  Future<ApiResponse<EmployeeOptionsModel>> getEmployeeOptions() async {
    return await _client.get<EmployeeOptionsModel>(
      ApiConstants.managerEmployeeOptionsEndpoint,
      fromJson: (json) => EmployeeOptionsModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 6.2 List All Employees (with filters & pagination)
  Future<ApiResponse<ManagerEmployeesResponse>> getManagerEmployees({
    String? search,
    String? status, // 'active' or 'disabled'
    int? branchId,
    int? departmentId,
    int perPage = 25,
    int page = 1,
  }) async {
    final Map<String, String> params = {
      'per_page': perPage.toString(),
      'page': page.toString(),
    };
    if (search != null && search.trim().isNotEmpty) params['search'] = search.trim();
    if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
      params['status'] = status.toLowerCase();
    }
    if (branchId != null) params['branch_id'] = branchId.toString();
    if (departmentId != null) params['department_id'] = departmentId.toString();

    return await _client.get<ManagerEmployeesResponse>(
      ApiConstants.managerEmployeesEndpoint,
      queryParams: params,
      fromJson: (json) => ManagerEmployeesResponse.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 6.3 View Single Employee Details
  Future<ApiResponse<ManagerEmployeeModel>> getManagerEmployee(int id) async {
    return await _client.get<ManagerEmployeeModel>(
      "${ApiConstants.managerEmployeesEndpoint}/$id",
      fromJson: (json) {
        final data = json is Map && json['data'] is Map ? json['data'] : json;
        return ManagerEmployeeModel.fromJson(Map<String, dynamic>.from(data as Map));
      },
    );
  }

  /// 6.4 Create / Add New Employee
  Future<ApiResponse<Map<String, dynamic>>> createEmployee(Map<String, dynamic> data) async {
    return await _client.post<Map<String, dynamic>>(
      ApiConstants.managerEmployeesEndpoint,
      body: data,
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  /// 6.5 Edit / Update Employee
  Future<ApiResponse<Map<String, dynamic>>> updateEmployee(int id, Map<String, dynamic> data) async {
    return await _client.put<Map<String, dynamic>>(
      "${ApiConstants.managerEmployeesEndpoint}/$id",
      body: data,
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  /// 6.6 Disable / Enable Employee (Toggle Status)
  Future<ApiResponse<Map<String, dynamic>>> toggleEmployeeStatus(int id) async {
    return await _client.post<Map<String, dynamic>>(
      "${ApiConstants.managerEmployeesEndpoint}/$id/toggle-status",
      body: {},
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  /// 6.7 Change / Reset Staff Password
  Future<ApiResponse<Map<String, dynamic>>> changeEmployeePassword({
    required int id,
    required String password,
    required String passwordConfirmation,
  }) async {
    return await _client.post<Map<String, dynamic>>(
      "${ApiConstants.managerEmployeesEndpoint}/$id/change-password",
      body: {
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  /// 6.8 Delete Employee
  Future<ApiResponse<Map<String, dynamic>>> deleteEmployee(int id) async {
    return await _client.delete<Map<String, dynamic>>(
      "${ApiConstants.managerEmployeesEndpoint}/$id",
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  // =========================================================================
  // 7. Manager Panel - Staff Attendance Management
  // =========================================================================

  /// 7.1 View Staff Attendance
  Future<ApiResponse<List<ManagerAttendanceModel>>> getManagerAttendances({
    String? date,
    int? branchId,
    int? employeeId,
    String? status,
  }) async {
    final Map<String, String> params = {};
    if (date != null) params['date'] = date;
    if (branchId != null) params['branch_id'] = branchId.toString();
    if (employeeId != null) params['employee_id'] = employeeId.toString();
    if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
      params['status'] = status.toLowerCase();
    }

    return await _client.get<List<ManagerAttendanceModel>>(
      ApiConstants.managerAttendancesEndpoint,
      queryParams: params,
      fromJson: (json) {
        List<dynamic> list = [];
        if (json is Map && json['data'] is List) {
          list = json['data'] as List;
        } else if (json is Map && json['attendances'] is List) {
          list = json['attendances'] as List;
        } else if (json is List) {
          list = json;
        }

        return list
            .map((item) => ManagerAttendanceModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
      },
    );
  }

  /// 7.2 Create Attendance Manually
  Future<ApiResponse<Map<String, dynamic>>> createAttendanceManually(Map<String, dynamic> data) async {
    return await _client.post<Map<String, dynamic>>(
      ApiConstants.managerAttendancesEndpoint,
      body: data,
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  /// 7.3 Edit Attendance
  Future<ApiResponse<Map<String, dynamic>>> updateAttendance(int id, Map<String, dynamic> data) async {
    return await _client.put<Map<String, dynamic>>(
      "${ApiConstants.managerAttendancesEndpoint}/$id",
      body: data,
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  /// 7.4 Delete Attendance
  Future<ApiResponse<Map<String, dynamic>>> deleteAttendance(int id) async {
    return await _client.delete<Map<String, dynamic>>(
      "${ApiConstants.managerAttendancesEndpoint}/$id",
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  // =========================================================================
  // 8. Manager Panel - Staff Leave Requests & Approvals
  // =========================================================================

  /// 8.1 View All Leave Requests
  Future<ApiResponse<List<ManagerLeaveModel>>> getManagerLeaves({
    String? status, // 'pending', 'approved', 'rejected'
    int? month,
    int? year,
    int? employeeId,
  }) async {
    final Map<String, String> params = {};
    if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
      params['status'] = status.toLowerCase();
    }
    if (month != null) params['month'] = month.toString();
    if (year != null) params['year'] = year.toString();
    if (employeeId != null) params['employee_id'] = employeeId.toString();

    return await _client.get<List<ManagerLeaveModel>>(
      ApiConstants.managerLeavesEndpoint,
      queryParams: params,
      fromJson: (json) {
        List<dynamic> list = [];
        if (json is Map && json['data'] is List) {
          list = json['data'] as List;
        } else if (json is Map && json['leaves'] is List) {
          list = json['leaves'] as List;
        } else if (json is List) {
          list = json;
        }

        return list
            .map((item) => ManagerLeaveModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
      },
    );
  }

  /// 8.2 Approve / Reject Leave with Comment
  Future<ApiResponse<Map<String, dynamic>>> reviewManagerLeave({
    required int leaveId,
    required String status, // 'approved' or 'rejected'
    String? comment,
  }) async {
    return await _client.post<Map<String, dynamic>>(
      "${ApiConstants.managerLeavesEndpoint}/$leaveId/action",
      body: {
        'status': status,
        if (comment != null) 'approver_comment': comment,
      },
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  /// 8.3 Create Leave for Staff
  Future<ApiResponse<Map<String, dynamic>>> createLeaveForStaff(Map<String, dynamic> data) async {
    return await _client.post<Map<String, dynamic>>(
      ApiConstants.managerLeavesEndpoint,
      body: data,
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  // =========================================================================
  // 9. Manager Panel - Daily Branch Tasks (CRUD)
  // =========================================================================

  /// 9.1 List Branch Tasks
  Future<ApiResponse<List<ManagerBranchTaskCrudModel>>> getManagerBranchTasks({int? branchId}) async {
    final Map<String, String> params = {};
    if (branchId != null) params['branch_id'] = branchId.toString();

    return await _client.get<List<ManagerBranchTaskCrudModel>>(
      ApiConstants.managerBranchTasksEndpoint,
      queryParams: params,
      fromJson: (json) {
        List<dynamic> list = [];
        if (json is Map && json['data'] is List) {
          list = json['data'] as List;
        } else if (json is Map && json['tasks'] is List) {
          list = json['tasks'] as List;
        } else if (json is List) {
          list = json;
        }

        return list
            .map((item) => ManagerBranchTaskCrudModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
      },
    );
  }

  /// 9.2 Create Branch Task
  Future<ApiResponse<Map<String, dynamic>>> createManagerBranchTask(Map<String, dynamic> data) async {
    return await _client.post<Map<String, dynamic>>(
      ApiConstants.managerBranchTasksEndpoint,
      body: data,
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  /// 9.3 Edit Branch Task
  Future<ApiResponse<Map<String, dynamic>>> updateManagerBranchTask(int id, Map<String, dynamic> data) async {
    return await _client.put<Map<String, dynamic>>(
      "${ApiConstants.managerBranchTasksEndpoint}/$id",
      body: data,
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  /// 9.4 Delete Branch Task
  Future<ApiResponse<Map<String, dynamic>>> deleteManagerBranchTask(int id) async {
    return await _client.delete<Map<String, dynamic>>(
      "${ApiConstants.managerBranchTasksEndpoint}/$id",
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  // =========================================================================
  // 10. Manager Panel - Performly Sales Targets (CRUD)
  // =========================================================================

  /// 10.1 View All Targets
  Future<ApiResponse<List<ManagerSalesTargetModel>>> getManagerTargets({
    int? userId,
    String? status,
    String? periodType,
  }) async {
    final Map<String, String> params = {};
    if (userId != null) params['user_id'] = userId.toString();
    if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
      params['status'] = status.toLowerCase();
    }
    if (periodType != null) params['period_type'] = periodType;

    return await _client.get<List<ManagerSalesTargetModel>>(
      ApiConstants.managerTargetsEndpoint,
      queryParams: params,
      fromJson: (json) {
        List<dynamic> list = [];
        if (json is Map && json['data'] is List) {
          list = json['data'] as List;
        } else if (json is Map && json['targets'] is List) {
          list = json['targets'] as List;
        } else if (json is List) {
          list = json;
        }

        return list
            .map((item) => ManagerSalesTargetModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
      },
    );
  }

  /// 10.2 Create Sales Target
  Future<ApiResponse<Map<String, dynamic>>> createManagerTarget(Map<String, dynamic> data) async {
    return await _client.post<Map<String, dynamic>>(
      ApiConstants.managerTargetsEndpoint,
      body: data,
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  /// 10.3 Edit Sales Target
  Future<ApiResponse<Map<String, dynamic>>> updateManagerTarget(int id, Map<String, dynamic> data) async {
    return await _client.put<Map<String, dynamic>>(
      "${ApiConstants.managerTargetsEndpoint}/$id",
      body: data,
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  /// 10.4 Delete Sales Target
  Future<ApiResponse<Map<String, dynamic>>> deleteManagerTarget(int id) async {
    return await _client.delete<Map<String, dynamic>>(
      "${ApiConstants.managerTargetsEndpoint}/$id",
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }
}
