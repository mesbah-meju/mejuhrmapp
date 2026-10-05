import 'dart:convert';
import 'package:auth_ui_app/features/hrm/models/attendance_model.dart';

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

class DocumentTypeOption {
  final int id;
  final String name;
  final String description;
  final bool isRequired;

  DocumentTypeOption({
    required this.id,
    required this.name,
    this.description = '',
    this.isRequired = false,
  });

  factory DocumentTypeOption.fromJson(Map<String, dynamic> json) {
    return DocumentTypeOption(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      isRequired: json['is_required'] == true || json['is_required'] == 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'is_required': isRequired,
      };
}

class AvailableUserOption {
  final int id;
  final String name;
  final String email;

  AvailableUserOption({
    required this.id,
    required this.name,
    required this.email,
  });

  factory AvailableUserOption.fromJson(Map<String, dynamic> json) {
    return AvailableUserOption(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};
}

class EmployeeOptionsModel {
  final String generatedEmployeeId;
  final List<BranchOption> branches;
  final List<DepartmentOption> departments;
  final List<DesignationOption> designations;
  final List<ShiftOption> shifts;
  final List<DocumentTypeOption> documentTypes;
  final List<AvailableUserOption> availableUsers;
  final List<GenericOption> employmentTypes;
  final List<GenericOption> genders;

