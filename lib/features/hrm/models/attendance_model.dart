class AttendanceLocationDetail {
  final int id;
  final String name;
  final String? address;
  final double? latitude;
  final double? longitude;
  final double? radius;

  AttendanceLocationDetail({
    required this.id,
    required this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.radius,
  });

  factory AttendanceLocationDetail.fromJson(Map<String, dynamic> json) {
    return AttendanceLocationDetail(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? json['location_name']?.toString() ?? '',
      address: json['address']?.toString(),
      latitude: (json['latitude'] is num)
          ? (json['latitude'] as num).toDouble()
          : double.tryParse(json['latitude']?.toString() ?? ''),
      longitude: (json['longitude'] is num)
          ? (json['longitude'] as num).toDouble()
          : double.tryParse(json['longitude']?.toString() ?? ''),
      radius: (json['radius'] is num)
          ? (json['radius'] as num).toDouble()
          : double.tryParse(json['radius']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
      };
}

class AttendanceBranchDetail {
  final int id;
  final String name;

  AttendanceBranchDetail({required this.id, required this.name});

  factory AttendanceBranchDetail.fromJson(Map<String, dynamic> json) {
    return AttendanceBranchDetail(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? json['branch_name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class AttendanceShiftDetail {
  final int id;
  final String name;
  final String startTime;
  final String endTime;
  final String? breakStartTime;
  final String? breakEndTime;

  AttendanceShiftDetail({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    this.breakStartTime,
    this.breakEndTime,
  });

  factory AttendanceShiftDetail.fromJson(Map<String, dynamic> json) {
    return AttendanceShiftDetail(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      startTime: json['start_time']?.toString() ?? '09:00:00',
      endTime: json['end_time']?.toString() ?? '18:00:00',
      breakStartTime: json['break_start_time']?.toString(),
      breakEndTime: json['break_end_time']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'start_time': startTime,
        'end_time': endTime,
        'break_start_time': breakStartTime,
        'break_end_time': breakEndTime,
      };
}

class TodayAttendanceStatus {
  final bool isClockedIn;
  final bool canClockIn;
  final bool canClockOut;
  final int? attendanceId;
  final String date;
  final String? clockIn;
  final String? clockOut;
  final String totalHours;
  final double totalHoursNumeric;
  final String? breakHours;
  final double breakHoursNumeric;
  final String? overtimeHours;
  final double overtimeHoursNumeric;
  final String status;
  final bool isWorkingDay;
  final bool isHoliday;
  final String? holidayName;
  final bool isOnLeave;
  final bool isHalfDayLeave;
  final String? leaveTitle;
  final AttendanceLocationDetail? checkInLocation;
  final AttendanceBranchDetail? checkInBranch;
  final AttendanceShiftDetail? shift;
  final Map<String, String> workingDaysMap;

  TodayAttendanceStatus({
    required this.isClockedIn,
    this.canClockIn = true,
    this.canClockOut = false,
    this.attendanceId,
    required this.date,
    this.clockIn,
    this.clockOut,
    this.totalHours = "0.00 hours",
    this.totalHoursNumeric = 0.0,
    this.breakHours,
    this.breakHoursNumeric = 0.0,
    this.overtimeHours,
    this.overtimeHoursNumeric = 0.0,
    this.status = "absent",
    this.isWorkingDay = true,
    this.isHoliday = false,
    this.holidayName,
    this.isOnLeave = false,
    this.isHalfDayLeave = false,
    this.leaveTitle,
    this.checkInLocation,
    this.checkInBranch,
    this.shift,
    this.workingDaysMap = const {},
  });

  factory TodayAttendanceStatus.fromJson(Map<String, dynamic> json) {
    AttendanceLocationDetail? loc;
    if (json['check_in_location'] is Map<String, dynamic>) {
      loc = AttendanceLocationDetail.fromJson(json['check_in_location']);
    } else if (json['check_in_location'] is String) {
      loc = AttendanceLocationDetail(id: 0, name: json['check_in_location']);
    }

    AttendanceBranchDetail? br;
    if (json['check_in_branch'] is Map<String, dynamic>) {
      br = AttendanceBranchDetail.fromJson(json['check_in_branch']);
    } else if (json['check_in_branch'] is String) {
      br = AttendanceBranchDetail(id: 0, name: json['check_in_branch']);
    }

    AttendanceShiftDetail? sh;
    if (json['shift'] is Map<String, dynamic>) {
      sh = AttendanceShiftDetail.fromJson(json['shift']);
    }

    Map<String, String> daysMap = {};
    if (json['working_days_map'] is Map) {
      json['working_days_map'].forEach((k, v) {
        daysMap[k.toString()] = v.toString();
      });
    }

    final isClocked = json['is_clocked_in'] == true || json['is_clockin'] == 1 || json['is_clockin'] == true;

    return TodayAttendanceStatus(
      isClockedIn: isClocked,
      canClockIn: json['can_clock_in'] == true || (!isClocked && json['can_clock_in'] != false),
      canClockOut: json['can_clock_out'] == true || isClocked,
      attendanceId: json['attendance_id'] is int ? json['attendance_id'] : int.tryParse(json['attendance_id']?.toString() ?? ''),
      date: json['date']?.toString() ?? '',
      clockIn: json['clock_in']?.toString(),
      clockOut: json['clock_out']?.toString(),
      totalHours: json['total_hours']?.toString() ?? '0.00 hours',
      totalHoursNumeric: (json['total_hours_numeric'] is num)
          ? (json['total_hours_numeric'] as num).toDouble()
          : double.tryParse(json['total_hours_numeric']?.toString() ?? '0.0') ?? 0.0,
      breakHours: json['break_hours']?.toString(),
      breakHoursNumeric: (json['break_hours_numeric'] is num)
          ? (json['break_hours_numeric'] as num).toDouble()
          : double.tryParse(json['break_hours_numeric']?.toString() ?? '0.0') ?? 0.0,
      overtimeHours: json['overtime_hours']?.toString(),
      overtimeHoursNumeric: (json['overtime_hours_numeric'] is num)
          ? (json['overtime_hours_numeric'] as num).toDouble()
          : double.tryParse(json['overtime_hours_numeric']?.toString() ?? '0.0') ?? 0.0,
      status: json['status']?.toString() ?? (isClocked ? 'present' : 'absent'),
      isWorkingDay: json['is_working_day'] != false,
      isHoliday: json['is_holiday'] == true || json['is_holiday'] == 1,
      holidayName: json['holiday_name']?.toString(),
      isOnLeave: json['is_on_leave'] == true || json['is_on_leave'] == 1,
      isHalfDayLeave: json['is_half_day_leave'] == true || json['is_half_day_leave'] == 1,
      leaveTitle: json['leave_title']?.toString(),
      checkInLocation: loc,
      checkInBranch: br,
      shift: sh,
      workingDaysMap: daysMap,
    );
  }

  Map<String, dynamic> toJson() => {
        'is_clocked_in': isClockedIn,
        'can_clock_in': canClockIn,
        'can_clock_out': canClockOut,
        'attendance_id': attendanceId,
        'date': date,
        'clock_in': clockIn,
        'clock_out': clockOut,
        'total_hours': totalHours,
        'total_hours_numeric': totalHoursNumeric,
        'break_hours': breakHours,
        'break_hours_numeric': breakHoursNumeric,
        'overtime_hours': overtimeHours,
        'overtime_hours_numeric': overtimeHoursNumeric,
        'status': status,
        'is_working_day': isWorkingDay,
        'is_holiday': isHoliday,
        'holiday_name': holidayName,
        'is_on_leave': isOnLeave,
        'is_half_day_leave': isHalfDayLeave,
        'leave_title': leaveTitle,
        'check_in_location': checkInLocation?.toJson(),
        'check_in_branch': checkInBranch?.toJson(),
        'shift': shift?.toJson(),
        'working_days_map': workingDaysMap,
      };
}

class AttendanceSummaryModel {
  final int totalRecords;
  final int presentDays;
  final int halfDays;
  final int absentDays;
  final double totalWorkedHours;
  final double totalOvertimeHours;

  AttendanceSummaryModel({
    this.totalRecords = 0,
    this.presentDays = 0,
    this.halfDays = 0,
    this.absentDays = 0,
    this.totalWorkedHours = 0.0,
    this.totalOvertimeHours = 0.0,
  });

  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryModel(
      totalRecords: json['total_records'] is int ? json['total_records'] : int.tryParse(json['total_records']?.toString() ?? '0') ?? 0,
      presentDays: json['present_days'] is int ? json['present_days'] : int.tryParse(json['present_days']?.toString() ?? '0') ?? 0,
      halfDays: json['half_days'] is int ? json['half_days'] : int.tryParse(json['half_days']?.toString() ?? '0') ?? 0,
      absentDays: json['absent_days'] is int ? json['absent_days'] : int.tryParse(json['absent_days']?.toString() ?? '0') ?? 0,
      totalWorkedHours: (json['total_worked_hours'] is num)
          ? (json['total_worked_hours'] as num).toDouble()
          : double.tryParse(json['total_worked_hours']?.toString() ?? '0.0') ?? 0.0,
      totalOvertimeHours: (json['total_overtime_hours'] is num)
          ? (json['total_overtime_hours'] as num).toDouble()
          : double.tryParse(json['total_overtime_hours']?.toString() ?? '0.0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'total_records': totalRecords,
        'present_days': presentDays,
        'half_days': halfDays,
        'absent_days': absentDays,
        'total_worked_hours': totalWorkedHours,
        'total_overtime_hours': totalOvertimeHours,
      };
}

class AttendanceRecord {
  final int? id;
  final int? attendanceId;
  final String date;
  final String? clockIn;
  final String? clockOut;
  final String totalHours;
  final double totalHoursNumeric;
  final String? breakHours;
  final double breakHoursNumeric;
  final String? overtimeHours;
  final double overtimeHoursNumeric;
  final double overtimeAmount;
  final String status;
  final String? calculatedStatus;
  final AttendanceLocationDetail? checkInLocation;
  final AttendanceBranchDetail? checkInBranch;
  final AttendanceLocationDetail? checkOutLocation;
  final AttendanceBranchDetail? checkOutBranch;
  final AttendanceShiftDetail? shift;

  AttendanceRecord({
    this.id,
    this.attendanceId,
    required this.date,
    this.clockIn,
    this.clockOut,
    this.totalHours = "0.00 hours",
    this.totalHoursNumeric = 0.0,
    this.breakHours,
    this.breakHoursNumeric = 0.0,
    this.overtimeHours,
    this.overtimeHoursNumeric = 0.0,
    this.overtimeAmount = 0.0,
    this.status = "present",
    this.calculatedStatus,
    this.checkInLocation,
    this.checkInBranch,
    this.checkOutLocation,
    this.checkOutBranch,
    this.shift,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    final attId = json['attendance_id'] is int
        ? json['attendance_id']
        : int.tryParse(json['attendance_id']?.toString() ?? '') ??
            (json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''));

    AttendanceLocationDetail? inLoc;
    if (json['check_in_location'] is Map<String, dynamic>) {
      inLoc = AttendanceLocationDetail.fromJson(json['check_in_location']);
    } else if (json['check_in_location'] is String) {
      inLoc = AttendanceLocationDetail(id: 0, name: json['check_in_location']);
    }

    AttendanceBranchDetail? inBranch;
    if (json['check_in_branch'] is Map<String, dynamic>) {
      inBranch = AttendanceBranchDetail.fromJson(json['check_in_branch']);
    } else if (json['check_in_branch'] is String) {
      inBranch = AttendanceBranchDetail(id: 0, name: json['check_in_branch']);
    }

    AttendanceLocationDetail? outLoc;
    if (json['check_out_location'] is Map<String, dynamic>) {
      outLoc = AttendanceLocationDetail.fromJson(json['check_out_location']);
    } else if (json['check_out_location'] is String) {
      outLoc = AttendanceLocationDetail(id: 0, name: json['check_out_location']);
    }

    AttendanceBranchDetail? outBranch;
    if (json['check_out_branch'] is Map<String, dynamic>) {
      outBranch = AttendanceBranchDetail.fromJson(json['check_out_branch']);
    } else if (json['check_out_branch'] is String) {
      outBranch = AttendanceBranchDetail(id: 0, name: json['check_out_branch']);
    }

    AttendanceShiftDetail? sh;
    if (json['shift'] is Map<String, dynamic>) {
      sh = AttendanceShiftDetail.fromJson(json['shift']);
    }

    return AttendanceRecord(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      attendanceId: attId,
      date: json['date']?.toString() ?? '',
      clockIn: json['clock_in']?.toString(),
      clockOut: json['clock_out']?.toString(),
      totalHours: json['total_hours']?.toString() ?? '0.00 hours',
      totalHoursNumeric: (json['total_hours_numeric'] is num)
          ? (json['total_hours_numeric'] as num).toDouble()
          : double.tryParse(json['total_hours_numeric']?.toString() ?? '0.0') ?? 0.0,
      breakHours: json['break_hours']?.toString(),
      breakHoursNumeric: (json['break_hours_numeric'] is num)
          ? (json['break_hours_numeric'] as num).toDouble()
          : double.tryParse(json['break_hours_numeric']?.toString() ?? '0.0') ?? 0.0,
      overtimeHours: json['overtime_hours']?.toString(),
      overtimeHoursNumeric: (json['overtime_hours_numeric'] is num)
          ? (json['overtime_hours_numeric'] as num).toDouble()
          : double.tryParse(json['overtime_hours_numeric']?.toString() ?? '0.0') ?? 0.0,
      overtimeAmount: (json['overtime_amount'] is num)
          ? (json['overtime_amount'] as num).toDouble()
          : double.tryParse(json['overtime_amount']?.toString() ?? '0.0') ?? 0.0,
      status: json['status']?.toString() ?? 'present',
      calculatedStatus: json['calculated_status']?.toString(),
      checkInLocation: inLoc,
      checkInBranch: inBranch,
      checkOutLocation: outLoc,
      checkOutBranch: outBranch,
      shift: sh,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'attendance_id': attendanceId,
        'date': date,
        'clock_in': clockIn,
        'clock_out': clockOut,
        'total_hours': totalHours,
        'total_hours_numeric': totalHoursNumeric,
        'break_hours': breakHours,
        'break_hours_numeric': breakHoursNumeric,
        'overtime_hours': overtimeHours,
        'overtime_hours_numeric': overtimeHoursNumeric,
        'overtime_amount': overtimeAmount,
        'status': status,
        'calculated_status': calculatedStatus,
        'check_in_location': checkInLocation?.toJson(),
        'check_in_branch': checkInBranch?.toJson(),
        'check_out_location': checkOutLocation?.toJson(),
        'check_out_branch': checkOutBranch?.toJson(),
        'shift': shift?.toJson(),
      };
}

class AttendanceHistoryResponse {
  final AttendanceSummaryModel summary;
  final List<AttendanceRecord> history;

  AttendanceHistoryResponse({
    required this.summary,
    required this.history,
  });

  factory AttendanceHistoryResponse.fromJson(Map<String, dynamic> json) {
    List<AttendanceRecord> hist = [];
    if (json['history'] is List) {
      hist = (json['history'] as List)
          .map((e) => AttendanceRecord.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } else if (json['records'] is List) {
      hist = (json['records'] as List)
          .map((e) => AttendanceRecord.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }

    return AttendanceHistoryResponse(
      summary: json['summary'] is Map<String, dynamic>
          ? AttendanceSummaryModel.fromJson(json['summary'])
          : (json['summary'] is Map ? AttendanceSummaryModel.fromJson(Map<String, dynamic>.from(json['summary'])) : AttendanceSummaryModel()),
      history: hist,
    );
  }

  Map<String, dynamic> toJson() => {
        'summary': summary.toJson(),
        'history': history.map((e) => e.toJson()).toList(),
      };
}
