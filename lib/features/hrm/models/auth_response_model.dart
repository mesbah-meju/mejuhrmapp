class UserModel {
  final int id;
  final String name;
  final String email;
  final String? mobileNo;
  final String type;
  final List<String> roles;
  final String? avatar;
  final String? lang;
  final int? createdBy;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.mobileNo,
    required this.type,
    this.roles = const [],
    this.avatar,
    this.lang,
    this.createdBy,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedRoles = [];
    if (json['roles'] is List) {
      parsedRoles = (json['roles'] as List).map((e) => e.toString()).toList();
    } else if (json['role'] != null) {
      parsedRoles = [json['role'].toString()];
    }

    return UserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      mobileNo: json['mobile_no']?.toString() ?? json['phone']?.toString(),
      type: json['type']?.toString() ?? (parsedRoles.isNotEmpty ? parsedRoles.first : 'employee'),
      roles: parsedRoles,
      avatar: json['avatar']?.toString(),
      lang: json['lang']?.toString() ?? 'en',
      createdBy: json['created_by'] is int ? json['created_by'] : int.tryParse(json['created_by']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'mobile_no': mobileNo,
        'type': type,
        'roles': roles,
        'avatar': avatar,
        'lang': lang,
        'created_by': createdBy,
      };
}

class BranchModel {
  final int id;
  final String name;

  BranchModel({required this.id, required this.name});

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
        id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        name: json['name']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class DepartmentModel {
  final int id;
  final String name;

  DepartmentModel({required this.id, required this.name});

  factory DepartmentModel.fromJson(Map<String, dynamic> json) => DepartmentModel(
        id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        name: json['name']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class DesignationModel {
  final int id;
  final String name;

  DesignationModel({required this.id, required this.name});

  factory DesignationModel.fromJson(Map<String, dynamic> json) => DesignationModel(
        id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        name: json['name']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class ShiftModel {
  final int id;
  final String name;
  final String startTime;
  final String endTime;

  ShiftModel({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) => ShiftModel(
        id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        name: json['name']?.toString() ?? '',
        startTime: json['start_time']?.toString() ?? '09:00:00',
        endTime: json['end_time']?.toString() ?? '18:00:00',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'start_time': startTime,
        'end_time': endTime,
      };
}

class EmployeeModel {
  final int id;
  final String employeeId;
  final BranchModel? branch;
  final DepartmentModel? department;
  final DesignationModel? designation;
  final ShiftModel? shift;

  EmployeeModel({
    required this.id,
    required this.employeeId,
    this.branch,
    this.department,
    this.designation,
    this.shift,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        employeeId: json['employee_id']?.toString() ?? '',
        branch: json['branch'] is Map<String, dynamic> ? BranchModel.fromJson(json['branch']) : null,
        department: json['department'] is Map<String, dynamic> ? DepartmentModel.fromJson(json['department']) : null,
        designation: json['designation'] is Map<String, dynamic> ? DesignationModel.fromJson(json['designation']) : null,
        shift: json['shift'] is Map<String, dynamic> ? ShiftModel.fromJson(json['shift']) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'employee_id': employeeId,
        'branch': branch?.toJson(),
        'department': department?.toJson(),
        'designation': designation?.toJson(),
        'shift': shift?.toJson(),
      };
}

class TenantLocationModel {
  final int id;
  final String locationName;
  final int branchId;
  final String branchName;
  final String address;
  final double latitude;
  final double longitude;
  final double radius;
  final bool isActive;

  TenantLocationModel({
    required this.id,
    required this.locationName,
    required this.branchId,
    required this.branchName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.radius,
    this.isActive = true,
  });

  factory TenantLocationModel.fromJson(Map<String, dynamic> json) => TenantLocationModel(
        id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        locationName: json['location_name']?.toString() ?? '',
        branchId: json['branch_id'] is int ? json['branch_id'] : int.tryParse(json['branch_id']?.toString() ?? '0') ?? 0,
        branchName: json['branch_name']?.toString() ?? '',
        address: json['address']?.toString() ?? '',
        latitude: (json['latitude'] is num) ? (json['latitude'] as num).toDouble() : double.tryParse(json['latitude']?.toString() ?? '0.0') ?? 0.0,
        longitude: (json['longitude'] is num) ? (json['longitude'] as num).toDouble() : double.tryParse(json['longitude']?.toString() ?? '0.0') ?? 0.0,
        radius: (json['radius'] is num) ? (json['radius'] as num).toDouble() : double.tryParse(json['radius']?.toString() ?? '150.0') ?? 150.0,
        isActive: json['is_active'] == true || json['is_active'] == 1 || json['is_active'] == '1',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'location_name': locationName,
        'branch_id': branchId,
        'branch_name': branchName,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
        'is_active': isActive,
      };
}

class AuthDataModel {
  final UserModel user;
  final EmployeeModel? employee;
  final List<TenantLocationModel> tenantLocations;
  final String token;
  final String type;
  final String loginType;

  AuthDataModel({
    required this.user,
    this.employee,
    this.tenantLocations = const [],
    required this.token,
    required this.type,
    required this.loginType,
  });

  factory AuthDataModel.fromJson(Map<String, dynamic> json) {
    List<TenantLocationModel> locations = [];
    if (json['tenant_locations'] is List) {
      locations = (json['tenant_locations'] as List)
          .map((e) => TenantLocationModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }

    return AuthDataModel(
      user: UserModel.fromJson(Map<String, dynamic>.from(json['user'] ?? {})),
      employee: json['employee'] != null ? EmployeeModel.fromJson(Map<String, dynamic>.from(json['employee'])) : null,
      tenantLocations: locations,
      token: json['token']?.toString() ?? '',
      type: json['type']?.toString() ?? 'bearer',
      loginType: json['login_type']?.toString() ?? 'staff',
    );
  }

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'employee': employee?.toJson(),
        'tenant_locations': tenantLocations.map((e) => e.toJson()).toList(),
        'token': token,
        'type': type,
        'login_type': loginType,
      };
}
