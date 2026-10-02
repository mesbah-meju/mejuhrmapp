class TaskSummaryModel {
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;
  final int progressPercentage;

  TaskSummaryModel({
    this.totalTasks = 0,
    this.completedTasks = 0,
    this.pendingTasks = 0,
    this.progressPercentage = 0,
  });

  factory TaskSummaryModel.fromJson(Map<String, dynamic> json) => TaskSummaryModel(
        totalTasks: json['total_tasks'] is int ? json['total_tasks'] : int.tryParse(json['total_tasks']?.toString() ?? '0') ?? 0,
        completedTasks: json['completed_tasks'] is int ? json['completed_tasks'] : int.tryParse(json['completed_tasks']?.toString() ?? '0') ?? 0,
        pendingTasks: json['pending_tasks'] is int ? json['pending_tasks'] : int.tryParse(json['pending_tasks']?.toString() ?? '0') ?? 0,
        progressPercentage: json['progress_percentage'] is int
            ? json['progress_percentage']
            : (json['progress_percentage'] is num
                ? (json['progress_percentage'] as num).round()
                : int.tryParse(json['progress_percentage']?.toString() ?? '0') ?? 0),
      );

  Map<String, dynamic> toJson() => {
        'total_tasks': totalTasks,
        'completed_tasks': completedTasks,
        'pending_tasks': pendingTasks,
        'progress_percentage': progressPercentage,
      };
}

class BranchTaskModel {
  final int id;
  final String taskName;
  final String? description;
  final int? branchId;
  final bool isCompleted;
  final String status; // 'pending', 'completed', 'approved', 'rejected'
  final bool completedByMe;
  final bool completedByOther;
  final int? completedBy;
  final String? completedByName;
  final String? completedAt;
  final String? notes;
  final String? managerComment;
  final String? approvedByName;
  final String? approvedAt;
  final bool canToggle;

  BranchTaskModel({
    required this.id,
    required this.taskName,
    this.description,
    this.branchId,
    this.isCompleted = false,
    this.status = 'pending',
    this.completedByMe = false,
    this.completedByOther = false,
    this.completedBy,
    this.completedByName,
    this.completedAt,
    this.notes,
    this.managerComment,
    this.approvedByName,
    this.approvedAt,
    this.canToggle = true,
  });

  factory BranchTaskModel.fromJson(Map<String, dynamic> json) {
    final bool completed = json['is_completed'] == true || json['is_completed'] == 1 || json['status'] == 'completed' || json['status'] == 'approved';
    final String stat = json['status']?.toString().toLowerCase() ?? (completed ? 'completed' : 'pending');

    return BranchTaskModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      taskName: json['task_name']?.toString() ?? json['name']?.toString() ?? 'Task',
      description: json['description']?.toString(),
      branchId: json['branch_id'] is int ? json['branch_id'] : int.tryParse(json['branch_id']?.toString() ?? ''),
      isCompleted: completed,
      status: stat,
      completedByMe: json['completed_by_me'] == true || json['completed_by_me'] == 1,
      completedByOther: json['completed_by_other'] == true || json['completed_by_other'] == 1,
      completedBy: json['completed_by'] is int ? json['completed_by'] : int.tryParse(json['completed_by']?.toString() ?? ''),
      completedByName: json['completed_by_name']?.toString(),
      completedAt: json['completed_at']?.toString(),
      notes: json['notes']?.toString(),
      managerComment: json['manager_comment']?.toString(),
      approvedByName: json['approved_by_name']?.toString(),
      approvedAt: json['approved_at']?.toString(),
      canToggle: json['can_toggle'] == true || (json['can_toggle'] == null && !json['completed_by_other'] && stat != 'approved'),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'task_name': taskName,
        'description': description,
        'branch_id': branchId,
        'is_completed': isCompleted,
        'status': status,
        'completed_by_me': completedByMe,
        'completed_by_other': completedByOther,
        'completed_by': completedBy,
        'completed_by_name': completedByName,
        'completed_at': completedAt,
        'notes': notes,
        'manager_comment': managerComment,
        'approved_by_name': approvedByName,
        'approved_at': approvedAt,
        'can_toggle': canToggle,
      };

  BranchTaskModel copyWith({
    bool? isCompleted,
    String? status,
    bool? completedByMe,
    bool? completedByOther,
    int? completedBy,
    String? completedByName,
    String? completedAt,
    String? notes,
    String? managerComment,
    String? approvedByName,
    String? approvedAt,
    bool? canToggle,
  }) {
    return BranchTaskModel(
      id: id,
      taskName: taskName,
      description: description,
      branchId: branchId,
      isCompleted: isCompleted ?? this.isCompleted,
      status: status ?? this.status,
      completedByMe: completedByMe ?? this.completedByMe,
      completedByOther: completedByOther ?? this.completedByOther,
      completedBy: completedBy ?? this.completedBy,
      completedByName: completedByName ?? this.completedByName,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
      managerComment: managerComment ?? this.managerComment,
      approvedByName: approvedByName ?? this.approvedByName,
      approvedAt: approvedAt ?? this.approvedAt,
      canToggle: canToggle ?? this.canToggle,
    );
  }
}

