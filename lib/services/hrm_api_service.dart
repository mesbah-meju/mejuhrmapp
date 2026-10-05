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

  /// 3.1 Unified Clock In / Clock Out Endpoint
  Future<ApiResponse<AttendanceRecord>> clockInOut({
    required String type, // 'clockin' or 'clockout'
    double? latitude,
    double? longitude,
    double? accuracy,
    String? notes,
  }) async {
    final body = <String, dynamic>{
      'type': type,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (accuracy != null) 'accuracy': accuracy,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    };

    return await _client.post<AttendanceRecord>(
      ApiConstants.clockInOutEndpoint,
      body: body,
      fromJson: (json) => AttendanceRecord.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 3.1.1 Clock In with GPS & Notes
  Future<ApiResponse<AttendanceRecord>> clockIn({
    required double latitude,
    required double longitude,
    double? accuracy,
    String? notes,
  }) async {
    return await _client.post<AttendanceRecord>(
      ApiConstants.clockInEndpoint,
      body: {
        'latitude': latitude,
        'longitude': longitude,
        if (accuracy != null) 'accuracy': accuracy,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      },
      fromJson: (json) => AttendanceRecord.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 3.2 Clock Out with GPS & Notes
  Future<ApiResponse<AttendanceRecord>> clockOut({
    required double latitude,
    required double longitude,
    double? accuracy,
    String? notes,
  }) async {
    return await _client.post<AttendanceRecord>(
      ApiConstants.clockOutEndpoint,
      body: {
        'latitude': latitude,
        'longitude': longitude,
        if (accuracy != null) 'accuracy': accuracy,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      },
      fromJson: (json) => AttendanceRecord.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 3.2.1 Offline Punch Batch Synchronization
  Future<ApiResponse<AttendanceSyncResponse>> syncAttendanceBatch(List<Map<String, dynamic>> punches) async {
    return await _client.post<AttendanceSyncResponse>(
      ApiConstants.attendanceSyncEndpoint,
      body: {
        'punches': punches,
      },
      fromJson: (json) => AttendanceSyncResponse.fromJson(Map<String, dynamic>.from(json as Map)),
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

  /// 3.5 Comprehensive Staff Monthly / Custom Period Report
  Future<ApiResponse<StaffAttendanceReportResponse>> getStaffAttendanceReport({
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

    return await _client.get<StaffAttendanceReportResponse>(
      ApiConstants.attendanceReportEndpoint,
      queryParams: params,
      fromJson: (json) => StaffAttendanceReportResponse.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  // =========================================================================
  // 4. Tasks API (Branch Tasks & Completions)
  // =========================================================================

  /// 4.1 Get Today's Tasks & Summary
  Future<ApiResponse<TodayTasksResponse>> getTodayTasks({String? date}) async {
    final Map<String, String> params = {};
    if (date != null && date.isNotEmpty) params['date'] = date;

    return await _client.get<TodayTasksResponse>(
      ApiConstants.tasksTodayEndpoint,
      queryParams: params,
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

  /// 4.3 Staff: Create Additional / Ad-Hoc Task
  Future<ApiResponse<BranchTaskModel>> createAdditionalTask({
    required String taskName,
    String? description,
    String? notes,
    bool isCompleted = true,
  }) async {
    return await _client.post<BranchTaskModel>(
      ApiConstants.tasksAdditionalEndpoint,
      body: {
        'task_name': taskName,
        if (description != null && description.isNotEmpty) 'description': description,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
        'is_completed': isCompleted,
      },
      fromJson: (json) => BranchTaskModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 4.4 Staff: Task Performance & Analytics Report
  Future<ApiResponse<StaffTaskReportResponse>> getStaffTaskReport({
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

    return await _client.get<StaffTaskReportResponse>(
      ApiConstants.tasksReportEndpoint,
      queryParams: params,
      fromJson: (json) => StaffTaskReportResponse.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 4.5 Staff: Personal Task Completion History (Full Response with Pagination)
  Future<ApiResponse<TaskHistoryResponse>> getTaskHistoryResponse({
    int? month,
    int? year,
    String? startDate,
    String? endDate,
    String? status,
    int perPage = 20,
  }) async {
    final Map<String, String> params = {
      'per_page': perPage.toString(),
    };
    if (month != null) params['month'] = month.toString();
    if (year != null) params['year'] = year.toString();
    if (startDate != null) params['start_date'] = startDate;
    if (endDate != null) params['end_date'] = endDate;
    if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
      params['status'] = status.toLowerCase();
    }

    return await _client.get<TaskHistoryResponse>(
      ApiConstants.tasksHistoryEndpoint,
      queryParams: params,
      fromJson: (json) => TaskHistoryResponse.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 4.5 Task History (Helper for list of items)
  Future<ApiResponse<List<TaskHistoryItemModel>>> getTaskHistory({
    int? month,
    int? year,
    String? startDate,
    String? endDate,
    String? status,
    int perPage = 20,
  }) async {
    final response = await getTaskHistoryResponse(
      month: month,
      year: year,
      startDate: startDate,
      endDate: endDate,
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

  /// 4.6 Manager Portal: List All Branch Tasks
  Future<ApiResponse<List<ManagerBranchTaskModel>>> managerGetBranchTasks({
    int? branchId,
    bool? isActive,
  }) async {
    final Map<String, String> params = {};
    if (branchId != null) params['branch_id'] = branchId.toString();
    if (isActive != null) params['is_active'] = isActive ? '1' : '0';

    return await _client.get<List<ManagerBranchTaskModel>>(
      ApiConstants.managerBranchTasksEndpoint,
      queryParams: params,
      fromJson: (json) {
        List<dynamic> list = [];
        if (json is Map && json['tasks'] is List) {
          list = json['tasks'] as List;
        } else if (json is List) {
          list = json;
        }

        return list
            .map((item) => ManagerBranchTaskModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
      },
    );
  }

  /// 4.7 Manager Portal: Create Branch Task
  Future<ApiResponse<ManagerBranchTaskModel>> managerCreateBranchTask({
    required String taskName,
    String? description,
    int? branchId,
    bool isActive = true,
  }) async {
    return await _client.post<ManagerBranchTaskModel>(
      ApiConstants.managerBranchTasksEndpoint,
      body: {
        'task_name': taskName,
        if (description != null && description.isNotEmpty) 'description': description,
        if (branchId != null) 'branch_id': branchId,
        'is_active': isActive,
      },
      fromJson: (json) => ManagerBranchTaskModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 4.8 Manager Portal: Update Branch Task
  Future<ApiResponse<ManagerBranchTaskModel>> managerUpdateBranchTask({
    required int id,
    required String taskName,
    String? description,
    int? branchId,
    bool? isActive,
  }) async {
    return await _client.put<ManagerBranchTaskModel>(
      "${ApiConstants.managerBranchTasksEndpoint}/$id",
      body: {
        'task_name': taskName,
        if (description != null) 'description': description,
        if (branchId != null) 'branch_id': branchId,
        if (isActive != null) 'is_active': isActive,
      },
      fromJson: (json) => ManagerBranchTaskModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 4.9 Manager Portal: Delete Branch Task
  Future<ApiResponse<dynamic>> managerDeleteBranchTask(int id) async {
    return await _client.delete<dynamic>(
      "${ApiConstants.managerBranchTasksEndpoint}/$id",
    );
  }

  /// 4.10 Manager Portal: List Task Completions for Review
  Future<ApiResponse<ManagerTaskCompletionsResponse>> getManagerTaskCompletions({
    String? date,
    int? month,
    int? year,
    String? startDate,
    String? endDate,
    int? branchId,
    int? employeeId,
    String? status,
    int perPage = 20,
  }) async {
    final Map<String, String> params = {
      'per_page': perPage.toString(),
    };
    if (date != null) params['date'] = date;
    if (month != null) params['month'] = month.toString();
    if (year != null) params['year'] = year.toString();
    if (startDate != null) params['start_date'] = startDate;
    if (endDate != null) params['end_date'] = endDate;
    if (branchId != null) params['branch_id'] = branchId.toString();
    if (employeeId != null) params['employee_id'] = employeeId.toString();
    if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
      params['status'] = status.toLowerCase();
    }

    return await _client.get<ManagerTaskCompletionsResponse>(
      ApiConstants.managerTaskCompletionsEndpoint,
      queryParams: params,
      fromJson: (json) => ManagerTaskCompletionsResponse.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 4.11 Manager Portal: Approve or Reject Task Completion
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

  /// 4.12 Manager Portal: Task Analytics & Performance Report
  Future<ApiResponse<ManagerTaskReportResponse>> managerGetTasksReport({
    String? startDate,
    String? endDate,
    int? month,
    int? year,
    int? branchId,
    int? departmentId,
    int? employeeId,
  }) async {
    final Map<String, String> params = {};
    if (startDate != null) params['start_date'] = startDate;
    if (endDate != null) params['end_date'] = endDate;
    if (month != null) params['month'] = month.toString();
    if (year != null) params['year'] = year.toString();
    if (branchId != null) params['branch_id'] = branchId.toString();
    if (departmentId != null) params['department_id'] = departmentId.toString();
    if (employeeId != null) params['employee_id'] = employeeId.toString();

    return await _client.get<ManagerTaskReportResponse>(
      ApiConstants.managerTasksReportEndpoint,
      queryParams: params,
      fromJson: (json) => ManagerTaskReportResponse.fromJson(Map<String, dynamic>.from(json as Map)),
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
  Future<ApiResponse<EmployeeOptionsModel>> getEmployeeOptions({
    dynamic branchId,
    dynamic departmentId,
  }) async {
    final Map<String, String> params = {};
    if (branchId != null && branchId.toString().isNotEmpty) {
      params['branch_id'] = branchId.toString();
    }
    if (departmentId != null && departmentId.toString().isNotEmpty) {
      params['department_id'] = departmentId.toString();
    }

    return await _client.get<EmployeeOptionsModel>(
      ApiConstants.managerEmployeeOptionsEndpoint,
      queryParams: params,
      fromJson: (json) => EmployeeOptionsModel.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 6.1.1 Get Departments by Branch ID
  Future<ApiResponse<List<DepartmentOption>>> getDepartments({dynamic branchId}) async {
    final Map<String, String> params = {};
    if (branchId != null) params['branch_id'] = branchId.toString();

    return await _client.get<List<DepartmentOption>>(
      ApiConstants.managerDepartmentsEndpoint,
      queryParams: params,
      fromJson: (json) {
        List<dynamic> list = [];
        if (json is Map && json['data'] is List) {
          list = json['data'] as List;
        } else if (json is List) {
          list = json;
        }
        return list.map((item) => DepartmentOption.fromJson(Map<String, dynamic>.from(item as Map))).toList();
      },
    );
  }

  /// 6.1.2 Get Designations by Department ID & Branch ID
  Future<ApiResponse<List<DesignationOption>>> getDesignations({
    dynamic departmentId,
    dynamic branchId,
  }) async {
    final Map<String, String> params = {};
    if (departmentId != null) params['department_id'] = departmentId.toString();
    if (branchId != null) params['branch_id'] = branchId.toString();

    return await _client.get<List<DesignationOption>>(
      ApiConstants.managerDesignationsEndpoint,
      queryParams: params,
      fromJson: (json) {
        List<dynamic> list = [];
        if (json is Map && json['data'] is List) {
          list = json['data'] as List;
        } else if (json is List) {
          list = json;
        }
        return list.map((item) => DesignationOption.fromJson(Map<String, dynamic>.from(item as Map))).toList();
      },
    );
  }

  /// 6.2 List All Employees (with filters & pagination)
  Future<ApiResponse<ManagerEmployeesResponse>> getManagerEmployees({
    String? search,
    String? status, // 'active', 'disabled', 'all'
    dynamic branchId,
    dynamic departmentId,
    dynamic designationId,
    String? employmentType,
    String? gender,
    String? sort,
    String? direction,
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
    if (branchId != null && branchId.toString().isNotEmpty) {
      params['branch_id'] = branchId.toString();
    }
    if (departmentId != null && departmentId.toString().isNotEmpty) {
      params['department_id'] = departmentId.toString();
    }
    if (designationId != null && designationId.toString().isNotEmpty) {
      params['designation_id'] = designationId.toString();
    }
    if (employmentType != null && employmentType.isNotEmpty && employmentType.toLowerCase() != 'all') {
      params['employment_type'] = employmentType;
    }
    if (gender != null && gender.isNotEmpty && gender.toLowerCase() != 'all') {
      params['gender'] = gender;
    }
    if (sort != null && sort.isNotEmpty) params['sort'] = sort;
    if (direction != null && direction.isNotEmpty) params['direction'] = direction;

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

  /// 6.6 Delete Employee Document
  Future<ApiResponse<Map<String, dynamic>>> deleteEmployeeDocument(int employeeId, int documentId) async {
    return await _client.delete<Map<String, dynamic>>(
      "${ApiConstants.managerEmployeesEndpoint}/$employeeId/documents/$documentId",
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  /// 6.7 Disable / Enable Employee (Toggle Status)
  Future<ApiResponse<Map<String, dynamic>>> toggleEmployeeStatus(int id) async {
    return await _client.post<Map<String, dynamic>>(
      "${ApiConstants.managerEmployeesEndpoint}/$id/toggle-status",
      body: {},
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  /// 6.8 Change / Reset Staff Password
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

  /// 6.9 Delete Employee
  Future<ApiResponse<Map<String, dynamic>>> deleteEmployee(int id) async {
    return await _client.delete<Map<String, dynamic>>(
      "${ApiConstants.managerEmployeesEndpoint}/$id",
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  // =========================================================================
  // 7. Manager Panel - Staff Attendance Management
  // =========================================================================

  /// 7.1 Live Today Team Overview (Manager)
  Future<ApiResponse<ManagerAttendanceOverviewResponse>> getManagerAttendanceOverview({
    String? date,
    dynamic branchId,
    dynamic departmentId,
  }) async {
    final Map<String, String> params = {};
    if (date != null && date.isNotEmpty) params['date'] = date;
    if (branchId != null && branchId.toString().isNotEmpty) {
      params['branch_id'] = branchId.toString();
    }
    if (departmentId != null && departmentId.toString().isNotEmpty) {
      params['department_id'] = departmentId.toString();
    }

    return await _client.get<ManagerAttendanceOverviewResponse>(
      ApiConstants.managerAttendanceOverviewEndpoint,
      queryParams: params,
      fromJson: (json) => ManagerAttendanceOverviewResponse.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 7.2 Filterable Paginated Attendance List (Manager)
  Future<ApiResponse<ManagerAttendanceListResponse>> getManagerAttendanceList({
    String? search,
    dynamic employeeId,
    dynamic branchId,
    dynamic departmentId,
    dynamic designationId,
    String? date,
    String? startDate,
    String? endDate,
    int? month,
    int? year,
    String? status,
    int perPage = 20,
    int page = 1,
  }) async {
    final Map<String, String> params = {
      'per_page': perPage.toString(),
      'page': page.toString(),
    };
    if (search != null && search.trim().isNotEmpty) params['search'] = search.trim();
    if (employeeId != null && employeeId.toString().isNotEmpty) {
      params['employee_id'] = employeeId.toString();
    }
    if (branchId != null && branchId.toString().isNotEmpty) {
      params['branch_id'] = branchId.toString();
    }
    if (departmentId != null && departmentId.toString().isNotEmpty) {
      params['department_id'] = departmentId.toString();
    }
    if (designationId != null && designationId.toString().isNotEmpty) {
      params['designation_id'] = designationId.toString();
    }
    if (date != null && date.isNotEmpty) params['date'] = date;
    if (startDate != null && startDate.isNotEmpty) params['start_date'] = startDate;
    if (endDate != null && endDate.isNotEmpty) params['end_date'] = endDate;
    if (month != null) params['month'] = month.toString();
    if (year != null) params['year'] = year.toString();
    if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
      params['status'] = status.toLowerCase();
    }

    return await _client.get<ManagerAttendanceListResponse>(
      ApiConstants.managerAttendancesEndpoint,
      queryParams: params,
      fromJson: (json) => ManagerAttendanceListResponse.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 7.3 Helper for Simple List of Manager Attendances
  Future<ApiResponse<List<ManagerAttendanceModel>>> getManagerAttendances({
    String? date,
    int? branchId,
    int? employeeId,
    String? status,
  }) async {
    final res = await getManagerAttendanceList(
      date: date,
      branchId: branchId,
      employeeId: employeeId,
      status: status,
      perPage: 100,
    );

    return ApiResponse<List<ManagerAttendanceModel>>(
      success: res.success,
      message: res.message,
      data: res.data?.items ?? [],
      errors: res.errors,
      statusCode: res.statusCode,
      rawJson: res.rawJson,
    );
  }

  /// 7.4 Filterable Attendance Analytics Report (Manager)
  Future<ApiResponse<ManagerAttendanceReportResponse>> getManagerAttendanceReport({
    int? month,
    int? year,
    String? startDate,
    String? endDate,
    dynamic branchId,
    dynamic departmentId,
    dynamic designationId,
    dynamic employeeId,
    String? search,
  }) async {
    final Map<String, String> params = {};
    if (month != null) params['month'] = month.toString();
    if (year != null) params['year'] = year.toString();
    if (startDate != null && startDate.isNotEmpty) params['start_date'] = startDate;
    if (endDate != null && endDate.isNotEmpty) params['end_date'] = endDate;
    if (branchId != null && branchId.toString().isNotEmpty) {
      params['branch_id'] = branchId.toString();
    }
    if (departmentId != null && departmentId.toString().isNotEmpty) {
      params['department_id'] = departmentId.toString();
    }
    if (designationId != null && designationId.toString().isNotEmpty) {
      params['designation_id'] = designationId.toString();
    }
    if (employeeId != null && employeeId.toString().isNotEmpty) {
      params['employee_id'] = employeeId.toString();
    }
    if (search != null && search.trim().isNotEmpty) params['search'] = search.trim();

    return await _client.get<ManagerAttendanceReportResponse>(
      ApiConstants.managerAttendanceReportEndpoint,
      queryParams: params,
      fromJson: (json) => ManagerAttendanceReportResponse.fromJson(Map<String, dynamic>.from(json as Map)),
    );
  }

  /// 7.5 Create Attendance Manually (Manager)
  Future<ApiResponse<Map<String, dynamic>>> createAttendanceManually(Map<String, dynamic> data) async {
    return await _client.post<Map<String, dynamic>>(
      ApiConstants.managerAttendancesEndpoint,
      body: data,
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  /// 7.6 Edit Attendance (Manager)
  Future<ApiResponse<Map<String, dynamic>>> updateAttendance(int id, Map<String, dynamic> data) async {
    return await _client.put<Map<String, dynamic>>(
      "${ApiConstants.managerAttendancesEndpoint}/$id",
      body: data,
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  /// 7.7 Delete Attendance (Manager)
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