  EmployeeOptionsModel({
    required this.generatedEmployeeId,
    required this.branches,
    required this.departments,
    required this.designations,
    required this.shifts,
    this.documentTypes = const [],
    this.availableUsers = const [],
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
      documentTypes: (data['document_types'] as List? ?? [])
          .map((item) => DocumentTypeOption.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
      availableUsers: (data['available_users'] as List? ?? [])
          .map((item) => AvailableUserOption.fromJson(Map<String, dynamic>.from(item as Map)))
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

class AddressModel {
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;

  AddressModel({
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.country,
    this.postalCode,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      addressLine1: (json['address_line_1'] ??
              json['address_line1'] ??
              json['address_1'] ??
              json['address'] ??
              json['street'] ??
              json['present_address'] ??
              json['line1'])
          ?.toString(),
      addressLine2: (json['address_line_2'] ??
              json['address_line2'] ??
              json['address_2'] ??
              json['permanent_address'] ??
              json['line2'])
          ?.toString(),
      city: (json['city'] ?? json['district'] ?? json['town'] ?? json['city_name'])?.toString(),
      state: (json['state'] ?? json['division'] ?? json['province'] ?? json['state_name'])?.toString(),
      country: (json['country'] ?? json['country_name'])?.toString(),
      postalCode: (json['postal_code'] ??
              json['postalCode'] ??
              json['zip_code'] ??
              json['zip'] ??
              json['post_code'] ??
              json['pincode'])
          ?.toString(),
    );
  }

  /// Formatted single-line address representation
  String get displayAddress {
    final parts = [
      addressLine1,
      addressLine2,
      city,
      state,
      postalCode,
      country,
    ].where((s) => s != null && s.trim().isNotEmpty).toList();
    return parts.isNotEmpty ? parts.join(', ') : '';
  }

  Map<String, dynamic> toJson() => {
        if (addressLine1 != null) 'address_line_1': addressLine1,
        if (addressLine2 != null) 'address_line_2': addressLine2,
        if (city != null) 'city': city,
        if (state != null) 'state': state,
        if (country != null) 'country': country,
        if (postalCode != null) 'postal_code': postalCode,
      };
}

class EmergencyContactModel {
  final String? name;
  final String? relationship;
  final String? number;

  EmergencyContactModel({
    this.name,
    this.relationship,
    this.number,
  });

  factory EmergencyContactModel.fromJson(Map<String, dynamic> json) {
    return EmergencyContactModel(
      name: (json['name'] ??
              json['emergency_contact_name'] ??
              json['emergency_name'] ??
              json['contact_name'] ??
              json['emergency_person'])
          ?.toString(),
      relationship: (json['relationship'] ??
              json['emergency_contact_relationship'] ??
              json['emergency_relationship'] ??
              json['relation'])
          ?.toString(),
      number: (json['number'] ??
              json['emergency_contact_number'] ??
              json['emergency_contact_phone'] ??
              json['emergency_phone'] ??
              json['phone'] ??
              json['mobile'])
          ?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (relationship != null) 'relationship': relationship,
        if (number != null) 'number': number,
      };
}

class BankDetailsModel {
  final String? bankName;
  final String? accountHolderName;
  final String? accountNumber;
  final String? maskedAccountNumber;
  final String? bankIdentifierCode;
  final String? bankBranch;
  final String? taxPayerId;

  BankDetailsModel({
    this.bankName,
    this.accountHolderName,
    this.accountNumber,
    this.maskedAccountNumber,
    this.bankIdentifierCode,
    this.bankBranch,
    this.taxPayerId,
  });

  factory BankDetailsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return BankDetailsModel();
    return BankDetailsModel(
      bankName: (json['bank_name'] ?? json['bank'] ?? json['bank_title'])?.toString(),
      accountHolderName: (json['account_holder_name'] ??
              json['account_holder'] ??
              json['holder_name'] ??
              json['account_name'])
          ?.toString(),
      accountNumber: (json['account_number'] ??
              json['account_no'] ??
              json['account'] ??
              json['acc_no'])
          ?.toString(),
      maskedAccountNumber: (json['masked_account_number'] ?? json['masked_account'])?.toString(),
      bankIdentifierCode: (json['bank_identifier_code'] ??
              json['swift_code'] ??
              json['swift'] ??
              json['bic'] ??
              json['ifsc_code'] ??
              json['ifsc'])
          ?.toString(),
      bankBranch: (json['bank_branch'] ??
              json['branch'] ??
              json['branch_name'])
          ?.toString(),
      taxPayerId: (json['tax_payer_id'] ??
              json['tax_id'] ??
              json['taxpayer_id'] ??
              json['ssn'] ??
              json['tin'] ??
              json['pan'])
          ?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        if (bankName != null) 'bank_name': bankName,
        if (accountHolderName != null) 'account_holder_name': accountHolderName,
        if (accountNumber != null) 'account_number': accountNumber,
        if (maskedAccountNumber != null) 'masked_account_number': maskedAccountNumber,
        if (bankIdentifierCode != null) 'bank_identifier_code': bankIdentifierCode,
        if (bankBranch != null) 'bank_branch': bankBranch,
        if (taxPayerId != null) 'tax_payer_id': taxPayerId,
      };
}

typedef BankDetails = BankDetailsModel;

class EmployeeDocumentModel {
  final int id;
  final int documentTypeId;
  final String documentName;
  final bool isRequired;
  final String filePath;
  final String? fileUrl;
  final String? createdAt;

  EmployeeDocumentModel({
    required this.id,
    required this.documentTypeId,
    required this.documentName,
    this.isRequired = false,
    required this.filePath,
    this.fileUrl,
    this.createdAt,
  });

  factory EmployeeDocumentModel.fromJson(Map<String, dynamic> json) {
    return EmployeeDocumentModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      documentTypeId: int.tryParse(json['document_type_id']?.toString() ?? '0') ?? 0,
      documentName: (json['document_name'] ?? json['name'] ?? '').toString(),
      isRequired: json['is_required'] == true || json['is_required'] == 1,
      filePath: (json['file_path'] ?? json['path'] ?? '').toString(),
      fileUrl: (json['file_url'] ?? json['url'])?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'document_type_id': documentTypeId,
        'document_name': documentName,
        'is_required': isRequired,
        'file_path': filePath,
        if (fileUrl != null) 'file_url': fileUrl,
        if (createdAt != null) 'created_at': createdAt,
      };
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
  final double hoursPerDay;
  final int daysPerWeek;
  final double ratePerHour;
  final String? biometricEmpId;
  final AddressModel? address;
  final EmergencyContactModel? emergencyContact;
  final BankDetailsModel? bankDetails;
  final List<EmployeeDocumentModel> documents;

  // Flattened convenience getters
  String? get addressLine1 => address?.addressLine1;
  String? get city => address?.city;
  String? get emergencyContactName => emergencyContact?.name;
  String? get emergencyContactNumber => emergencyContact?.number;
  String? get biometricId => biometricEmpId;

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
    this.hoursPerDay = 8.0,
    this.daysPerWeek = 6,
    this.ratePerHour = 0.0,
    this.biometricEmpId,
    this.address,
    this.emergencyContact,
    this.bankDetails,
    this.documents = const [],
  });

  factory ManagerEmployeeModel.fromJson(Map<String, dynamic> rawJson) {
    final json = (rawJson['employee'] is Map)
        ? Map<String, dynamic>.from(rawJson['employee'])
        : ((rawJson['data'] is Map && rawJson['data']['id'] != null)
            ? Map<String, dynamic>.from(rawJson['data'])
            : rawJson);

    AddressModel? addr;
    if (json['address'] is Map) {
      addr = AddressModel.fromJson(Map<String, dynamic>.from(json['address']));
    } else if (json['address'] is String && (json['address'] as String).trim().isNotEmpty) {
      final raw = (json['address'] as String).trim();
      if (raw.startsWith('{') && raw.endsWith('}')) {
        try {
          final decoded = jsonDecode(raw);
          if (decoded is Map) {
            addr = AddressModel.fromJson(Map<String, dynamic>.from(decoded));
          }
        } catch (_) {}
      }
      addr ??= AddressModel(
        addressLine1: raw,
        city: (json['city'] ?? json['district'])?.toString(),
        state: (json['state'] ?? json['division'])?.toString(),
        country: json['country']?.toString(),
        postalCode: (json['postal_code'] ?? json['zip_code'] ?? json['zip'])?.toString(),
      );
    } else if (json['user'] is Map && json['user']['address'] != null) {
      if (json['user']['address'] is Map) {
        addr = AddressModel.fromJson(Map<String, dynamic>.from(json['user']['address']));
      } else if (json['user']['address'] is String && (json['user']['address'] as String).trim().isNotEmpty) {
        addr = AddressModel(addressLine1: (json['user']['address'] as String).trim());
      }
    } else if (json['profile'] is Map && json['profile']['address'] != null) {
      if (json['profile']['address'] is Map) {
        addr = AddressModel.fromJson(Map<String, dynamic>.from(json['profile']['address']));
      } else if (json['profile']['address'] is String && (json['profile']['address'] as String).trim().isNotEmpty) {
        addr = AddressModel(addressLine1: (json['profile']['address'] as String).trim());
      }
    } else if (json['address_line_1'] != null ||
        json['address_line1'] != null ||
        json['address_1'] != null ||
        json['present_address'] != null ||
        json['city'] != null ||
        json['state'] != null ||
        json['country'] != null ||
        json['postal_code'] != null ||
        json['zip_code'] != null) {
      addr = AddressModel.fromJson(json);
    }

    EmergencyContactModel? emg;
    if (json['emergency_contact'] is Map) {
      emg = EmergencyContactModel.fromJson(Map<String, dynamic>.from(json['emergency_contact']));
    } else if (json['emergency_contact'] is String && (json['emergency_contact'] as String).trim().isNotEmpty) {
      final raw = (json['emergency_contact'] as String).trim();
      if (raw.startsWith('{') && raw.endsWith('}')) {
        try {
          final decoded = jsonDecode(raw);
          if (decoded is Map) {
            emg = EmergencyContactModel.fromJson(Map<String, dynamic>.from(decoded));
          }
        } catch (_) {}
      }
      emg ??= EmergencyContactModel(name: raw);
    } else if (json['emergency_contact_name'] != null ||
        json['emergency_name'] != null ||
        json['emergency_contact_number'] != null ||
        json['emergency_phone'] != null ||
        json['emergency_contact_phone'] != null ||
        json['emergency_relationship'] != null ||
        json['emergency_contact_relationship'] != null) {
      emg = EmergencyContactModel.fromJson(json);
    }

    BankDetailsModel? bank;
    if (json['bank_details'] is Map) {
      bank = BankDetailsModel.fromJson(Map<String, dynamic>.from(json['bank_details']));
    } else if (rawJson['bank_details'] is Map) {
      bank = BankDetailsModel.fromJson(Map<String, dynamic>.from(rawJson['bank_details']));
    } else if (rawJson['data'] is Map && rawJson['data']['bank_details'] is Map) {
      bank = BankDetailsModel.fromJson(Map<String, dynamic>.from(rawJson['data']['bank_details']));
    } else if (json['bank_details'] is String && (json['bank_details'] as String).trim().isNotEmpty) {
      final raw = (json['bank_details'] as String).trim();
      if (raw.startsWith('{') && raw.endsWith('}')) {
        try {
          final decoded = jsonDecode(raw);
          if (decoded is Map) {
            bank = BankDetailsModel.fromJson(Map<String, dynamic>.from(decoded));
          }
        } catch (_) {}
      }
      bank ??= BankDetailsModel(bankName: raw);
    } else if (json['bank_name'] != null ||
        json['account_number'] != null ||
        json['account_no'] != null ||
        json['account_holder_name'] != null ||
        json['account_holder'] != null ||
        json['bank_branch'] != null ||
        json['bank_identifier_code'] != null ||
        json['swift_code'] != null ||
        json['tax_payer_id'] != null ||
        json['tax_id'] != null) {
      bank = BankDetailsModel.fromJson(json);
    }

    final docsList = (json['documents'] as List? ??
        rawJson['documents'] as List? ??
        (rawJson['data'] is Map ? rawJson['data']['documents'] as List? : null) ??
        (rawJson['data'] is Map && rawJson['data']['employee'] is Map ? rawJson['data']['employee']['documents'] as List? : null) ??
        (json['employee'] is Map ? json['employee']['documents'] as List? : null) ??
        []);

    final docs = docsList
        .whereType<Map>()
        .map((d) => EmployeeDocumentModel.fromJson(Map<String, dynamic>.from(d)))
        .toList();

    return ManagerEmployeeModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userId: json['user_id'] != null ? int.tryParse(json['user_id'].toString()) : null,
      employeeId: (json['employee_id'] ?? '').toString(),
      name: (json['name'] ?? json['user']?['name'] ?? '').toString(),
      email: (json['email'] ?? json['user']?['email'] ?? '').toString(),
      mobileNo: (json['mobile_no'] ?? json['phone'] ?? json['user']?['mobile_no'] ?? json['user']?['phone'])?.toString(),
      isActive: json['is_active'] == true || json['is_active'] == 1,
      isDisabled: json['is_disabled'] == true || json['is_disabled'] == 1,
      avatar: (json['avatar'] ?? json['user']?['avatar'])?.toString(),
      branch: json['branch'] is Map ? BranchOption.fromJson(Map<String, dynamic>.from(json['branch'])) : null,
      department: json['department'] is Map ? DepartmentOption.fromJson(Map<String, dynamic>.from(json['department'])) : null,
      designation: json['designation'] is Map ? DesignationOption.fromJson(Map<String, dynamic>.from(json['designation'])) : null,
      shift: json['shift'] is Map ? ShiftOption.fromJson(Map<String, dynamic>.from(json['shift'])) : null,
      employmentType: json['employment_type']?.toString(),
      dateOfJoining: json['date_of_joining']?.toString(),
      dateOfBirth: json['date_of_birth']?.toString(),
      gender: json['gender']?.toString(),
      basicSalary: double.tryParse(json['basic_salary']?.toString() ?? '0') ?? 0.0,
      hoursPerDay: double.tryParse(json['hours_per_day']?.toString() ?? '8') ?? 8.0,
      daysPerWeek: int.tryParse(json['days_per_week']?.toString() ?? '6') ?? 6,
      ratePerHour: double.tryParse(json['rate_per_hour']?.toString() ?? '0') ?? 0.0,
      biometricEmpId: (json['biometric_emp_id'] ?? json['biometric_id'] ?? json['biometric_user_id'])?.toString(),
      address: addr,
      emergencyContact: emg,
      bankDetails: bank,
      documents: docs,
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
        'date_of_birth': dateOfBirth,
        'gender': gender,
        'basic_salary': basicSalary,
        'hours_per_day': hoursPerDay,
        'days_per_week': daysPerWeek,
        'rate_per_hour': ratePerHour,
        if (biometricEmpId != null) 'biometric_emp_id': biometricEmpId,
        'address': address?.toJson(),
        'emergency_contact': emergencyContact?.toJson(),
        'bank_details': bankDetails?.toJson(),
        'documents': documents.map((d) => d.toJson()).toList(),
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
  final String? employeeEmail;
  final String? employeeAvatar;
  final String? department;
  final String? designation;
  final String? branchName;
  final String date;
  final String? clockIn;
  final String? clockOut;
  final String status;
  final String? lateReason;
  final String? notes;
  final String? workHours;
  final double totalHours;
  final double breakHours;
  final double overtimeHours;
  final double overtimeAmount;
  final bool isLate;
  final bool isEarly;
  final String? checkInBranch;
  final String? checkInLocation;
  final String? checkOutBranch;
  final String? checkOutLocation;
  final ShiftOption? shift;

  ManagerAttendanceModel({
    required this.id,
    this.employeeId,
    this.employeeName,
    this.employeeCode,
    this.employeeEmail,
    this.employeeAvatar,
    this.department,
    this.designation,
    this.branchName,
    required this.date,
    this.clockIn,
    this.clockOut,
    required this.status,
    this.lateReason,
    this.notes,
    this.workHours,
    this.totalHours = 0.0,
    this.breakHours = 0.0,
    this.overtimeHours = 0.0,
    this.overtimeAmount = 0.0,
    this.isLate = false,
    this.isEarly = false,
    this.checkInBranch,
    this.checkInLocation,
    this.checkOutBranch,
    this.checkOutLocation,
    this.shift,
  });

  factory ManagerAttendanceModel.fromJson(Map<String, dynamic> json) {
    ShiftOption? shiftOpt;
    if (json['shift'] is Map) {
      shiftOpt = ShiftOption.fromJson(Map<String, dynamic>.from(json['shift']));
    }

    final totalH = (json['total_hours'] is num)
        ? (json['total_hours'] as num).toDouble()
        : double.tryParse(json['total_hours']?.toString() ?? '0.0') ??
            double.tryParse(json['work_hours']?.toString() ?? '0.0') ??
            0.0;

    return ManagerAttendanceModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      employeeId: json['employee_id'] != null ? int.tryParse(json['employee_id'].toString()) : null,
      employeeName: (json['employee_name'] ?? json['employee']?['name'] ?? json['user']?['name'] ?? 'Staff').toString(),
      employeeCode: (json['employee_code'] ?? json['employee']?['employee_id'] ?? '').toString(),
      employeeEmail: (json['employee_email'] ?? json['employee']?['email'] ?? json['user']?['email'])?.toString(),
      employeeAvatar: (json['employee_avatar'] ?? json['employee']?['avatar'] ?? json['user']?['avatar'])?.toString(),
      department: (json['department'] is String ? json['department'] : json['department']?['name'])?.toString(),
      designation: (json['designation'] is String ? json['designation'] : json['designation']?['name'])?.toString(),
      branchName: (json['branch_name'] ?? json['branch']?['name'] ?? json['check_in_branch'] ?? '').toString(),
      date: (json['date'] ?? '').toString(),
      clockIn: json['clock_in']?.toString(),
      clockOut: json['clock_out']?.toString(),
      status: (json['status'] ?? 'present').toString(),
      lateReason: json['late_reason']?.toString(),
      notes: json['notes']?.toString(),
      workHours: json['work_hours']?.toString() ?? "${totalH.toStringAsFixed(2)} hrs",
      totalHours: totalH,
      breakHours: (json['break_hours'] is num) ? (json['break_hours'] as num).toDouble() : double.tryParse(json['break_hours']?.toString() ?? '0.0') ?? 0.0,
      overtimeHours: (json['overtime_hours'] is num) ? (json['overtime_hours'] as num).toDouble() : double.tryParse(json['overtime_hours']?.toString() ?? '0.0') ?? 0.0,
      overtimeAmount: (json['overtime_amount'] is num) ? (json['overtime_amount'] as num).toDouble() : double.tryParse(json['overtime_amount']?.toString() ?? '0.0') ?? 0.0,
      isLate: json['is_late'] == true || json['is_late'] == 1 || (json['late_reason'] != null && json['late_reason'].toString().isNotEmpty),
      isEarly: json['is_early'] == true || json['is_early'] == 1,
      checkInBranch: json['check_in_branch']?.toString(),
      checkInLocation: (json['check_in_location'] is Map ? json['check_in_location']['name'] : json['check_in_location'])?.toString(),
      checkOutBranch: json['check_out_branch']?.toString(),
      checkOutLocation: (json['check_out_location'] is Map ? json['check_out_location']['name'] : json['check_out_location'])?.toString(),
      shift: shiftOpt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'employee_id': employeeId,
        'employee_name': employeeName,
        'employee_code': employeeCode,
        'employee_email': employeeEmail,
        'employee_avatar': employeeAvatar,
        'department': department,
        'designation': designation,
        'branch_name': branchName,
        'date': date,
        'clock_in': clockIn,
        'clock_out': clockOut,
        'status': status,
        'late_reason': lateReason,
        'notes': notes,
        'work_hours': workHours,
        'total_hours': totalHours,
        'break_hours': breakHours,
        'overtime_hours': overtimeHours,
        'overtime_amount': overtimeAmount,
        'is_late': isLate,
        'is_early': isEarly,
        'check_in_branch': checkInBranch,
        'check_in_location': checkInLocation,
        'check_out_branch': checkOutBranch,
        'check_out_location': checkOutLocation,
        'shift': shift?.toJson(),
      };
}

/// 2.1 Live Today Team Overview Models
class ManagerAttendanceOverviewSummaryModel {
  final int totalEmployees;
  final int clockedInNow;
  final int presentToday;
  final int absentToday;
  final int onLeaveToday;
  final int lateToday;
  final int earlyCheckoutToday;

  ManagerAttendanceOverviewSummaryModel({
    this.totalEmployees = 0,
    this.clockedInNow = 0,
    this.presentToday = 0,
    this.absentToday = 0,
    this.onLeaveToday = 0,
    this.lateToday = 0,
    this.earlyCheckoutToday = 0,
  });

  factory ManagerAttendanceOverviewSummaryModel.fromJson(Map<String, dynamic> json) {
    return ManagerAttendanceOverviewSummaryModel(
      totalEmployees: json['total_employees'] is int ? json['total_employees'] : int.tryParse(json['total_employees']?.toString() ?? '0') ?? 0,
      clockedInNow: json['clocked_in_now'] is int ? json['clocked_in_now'] : int.tryParse(json['clocked_in_now']?.toString() ?? '0') ?? 0,
      presentToday: json['present_today'] is int ? json['present_today'] : int.tryParse(json['present_today']?.toString() ?? '0') ?? 0,
      absentToday: json['absent_today'] is int ? json['absent_today'] : int.tryParse(json['absent_today']?.toString() ?? '0') ?? 0,
      onLeaveToday: json['on_leave_today'] is int ? json['on_leave_today'] : int.tryParse(json['on_leave_today']?.toString() ?? '0') ?? 0,
      lateToday: json['late_today'] is int ? json['late_today'] : int.tryParse(json['late_today']?.toString() ?? '0') ?? 0,
      earlyCheckoutToday: json['early_checkout_today'] is int ? json['early_checkout_today'] : int.tryParse(json['early_checkout_today']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'total_employees': totalEmployees,
        'clocked_in_now': clockedInNow,
        'present_today': presentToday,
        'absent_today': absentToday,
        'on_leave_today': onLeaveToday,
        'late_today': lateToday,
        'early_checkout_today': earlyCheckoutToday,
      };
}

class ManagerRosterItemModel {
  final String? employeeId;
  final int? userId;
  final String name;
  final String? email;
  final String? avatar;
  final String? department;
  final String? designation;
  final String? branch;
  final String? shift;
  final String status;
  final String? clockIn;
  final String? clockOut;
  final double totalHours;
  final bool isLate;
  final bool isEarly;
  final String? location;
  final String? leaveType;

  ManagerRosterItemModel({
    this.employeeId,
    this.userId,
    required this.name,
    this.email,
    this.avatar,
    this.department,
    this.designation,
    this.branch,
    this.shift,
    this.status = 'absent',
    this.clockIn,
    this.clockOut,
    this.totalHours = 0.0,
    this.isLate = false,
    this.isEarly = false,
    this.location,
    this.leaveType,
  });

  factory ManagerRosterItemModel.fromJson(Map<String, dynamic> json) {
    return ManagerRosterItemModel(
      employeeId: json['employee_id']?.toString(),
      userId: json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id']?.toString() ?? ''),
      name: json['name']?.toString() ?? 'Employee',
      email: json['email']?.toString(),
      avatar: json['avatar']?.toString(),
      department: json['department']?.toString(),
      designation: json['designation']?.toString(),
      branch: json['branch']?.toString(),
      shift: json['shift']?.toString(),
      status: json['status']?.toString() ?? 'absent',
      clockIn: json['clock_in']?.toString(),
      clockOut: json['clock_out']?.toString(),
      totalHours: (json['total_hours'] is num) ? (json['total_hours'] as num).toDouble() : double.tryParse(json['total_hours']?.toString() ?? '0.0') ?? 0.0,
      isLate: json['is_late'] == true || json['is_late'] == 1,
      isEarly: json['is_early'] == true || json['is_early'] == 1,
      location: json['location']?.toString(),
      leaveType: json['leave_type']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'employee_id': employeeId,
        'user_id': userId,
        'name': name,
        'email': email,
        'avatar': avatar,
        'department': department,
        'designation': designation,
        'branch': branch,
        'shift': shift,
        'status': status,
        'clock_in': clockIn,
        'clock_out': clockOut,
        'total_hours': totalHours,
        'is_late': isLate,
        'is_early': isEarly,
        'location': location,
        'leave_type': leaveType,
      };
}

class ManagerAttendanceOverviewResponse {
  final String date;
  final bool isHoliday;
  final String? holidayName;
  final bool isWorkingDay;
  final ManagerAttendanceOverviewSummaryModel summary;
  final List<ManagerRosterItemModel> roster;

  ManagerAttendanceOverviewResponse({
    required this.date,
    this.isHoliday = false,
    this.holidayName,
    this.isWorkingDay = true,
    required this.summary,
    this.roster = const [],
  });

  factory ManagerAttendanceOverviewResponse.fromJson(Map<String, dynamic> json) {
    List<ManagerRosterItemModel> rosterList = [];
    if (json['roster'] is List) {
      rosterList = (json['roster'] as List)
          .map((e) => ManagerRosterItemModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }

    return ManagerAttendanceOverviewResponse(
      date: json['date']?.toString() ?? '',
      isHoliday: json['is_holiday'] == true || json['is_holiday'] == 1,
      holidayName: json['holiday_name']?.toString(),
      isWorkingDay: json['is_working_day'] != false,
      summary: json['summary'] is Map ? ManagerAttendanceOverviewSummaryModel.fromJson(Map<String, dynamic>.from(json['summary'])) : ManagerAttendanceOverviewSummaryModel(),
      roster: rosterList,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'is_holiday': isHoliday,
        'holiday_name': holidayName,
        'is_working_day': isWorkingDay,
        'summary': summary.toJson(),
        'roster': roster.map((e) => e.toJson()).toList(),
      };
}

/// 2.2 Manager Paginated Attendance Response
class ManagerAttendancePaginationModel {
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;

  ManagerAttendancePaginationModel({
    this.total = 0,
    this.perPage = 20,
    this.currentPage = 1,
    this.lastPage = 1,
  });

  factory ManagerAttendancePaginationModel.fromJson(Map<String, dynamic> json) {
    return ManagerAttendancePaginationModel(
      total: json['total'] is int ? json['total'] : int.tryParse(json['total']?.toString() ?? '0') ?? 0,
      perPage: json['per_page'] is int ? json['per_page'] : int.tryParse(json['per_page']?.toString() ?? '20') ?? 20,
      currentPage: json['current_page'] is int ? json['current_page'] : int.tryParse(json['current_page']?.toString() ?? '1') ?? 1,
      lastPage: json['last_page'] is int ? json['last_page'] : int.tryParse(json['last_page']?.toString() ?? '1') ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'total': total,
        'per_page': perPage,
        'current_page': currentPage,
        'last_page': lastPage,
      };
}

class ManagerAttendanceListResponse {
  final List<ManagerAttendanceModel> items;
  final ManagerAttendancePaginationModel pagination;

  ManagerAttendanceListResponse({
    required this.items,
    required this.pagination,
  });

  factory ManagerAttendanceListResponse.fromJson(Map<String, dynamic> json) {
    List<ManagerAttendanceModel> list = [];
    if (json['items'] is List) {
      list = (json['items'] as List)
          .map((e) => ManagerAttendanceModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } else if (json['data'] is List) {
      list = (json['data'] as List)
          .map((e) => ManagerAttendanceModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }

    return ManagerAttendanceListResponse(
      items: list,
      pagination: json['pagination'] is Map
          ? ManagerAttendancePaginationModel.fromJson(Map<String, dynamic>.from(json['pagination']))
          : ManagerAttendancePaginationModel(),
    );
  }

  Map<String, dynamic> toJson() => {
        'items': items.map((e) => e.toJson()).toList(),
        'pagination': pagination.toJson(),
      };
}

/// 2.3 Manager Attendance Analytics Report Models
class ManagerAttendanceReportOverviewModel {
  final int totalEmployees;
  final int totalPresentDays;
  final int totalHalfDays;
  final int totalAbsentDays;
  final int totalLeaveDays;
  final int totalLateIncidents;
  final double totalWorkedHours;
  final double totalOvertimeHours;
  final double totalOvertimePayout;
  final double overallAttendanceRate;

  ManagerAttendanceReportOverviewModel({
    this.totalEmployees = 0,
    this.totalPresentDays = 0,
    this.totalHalfDays = 0,
    this.totalAbsentDays = 0,
    this.totalLeaveDays = 0,
    this.totalLateIncidents = 0,
    this.totalWorkedHours = 0.0,
    this.totalOvertimeHours = 0.0,
    this.totalOvertimePayout = 0.0,
    this.overallAttendanceRate = 0.0,
  });

  factory ManagerAttendanceReportOverviewModel.fromJson(Map<String, dynamic> json) {
    return ManagerAttendanceReportOverviewModel(
      totalEmployees: json['total_employees'] is int ? json['total_employees'] : int.tryParse(json['total_employees']?.toString() ?? '0') ?? 0,
      totalPresentDays: json['total_present_days'] is int ? json['total_present_days'] : int.tryParse(json['total_present_days']?.toString() ?? '0') ?? 0,
      totalHalfDays: json['total_half_days'] is int ? json['total_half_days'] : int.tryParse(json['total_half_days']?.toString() ?? '0') ?? 0,
      totalAbsentDays: json['total_absent_days'] is int ? json['total_absent_days'] : int.tryParse(json['total_absent_days']?.toString() ?? '0') ?? 0,
      totalLeaveDays: json['total_leave_days'] is int ? json['total_leave_days'] : int.tryParse(json['total_leave_days']?.toString() ?? '0') ?? 0,
      totalLateIncidents: json['total_late_incidents'] is int ? json['total_late_incidents'] : int.tryParse(json['total_late_incidents']?.toString() ?? '0') ?? 0,
      totalWorkedHours: (json['total_worked_hours'] is num) ? (json['total_worked_hours'] as num).toDouble() : double.tryParse(json['total_worked_hours']?.toString() ?? '0.0') ?? 0.0,
      totalOvertimeHours: (json['total_overtime_hours'] is num) ? (json['total_overtime_hours'] as num).toDouble() : double.tryParse(json['total_overtime_hours']?.toString() ?? '0.0') ?? 0.0,
      totalOvertimePayout: (json['total_overtime_payout'] is num) ? (json['total_overtime_payout'] as num).toDouble() : double.tryParse(json['total_overtime_payout']?.toString() ?? '0.0') ?? 0.0,
      overallAttendanceRate: (json['overall_attendance_rate'] is num) ? (json['overall_attendance_rate'] as num).toDouble() : double.tryParse(json['overall_attendance_rate']?.toString() ?? '0.0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'total_employees': totalEmployees,
        'total_present_days': totalPresentDays,
        'total_half_days': totalHalfDays,
        'total_absent_days': totalAbsentDays,
        'total_leave_days': totalLeaveDays,
        'total_late_incidents': totalLateIncidents,
        'total_worked_hours': totalWorkedHours,
        'total_overtime_hours': totalOvertimeHours,
        'total_overtime_payout': totalOvertimePayout,
        'overall_attendance_rate': overallAttendanceRate,
      };
}

class ManagerAttendanceReportEmployeeItem {
  final String? employeeId;
  final int? userId;
  final String name;
  final String? email;
  final String? avatar;
  final String? department;
  final String? designation;
  final String? branch;
  final String? shift;
  final int presentDays;
  final int halfDays;
  final int absentDays;
  final int leaveDays;
  final int lateCount;
  final int earlyExitCount;
  final double totalWorkedHours;
  final double totalOvertimeHours;
  final double totalOvertimeAmount;
  final double attendanceRate;

  ManagerAttendanceReportEmployeeItem({
    this.employeeId,
    this.userId,
    required this.name,
    this.email,
    this.avatar,
    this.department,
    this.designation,
    this.branch,
    this.shift,
    this.presentDays = 0,
    this.halfDays = 0,
    this.absentDays = 0,
    this.leaveDays = 0,
    this.lateCount = 0,
    this.earlyExitCount = 0,
    this.totalWorkedHours = 0.0,
    this.totalOvertimeHours = 0.0,
    this.totalOvertimeAmount = 0.0,
    this.attendanceRate = 0.0,
  });

  factory ManagerAttendanceReportEmployeeItem.fromJson(Map<String, dynamic> json) {
    return ManagerAttendanceReportEmployeeItem(
      employeeId: json['employee_id']?.toString(),
      userId: json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id']?.toString() ?? ''),
      name: json['name']?.toString() ?? 'Employee',
      email: json['email']?.toString(),
      avatar: json['avatar']?.toString(),
      department: json['department']?.toString(),
      designation: json['designation']?.toString(),
      branch: json['branch']?.toString(),
      shift: json['shift']?.toString(),
      presentDays: json['present_days'] is int ? json['present_days'] : int.tryParse(json['present_days']?.toString() ?? '0') ?? 0,
      halfDays: json['half_days'] is int ? json['half_days'] : int.tryParse(json['half_days']?.toString() ?? '0') ?? 0,
      absentDays: json['absent_days'] is int ? json['absent_days'] : int.tryParse(json['absent_days']?.toString() ?? '0') ?? 0,
      leaveDays: json['leave_days'] is int ? json['leave_days'] : int.tryParse(json['leave_days']?.toString() ?? '0') ?? 0,
      lateCount: json['late_count'] is int ? json['late_count'] : int.tryParse(json['late_count']?.toString() ?? '0') ?? 0,
      earlyExitCount: json['early_exit_count'] is int ? json['early_exit_count'] : int.tryParse(json['early_exit_count']?.toString() ?? '0') ?? 0,
      totalWorkedHours: (json['total_worked_hours'] is num) ? (json['total_worked_hours'] as num).toDouble() : double.tryParse(json['total_worked_hours']?.toString() ?? '0.0') ?? 0.0,
      totalOvertimeHours: (json['total_overtime_hours'] is num) ? (json['total_overtime_hours'] as num).toDouble() : double.tryParse(json['total_overtime_hours']?.toString() ?? '0.0') ?? 0.0,
      totalOvertimeAmount: (json['total_overtime_amount'] is num) ? (json['total_overtime_amount'] as num).toDouble() : double.tryParse(json['total_overtime_amount']?.toString() ?? '0.0') ?? 0.0,
      attendanceRate: (json['attendance_rate'] is num) ? (json['attendance_rate'] as num).toDouble() : double.tryParse(json['attendance_rate']?.toString() ?? '0.0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'employee_id': employeeId,
        'user_id': userId,
        'name': name,
        'email': email,
        'avatar': avatar,
        'department': department,
        'designation': designation,
        'branch': branch,
        'shift': shift,
        'present_days': presentDays,
        'half_days': halfDays,
        'absent_days': absentDays,
        'leave_days': leaveDays,
        'late_count': lateCount,
        'early_exit_count': earlyExitCount,
        'total_worked_hours': totalWorkedHours,
        'total_overtime_hours': totalOvertimeHours,
        'total_overtime_amount': totalOvertimeAmount,
        'attendance_rate': attendanceRate,
      };
}

class ManagerAttendanceReportResponse {
  final StaffReportPeriodModel? period;
  final ManagerAttendanceReportOverviewModel overview;
  final List<ManagerAttendanceReportEmployeeItem> employees;

  ManagerAttendanceReportResponse({
    this.period,
    required this.overview,
    this.employees = const [],
  });

  factory ManagerAttendanceReportResponse.fromJson(Map<String, dynamic> json) {
    List<ManagerAttendanceReportEmployeeItem> empList = [];
    if (json['employees'] is List) {
      empList = (json['employees'] as List)
          .map((e) => ManagerAttendanceReportEmployeeItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }

    return ManagerAttendanceReportResponse(
      period: json['period'] is Map ? StaffReportPeriodModel.fromJson(Map<String, dynamic>.from(json['period'])) : null,
      overview: json['overview'] is Map ? ManagerAttendanceReportOverviewModel.fromJson(Map<String, dynamic>.from(json['overview'])) : ManagerAttendanceReportOverviewModel(),
      employees: empList,
    );
  }

  Map<String, dynamic> toJson() => {
        'period': period?.toJson(),
        'overview': overview.toJson(),
        'employees': employees.map((e) => e.toJson()).toList(),
      };
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