class TodayTasksResponse {
  final bool isClockedIn;
  final bool canViewTasks;
  final String? message;
  final int? branchId;
  final String? branchName;
  final TaskSummaryModel summary;
  final List<BranchTaskModel> tasks;

  TodayTasksResponse({
    required this.isClockedIn,
    this.canViewTasks = true,
    this.message,
    this.branchId,
    this.branchName,
    required this.summary,
    required this.tasks,
  });

  factory TodayTasksResponse.fromJson(Map<String, dynamic> json) {
    List<BranchTaskModel> taskList = [];
    if (json['tasks'] is List) {
      taskList = (json['tasks'] as List)
          .map((e) => BranchTaskModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }

    final bool clocked = json['is_clocked_in'] == true || json['is_clocked_in'] == 1;

    return TodayTasksResponse(
      isClockedIn: clocked,
      canViewTasks: json['can_view_tasks'] != false && clocked,
      message: json['message']?.toString(),
      branchId: json['branch_id'] is int ? json['branch_id'] : int.tryParse(json['branch_id']?.toString() ?? ''),
      branchName: json['branch_name']?.toString(),
      summary: json['summary'] is Map<String, dynamic>
          ? TaskSummaryModel.fromJson(json['summary'])
          : (json['summary'] is Map ? TaskSummaryModel.fromJson(Map<String, dynamic>.from(json['summary'])) : TaskSummaryModel()),
      tasks: taskList,
    );
  }

  Map<String, dynamic> toJson() => {
        'is_clocked_in': isClockedIn,
        'can_view_tasks': canViewTasks,
        'message': message,
        'branch_id': branchId,
        'branch_name': branchName,
        'summary': summary.toJson(),
        'tasks': tasks.map((e) => e.toJson()).toList(),
      };
}

class TaskPaginationModel {
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;

  TaskPaginationModel({
    this.total = 0,
    this.perPage = 15,
    this.currentPage = 1,
    this.lastPage = 1,
  });

  factory TaskPaginationModel.fromJson(Map<String, dynamic> json) => TaskPaginationModel(
        total: json['total'] is int ? json['total'] : int.tryParse(json['total']?.toString() ?? '0') ?? 0,
        perPage: json['per_page'] is int ? json['per_page'] : int.tryParse(json['per_page']?.toString() ?? '15') ?? 15,
        currentPage: json['current_page'] is int ? json['current_page'] : int.tryParse(json['current_page']?.toString() ?? '1') ?? 1,
        lastPage: json['last_page'] is int ? json['last_page'] : int.tryParse(json['last_page']?.toString() ?? '1') ?? 1,
      );

  Map<String, dynamic> toJson() => {
        'total': total,
        'per_page': perPage,
        'current_page': currentPage,
        'last_page': lastPage,
      };
}

class TaskHistoryItemModel {
  final int id;
  final int taskId;
  final String taskName;
  final String? taskDescription;
  final int? branchId;
  final String? branchName;
  final String date;
  final String status; // 'completed', 'approved', 'rejected'
  final String? completedAt;
  final String? notes;
  final String? managerComment;
  final String? approvedByName;
  final String? approvedAt;

  TaskHistoryItemModel({
    required this.id,
    required this.taskId,
    required this.taskName,
    this.taskDescription,
    this.branchId,
    this.branchName,
    required this.date,
    this.status = 'completed',
    this.completedAt,
    this.notes,
    this.managerComment,
    this.approvedByName,
    this.approvedAt,
  });

  factory TaskHistoryItemModel.fromJson(Map<String, dynamic> json) => TaskHistoryItemModel(
        id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        taskId: json['task_id'] is int ? json['task_id'] : int.tryParse(json['task_id']?.toString() ?? '0') ?? 0,
        taskName: json['task_name']?.toString() ?? '',
        taskDescription: json['task_description']?.toString(),
        branchId: json['branch_id'] is int ? json['branch_id'] : int.tryParse(json['branch_id']?.toString() ?? ''),
        branchName: json['branch_name']?.toString(),
        date: json['date']?.toString() ?? '',
        status: json['status']?.toString() ?? 'completed',
        completedAt: json['completed_at']?.toString(),
        notes: json['notes']?.toString(),
        managerComment: json['manager_comment']?.toString(),
        approvedByName: json['approved_by_name']?.toString(),
        approvedAt: json['approved_at']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'task_id': taskId,
        'task_name': taskName,
        'task_description': taskDescription,
        'branch_id': branchId,
        'branch_name': branchName,
        'date': date,
        'status': status,
        'completed_at': completedAt,
        'notes': notes,
        'manager_comment': managerComment,
        'approved_by_name': approvedByName,
        'approved_at': approvedAt,
      };
}

class TaskHistoryResponse {
  final TaskPaginationModel pagination;
  final List<TaskHistoryItemModel> items;

  TaskHistoryResponse({
    required this.pagination,
    required this.items,
  });

