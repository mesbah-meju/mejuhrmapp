class GenericOption {
  final dynamic id;
  final String name;

  GenericOption({required this.id, required this.name});

  factory GenericOption.fromJson(Map<String, dynamic> json) {
    return GenericOption(
      id: json['id'],
      name: (json['name'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class BranchOption {
  final int id;
  final String name;

  BranchOption({required this.id, required this.name});

  factory BranchOption.fromJson(Map<String, dynamic> json) {
    return BranchOption(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: (json['name'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class DepartmentOption {
  final int id;
  final String name;
  final int? branchId;

  DepartmentOption({required this.id, required this.name, this.branchId});

  factory DepartmentOption.fromJson(Map<String, dynamic> json) {
    return DepartmentOption(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: (json['name'] ?? '').toString(),
      branchId: json['branch_id'] != null ? int.tryParse(json['branch_id'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, if (branchId != null) 'branch_id': branchId};
}

class DesignationOption {
  final int id;
  final String name;
  final int? branchId;
  final int? departmentId;

  DesignationOption({required this.id, required this.name, this.branchId, this.departmentId});

  factory DesignationOption.fromJson(Map<String, dynamic> json) {
    return DesignationOption(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: (json['name'] ?? '').toString(),
      branchId: json['branch_id'] != null ? int.tryParse(json['branch_id'].toString()) : null,
      departmentId: json['department_id'] != null ? int.tryParse(json['department_id'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (branchId != null) 'branch_id': branchId,
        if (departmentId != null) 'department_id': departmentId,
      };
}

class ShiftOption {
  final int id;
  final String name;
  final String? startTime;
  final String? endTime;

  ShiftOption({required this.id, required this.name, this.startTime, this.endTime});

  factory ShiftOption.fromJson(Map<String, dynamic> json) {
    return ShiftOption(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: (json['name'] ?? '').toString(),
      startTime: json['start_time']?.toString(),
      endTime: json['end_time']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (startTime != null) 'start_time': startTime,
        if (endTime != null) 'end_time': endTime,
      };
}

class EmployeeOptionsModel {
  final String generatedEmployeeId;
  final List<BranchOption> branches;
  final List<DepartmentOption> departments;
  final List<DesignationOption> designations;
  final List<ShiftOption> shifts;
  final List<GenericOption> employmentTypes;
  final List<GenericOption> genders;

  EmployeeOptionsModel({
    required this.generatedEmployeeId,
    required this.branches,
    required this.departments,
    required this.designations,
    required this.shifts,
    required this.employmentTypes,
    required this.genders,
  });

  factory EmployeeOptionsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic> ? json['data'] : json;

    return EmployeeOptionsModel(
      generatedEmployeeId: (data['generated_employee_id'] ?? '').toString(),
      branches: (data['branches'] as List? ?? [])
          .map((item) => BranchOption.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
      departments: (data['departments'] as List? ?? [])
          .map((item) => DepartmentOption.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
      designations: (data['designations'] as List? ?? [])
          .map((item) => DesignationOption.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
      shifts: (data['shifts'] as List? ?? [])
          .map((item) => ShiftOption.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
      employmentTypes: (data['employment_types'] as List? ?? [])
          .map((item) => GenericOption.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
      genders: (data['genders'] as List? ?? [])
          .map((item) => GenericOption.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
    );
  }
}

class ManagerEmployeeModel {
  final int id;
  final int? userId;
  final String employeeId;
  final String name;
  final String email;
  final String? mobileNo;
  final bool isActive;
  final bool isDisabled;
  final String? avatar;
  final BranchOption? branch;
  final DepartmentOption? department;
  final DesignationOption? designation;
  final ShiftOption? shift;
  final String? employmentType;
  final String? dateOfJoining;
  final String? dateOfBirth;
  final String? gender;
  final double basicSalary;
  final int hoursPerDay;
  final int daysPerWeek;
  final String? addressLine1;
  final String? city;
  final String? emergencyContactName;
  final String? emergencyContactNumber;

  ManagerEmployeeModel({
    required this.id,
    this.userId,
    required this.employeeId,
    required this.name,
    required this.email,
    this.mobileNo,
    this.isActive = true,
    this.isDisabled = false,
    this.avatar,
    this.branch,
    this.department,
    this.designation,
    this.shift,
    this.employmentType,
    this.dateOfJoining,
    this.dateOfBirth,
    this.gender,
    this.basicSalary = 0.0,
    this.hoursPerDay = 8,
    this.daysPerWeek = 6,
    this.addressLine1,
    this.city,
    this.emergencyContactName,
    this.emergencyContactNumber,
  });

  factory ManagerEmployeeModel.fromJson(Map<String, dynamic> json) {
    return ManagerEmployeeModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userId: json['user_id'] != null ? int.tryParse(json['user_id'].toString()) : null,
      employeeId: (json['employee_id'] ?? '').toString(),
      name: (json['name'] ?? json['user']?['name'] ?? '').toString(),
      email: (json['email'] ?? json['user']?['email'] ?? '').toString(),
      mobileNo: json['mobile_no']?.toString(),
      isActive: json['is_active'] == true || json['is_active'] == 1,
      isDisabled: json['is_disabled'] == true || json['is_disabled'] == 1,
      avatar: json['avatar']?.toString(),
      branch: json['branch'] is Map ? BranchOption.fromJson(Map<String, dynamic>.from(json['branch'])) : null,
      department: json['department'] is Map ? DepartmentOption.fromJson(Map<String, dynamic>.from(json['department'])) : null,
      designation: json['designation'] is Map ? DesignationOption.fromJson(Map<String, dynamic>.from(json['designation'])) : null,
      shift: json['shift'] is Map ? ShiftOption.fromJson(Map<String, dynamic>.from(json['shift'])) : null,
      employmentType: json['employment_type']?.toString(),
      dateOfJoining: json['date_of_joining']?.toString(),
      dateOfBirth: json['date_of_birth']?.toString(),
      gender: json['gender']?.toString(),
      basicSalary: double.tryParse(json['basic_salary']?.toString() ?? '0') ?? 0.0,
      hoursPerDay: int.tryParse(json['hours_per_day']?.toString() ?? '8') ?? 8,
      daysPerWeek: int.tryParse(json['days_per_week']?.toString() ?? '6') ?? 6,
      addressLine1: json['address_line_1']?.toString(),
      city: json['city']?.toString(),
      emergencyContactName: json['emergency_contact_name']?.toString(),
      emergencyContactNumber: json['emergency_contact_number']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'employee_id': employeeId,
        'name': name,
        'email': email,
        'mobile_no': mobileNo,
        'is_active': isActive,
        'is_disabled': isDisabled,
        'avatar': avatar,
        'branch': branch?.toJson(),
        'department': department?.toJson(),
        'designation': designation?.toJson(),
        'shift': shift?.toJson(),
        'employment_type': employmentType,
        'date_of_joining': dateOfJoining,
        'basic_salary': basicSalary,
      };
}

class ManagerPaginationModel {
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;

  ManagerPaginationModel({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
  });

  factory ManagerPaginationModel.fromJson(Map<String, dynamic> json) {
    return ManagerPaginationModel(
      total: int.tryParse(json['total']?.toString() ?? '0') ?? 0,
      perPage: int.tryParse(json['per_page']?.toString() ?? '25') ?? 25,
      currentPage: int.tryParse(json['current_page']?.toString() ?? '1') ?? 1,
      lastPage: int.tryParse(json['last_page']?.toString() ?? '1') ?? 1,
    );
  }
}

class ManagerEmployeesResponse {
  final List<ManagerEmployeeModel> employees;
  final ManagerPaginationModel? pagination;

  ManagerEmployeesResponse({required this.employees, this.pagination});

  factory ManagerEmployeesResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic> ? json['data'] : json;
    final list = data['employees'] is List ? data['employees'] as List : (json['employees'] is List ? json['employees'] as List : []);

    return ManagerEmployeesResponse(
      employees: list.map((item) => ManagerEmployeeModel.fromJson(Map<String, dynamic>.from(item as Map))).toList(),
      pagination: data['pagination'] is Map ? ManagerPaginationModel.fromJson(Map<String, dynamic>.from(data['pagination'])) : null,
    );
  }
}

class ManagerAttendanceModel {
  final int id;
  final int? employeeId;
  final String? employeeName;
  final String? employeeCode;
  final String? branchName;
  final String date;
  final String? clockIn;
  final String? clockOut;
  final String status;
  final String? lateReason;
  final String? notes;
  final String? workHours;
  final bool isLate;

  ManagerAttendanceModel({
    required this.id,
    this.employeeId,
    this.employeeName,
    this.employeeCode,
    this.branchName,
    required this.date,
    this.clockIn,
    this.clockOut,
    required this.status,
    this.lateReason,
    this.notes,
    this.workHours,
    this.isLate = false,
  });

  factory ManagerAttendanceModel.fromJson(Map<String, dynamic> json) {
    return ManagerAttendanceModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      employeeId: json['employee_id'] != null ? int.tryParse(json['employee_id'].toString()) : null,
      employeeName: (json['employee_name'] ?? json['employee']?['name'] ?? json['user']?['name'] ?? 'Staff').toString(),
      employeeCode: (json['employee_code'] ?? json['employee']?['employee_id'] ?? '').toString(),
      branchName: (json['branch_name'] ?? json['branch']?['name'] ?? '').toString(),
      date: (json['date'] ?? '').toString(),
      clockIn: json['clock_in']?.toString(),
      clockOut: json['clock_out']?.toString(),
      status: (json['status'] ?? 'present').toString(),
      lateReason: json['late_reason']?.toString(),
      notes: json['notes']?.toString(),
      workHours: json['work_hours']?.toString(),
      isLate: json['is_late'] == true || json['is_late'] == 1 || (json['late_reason'] != null && json['late_reason'].toString().isNotEmpty),
    );
  }
}

class ManagerLeaveModel {
  final int id;
  final int? employeeId;
  final String? employeeName;
  final String? employeeCode;
  final int? leaveTypeId;
  final String? leaveTypeName;
  final String startDate;
  final String endDate;
  final double daysCount;
  final String? reason;
  final String status; // 'pending', 'approved', 'rejected'
  final String? approverComment;
  final String? createdAt;

  ManagerLeaveModel({
    required this.id,
    this.employeeId,
    this.employeeName,
    this.employeeCode,
    this.leaveTypeId,
    this.leaveTypeName,
    required this.startDate,
    required this.endDate,
    this.daysCount = 1.0,
    this.reason,
    required this.status,
    this.approverComment,
    this.createdAt,
  });

  factory ManagerLeaveModel.fromJson(Map<String, dynamic> json) {
    return ManagerLeaveModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      employeeId: json['employee_id'] != null ? int.tryParse(json['employee_id'].toString()) : null,
      employeeName: (json['employee_name'] ?? json['employee']?['name'] ?? json['user']?['name'] ?? 'Staff').toString(),
      employeeCode: (json['employee_code'] ?? json['employee']?['employee_id'] ?? '').toString(),
      leaveTypeId: json['leave_type_id'] != null ? int.tryParse(json['leave_type_id'].toString()) : null,
      leaveTypeName: (json['leave_type_name'] ?? json['leave_type']?['name'] ?? 'Leave').toString(),
      startDate: (json['start_date'] ?? '').toString(),
      endDate: (json['end_date'] ?? '').toString(),
      daysCount: double.tryParse(json['days_count']?.toString() ?? json['days']?.toString() ?? '1.0') ?? 1.0,
      reason: json['reason']?.toString(),
      status: (json['status'] ?? 'pending').toString().toLowerCase(),
      approverComment: (json['approver_comment'] ?? json['manager_comment'] ?? '').toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}

class ManagerBranchTaskCrudModel {
  final int id;
  final String taskName;
  final String? description;
  final int? branchId;
  final String? branchName;
  final bool isActive;

  ManagerBranchTaskCrudModel({
    required this.id,
    required this.taskName,
    this.description,
    this.branchId,
    this.branchName,
    this.isActive = true,
  });

  factory ManagerBranchTaskCrudModel.fromJson(Map<String, dynamic> json) {
    return ManagerBranchTaskCrudModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      taskName: (json['task_name'] ?? json['title'] ?? '').toString(),
      description: json['description']?.toString(),
      branchId: json['branch_id'] != null ? int.tryParse(json['branch_id'].toString()) : null,
      branchName: json['branch']?['name']?.toString(),
      isActive: json['is_active'] == true || json['is_active'] == 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'task_name': taskName,
        'description': description,
        if (branchId != null) 'branch_id': branchId,
        'is_active': isActive ? 1 : 0,
      };
}

class ManagerSalesTargetModel {
  final int id;
  final int? userId;
  final String? userName;
  final String title;
  final String targetType; // 'item_wise' or 'overall'
  final String periodType; // 'monthly', 'weekly', 'quarterly', 'yearly'
  final String startDate;
  final String endDate;
  final double targetAmount;
  final double achievedAmount;
  final String status; // 'active', 'completed', 'cancelled'

  ManagerSalesTargetModel({
    required this.id,
    this.userId,
    this.userName,
    required this.title,
    required this.targetType,
    required this.periodType,
    required this.startDate,
    required this.endDate,
    this.targetAmount = 0.0,
    this.achievedAmount = 0.0,
    this.status = 'active',
  });

  factory ManagerSalesTargetModel.fromJson(Map<String, dynamic> json) {
    return ManagerSalesTargetModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userId: json['user_id'] != null ? int.tryParse(json['user_id'].toString()) : null,
      userName: (json['user_name'] ?? json['user']?['name'] ?? 'Staff').toString(),
      title: (json['title'] ?? '').toString(),
      targetType: (json['target_type'] ?? 'overall').toString(),
      periodType: (json['period_type'] ?? 'monthly').toString(),
      startDate: (json['start_date'] ?? '').toString(),
      endDate: (json['end_date'] ?? '').toString(),
      targetAmount: double.tryParse(json['target_amount']?.toString() ?? '0') ?? 0.0,
      achievedAmount: double.tryParse(json['achieved_amount']?.toString() ?? '0') ?? 0.0,
      status: (json['status'] ?? 'active').toString(),
    );
  }
}