  factory TaskHistoryResponse.fromJson(Map<String, dynamic> json) {
    List<TaskHistoryItemModel> list = [];
    if (json['items'] is List) {
      list = (json['items'] as List)
          .map((e) => TaskHistoryItemModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } else if (json['tasks'] is List) {
      list = (json['tasks'] as List)
          .map((e) => TaskHistoryItemModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }

    return TaskHistoryResponse(
      pagination: json['pagination'] is Map<String, dynamic>
          ? TaskPaginationModel.fromJson(json['pagination'])
          : TaskPaginationModel(),
      items: list,
    );
  }

  Map<String, dynamic> toJson() => {
        'pagination': pagination.toJson(),
        'items': items.map((e) => e.toJson()).toList(),
      };
}

class ManagerTaskCompletionModel {
  final int id;
  final int taskId;
  final String taskName;
  final String? taskDescription;
  final int employeeId;
  final String employeeName;
  final String? employeeEmail;
  final String? employeeAvatar;
  final int? branchId;
  final String? branchName;
  final String date;
  final String status; // 'completed', 'approved', 'rejected'
  final String? completedAt;
  final String? notes;
  final String? managerComment;
  final int? approvedBy;
  final String? approvedByName;
  final String? approvedAt;

  ManagerTaskCompletionModel({
    required this.id,
    required this.taskId,
    required this.taskName,
    this.taskDescription,
    required this.employeeId,
    required this.employeeName,
    this.employeeEmail,
    this.employeeAvatar,
    this.branchId,
    this.branchName,
    required this.date,
    this.status = 'completed',
    this.completedAt,
    this.notes,
    this.managerComment,
    this.approvedBy,
    this.approvedByName,
    this.approvedAt,
  });

  factory ManagerTaskCompletionModel.fromJson(Map<String, dynamic> json) => ManagerTaskCompletionModel(
        id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        taskId: json['task_id'] is int ? json['task_id'] : int.tryParse(json['task_id']?.toString() ?? '0') ?? 0,
        taskName: json['task_name']?.toString() ?? '',
        taskDescription: json['task_description']?.toString(),
        employeeId: json['employee_id'] is int ? json['employee_id'] : int.tryParse(json['employee_id']?.toString() ?? '0') ?? 0,
        employeeName: json['employee_name']?.toString() ?? 'Employee',
        employeeEmail: json['employee_email']?.toString(),
        employeeAvatar: json['employee_avatar']?.toString(),
        branchId: json['branch_id'] is int ? json['branch_id'] : int.tryParse(json['branch_id']?.toString() ?? ''),
        branchName: json['branch_name']?.toString(),
        date: json['date']?.toString() ?? '',
        status: json['status']?.toString() ?? 'completed',
        completedAt: json['completed_at']?.toString(),
        notes: json['notes']?.toString(),
        managerComment: json['manager_comment']?.toString(),
        approvedBy: json['approved_by'] is int ? json['approved_by'] : int.tryParse(json['approved_by']?.toString() ?? ''),
        approvedByName: json['approved_by_name']?.toString(),
        approvedAt: json['approved_at']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'task_id': taskId,
        'task_name': taskName,
        'task_description': taskDescription,
        'employee_id': employeeId,
        'employee_name': employeeName,
        'employee_email': employeeEmail,
        'employee_avatar': employeeAvatar,
        'branch_id': branchId,
        'branch_name': branchName,
        'date': date,
        'status': status,
        'completed_at': completedAt,
        'notes': notes,
        'manager_comment': managerComment,
        'approved_by': approvedBy,
        'approved_by_name': approvedByName,
        'approved_at': approvedAt,
      };

  ManagerTaskCompletionModel copyWith({
    String? status,
    String? managerComment,
    String? approvedByName,
    String? approvedAt,
  }) {
    return ManagerTaskCompletionModel(
      id: id,
      taskId: taskId,
      taskName: taskName,
      taskDescription: taskDescription,
      employeeId: employeeId,
      employeeName: employeeName,
      employeeEmail: employeeEmail,
      employeeAvatar: employeeAvatar,
      branchId: branchId,
      branchName: branchName,
      date: date,
      status: status ?? this.status,
      completedAt: completedAt,
      notes: notes,
      managerComment: managerComment ?? this.managerComment,
      approvedBy: approvedBy,
      approvedByName: approvedByName ?? this.approvedByName,
      approvedAt: approvedAt ?? this.approvedAt,
    );
  }
}

class ManagerTaskCompletionsResponse {
  final TaskPaginationModel pagination;
  final List<ManagerTaskCompletionModel> items;

  ManagerTaskCompletionsResponse({
    required this.pagination,
    required this.items,
  });

  factory ManagerTaskCompletionsResponse.fromJson(Map<String, dynamic> json) {
    List<ManagerTaskCompletionModel> list = [];
    if (json['items'] is List) {
      list = (json['items'] as List)
          .map((e) => ManagerTaskCompletionModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }

    return ManagerTaskCompletionsResponse(
      pagination: json['pagination'] is Map<String, dynamic>
          ? TaskPaginationModel.fromJson(json['pagination'])
          : TaskPaginationModel(),
      items: list,
    );
  }

  Map<String, dynamic> toJson() => {
        'pagination': pagination.toJson(),
        'items': items.map((e) => e.toJson()).toList(),
      };
}
