class KpiMetricModel {
  final int id;
  final String name;
  final String? unit;

  KpiMetricModel({required this.id, required this.name, this.unit});

  factory KpiMetricModel.fromJson(Map<String, dynamic> json) => KpiMetricModel(
        id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        name: json['name']?.toString() ?? '',
        unit: json['unit']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (unit != null) 'unit': unit,
      };
}

class CommissionPlanModel {
  final int id;
  final String name;

  CommissionPlanModel({required this.id, required this.name});

  factory CommissionPlanModel.fromJson(Map<String, dynamic> json) => CommissionPlanModel(
        id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        name: json['name']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class PerformlyProductModel {
  final int id;
  final String name;
  final double salePrice;
  final String? sku;

  PerformlyProductModel({
    required this.id,
    required this.name,
    this.salePrice = 0.0,
    this.sku,
  });

  factory PerformlyProductModel.fromJson(Map<String, dynamic> json) => PerformlyProductModel(
        id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        name: json['name']?.toString() ?? '',
        salePrice: (json['sale_price'] is num)
            ? (json['sale_price'] as num).toDouble()
            : double.tryParse(json['sale_price']?.toString() ?? '0.0') ?? 0.0,
        sku: json['sku']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'sale_price': salePrice,
        'sku': sku,
      };
}

class TargetItemModel {
  final int id;
  final int productId;
  final String productName;
  final String? productSku;
  final double targetQuantity;
  final double targetAmount;
  final double achievedQuantity;
  final double achievedAmount;

  TargetItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    this.productSku,
    this.targetQuantity = 0.0,
    this.targetAmount = 0.0,
    this.achievedQuantity = 0.0,
    this.achievedAmount = 0.0,
  });

  factory TargetItemModel.fromJson(Map<String, dynamic> json) => TargetItemModel(
        id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        productId: json['product_id'] is int ? json['product_id'] : int.tryParse(json['product_id']?.toString() ?? '0') ?? 0,
        productName: json['product_name']?.toString() ?? 'Product',
        productSku: json['product_sku']?.toString(),
        targetQuantity: (json['target_quantity'] is num)
            ? (json['target_quantity'] as num).toDouble()
            : double.tryParse(json['target_quantity']?.toString() ?? '0.0') ?? 0.0,
        targetAmount: (json['target_amount'] is num)
            ? (json['target_amount'] as num).toDouble()
            : double.tryParse(json['target_amount']?.toString() ?? '0.0') ?? 0.0,
        achievedQuantity: (json['achieved_quantity'] is num)
            ? (json['achieved_quantity'] as num).toDouble()
            : double.tryParse(json['achieved_quantity']?.toString() ?? '0.0') ?? 0.0,
        achievedAmount: (json['achieved_amount'] is num)
            ? (json['achieved_amount'] as num).toDouble()
            : double.tryParse(json['achieved_amount']?.toString() ?? '0.0') ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_id': productId,
        'product_name': productName,
        'product_sku': productSku,
        'target_quantity': targetQuantity,
        'target_amount': targetAmount,
        'achieved_quantity': achievedQuantity,
        'achieved_amount': achievedAmount,
      };
}

class SalesLogModel {
  final int id;
  final int targetId;
  final String? targetTitle;
  final int? productId;
  final String? productName;
  final String entryType; // 'item_wise' or 'overall'
  final String logDate;
  final double quantity;
  final double unitPrice;
  final double totalAmount;
  final String? customerName;
  final String? invoiceNo;
  final String status; // 'pending', 'approved', 'rejected'
  final String? notes;
  final String? rejectionReason;
  final String? approvedByName;
  final String? approvedAt;
  final String? userName;

  SalesLogModel({
    required this.id,
    required this.targetId,
    this.targetTitle,
    this.productId,
    this.productName,
    this.entryType = 'overall',
    required this.logDate,
    this.quantity = 0.0,
    this.unitPrice = 0.0,
    this.totalAmount = 0.0,
    this.customerName,
    this.invoiceNo,
    this.status = 'pending',
    this.notes,
    this.rejectionReason,
    this.approvedByName,
    this.approvedAt,
    this.userName,
  });

  factory SalesLogModel.fromJson(Map<String, dynamic> json) => SalesLogModel(
        id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        targetId: json['target_id'] is int ? json['target_id'] : int.tryParse(json['target_id']?.toString() ?? '0') ?? 0,
        targetTitle: json['target_title']?.toString(),
        productId: json['product_id'] is int ? json['product_id'] : int.tryParse(json['product_id']?.toString() ?? ''),
        productName: json['product_name']?.toString(),
        entryType: json['entry_type']?.toString() ?? 'overall',
        logDate: json['log_date']?.toString() ?? '',
        quantity: (json['quantity'] is num)
            ? (json['quantity'] as num).toDouble()
            : double.tryParse(json['quantity']?.toString() ?? '0.0') ?? 0.0,
        unitPrice: (json['unit_price'] is num)
            ? (json['unit_price'] as num).toDouble()
            : double.tryParse(json['unit_price']?.toString() ?? '0.0') ?? 0.0,
        totalAmount: (json['total_amount'] is num)
            ? (json['total_amount'] as num).toDouble()
            : double.tryParse(json['total_amount']?.toString() ?? '0.0') ?? 0.0,
        customerName: json['customer_name']?.toString(),
        invoiceNo: json['invoice_no']?.toString(),
        status: json['status']?.toString().toLowerCase() ?? 'pending',
        notes: json['notes']?.toString(),
        rejectionReason: json['rejection_reason']?.toString(),
        approvedByName: json['approved_by_name']?.toString(),
        approvedAt: json['approved_at']?.toString(),
        userName: json['user_name']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'target_id': targetId,
        'target_title': targetTitle,
        'product_id': productId,
        'product_name': productName,
        'entry_type': entryType,
        'log_date': logDate,
        'quantity': quantity,
        'unit_price': unitPrice,
        'total_amount': totalAmount,
        'customer_name': customerName,
        'invoice_no': invoiceNo,
        'status': status,
        'notes': notes,
        'rejection_reason': rejectionReason,
        'approved_by_name': approvedByName,
        'approved_at': approvedAt,
        'user_name': userName,
      };
}

class PerformlyStatsModel {
  final double totalTargetAmount;
  final double totalAchievedAmount;
  final double overallAchievementPercentage;
  final double totalSalesLogged;
  final double totalUnitsSold;
  final double totalCommissionEarned;
  final int pendingLogsCount;
  final int activeTargetsCount;

  PerformlyStatsModel({
    this.totalTargetAmount = 0.0,
    this.totalAchievedAmount = 0.0,
    this.overallAchievementPercentage = 0.0,
    this.totalSalesLogged = 0.0,
    this.totalUnitsSold = 0.0,
    this.totalCommissionEarned = 0.0,
    this.pendingLogsCount = 0,
    this.activeTargetsCount = 0,
  });

  factory PerformlyStatsModel.fromJson(Map<String, dynamic> json) => PerformlyStatsModel(
        totalTargetAmount: (json['total_target_amount'] is num)
            ? (json['total_target_amount'] as num).toDouble()
            : double.tryParse(json['total_target_amount']?.toString() ?? '0.0') ?? 0.0,
        totalAchievedAmount: (json['total_achieved_amount'] is num)
            ? (json['total_achieved_amount'] as num).toDouble()
            : double.tryParse(json['total_achieved_amount']?.toString() ?? '0.0') ?? 0.0,
        overallAchievementPercentage: (json['overall_achievement_percentage'] is num)
            ? (json['overall_achievement_percentage'] as num).toDouble()
            : double.tryParse(json['overall_achievement_percentage']?.toString() ?? '0.0') ?? 0.0,
        totalSalesLogged: (json['total_sales_logged'] is num)
            ? (json['total_sales_logged'] as num).toDouble()
            : double.tryParse(json['total_sales_logged']?.toString() ?? '0.0') ?? 0.0,
        totalUnitsSold: (json['total_units_sold'] is num)
            ? (json['total_units_sold'] as num).toDouble()
            : double.tryParse(json['total_units_sold']?.toString() ?? '0.0') ?? 0.0,
        totalCommissionEarned: (json['total_commission_earned'] is num)
            ? (json['total_commission_earned'] as num).toDouble()
            : double.tryParse(json['total_commission_earned']?.toString() ?? '0.0') ?? 0.0,
        pendingLogsCount: json['pending_logs_count'] is int ? json['pending_logs_count'] : int.tryParse(json['pending_logs_count']?.toString() ?? '0') ?? 0,
        activeTargetsCount: json['active_targets_count'] is int ? json['active_targets_count'] : int.tryParse(json['active_targets_count']?.toString() ?? '0') ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'total_target_amount': totalTargetAmount,
        'total_achieved_amount': totalAchievedAmount,
        'overall_achievement_percentage': overallAchievementPercentage,
        'total_sales_logged': totalSalesLogged,
        'total_units_sold': totalUnitsSold,
        'total_commission_earned': totalCommissionEarned,
        'pending_logs_count': pendingLogsCount,
        'active_targets_count': activeTargetsCount,
      };
}

class TargetModel {
  final int id;
  final String title;
  final String targetType; // 'overall_amount', 'overall_quantity', 'item_wise'
  final String periodType; // 'daily', 'weekly', 'monthly', 'quarterly', 'yearly'
  final String startDate;
  final String endDate;
  final double targetAmount;
  final double targetQuantity;
  final double achievedAmount;
  final double achievedQuantity;
  final double achievementPercentage;
  final String status; // 'active', 'completed', 'cancelled'
  final String? notes;
  final KpiMetricModel? kpiMetric;
  final CommissionPlanModel? commissionPlan;
  final List<TargetItemModel> items;
  final List<SalesLogModel> recentSalesLogs;

  TargetModel({
    required this.id,
    required this.title,
    required this.targetType,
    required this.periodType,
    required this.startDate,
    required this.endDate,
    this.targetAmount = 0.0,
    this.targetQuantity = 0.0,
    this.achievedAmount = 0.0,
    this.achievedQuantity = 0.0,
    this.achievementPercentage = 0.0,
    this.status = 'active',
    this.notes,
    this.kpiMetric,
    this.commissionPlan,
    this.items = const [],
    this.recentSalesLogs = const [],
  });

  factory TargetModel.fromJson(Map<String, dynamic> json) {
    var rawItems = json['items'] as List<dynamic>?;
    List<TargetItemModel> itemsList = rawItems != null
        ? rawItems.map((e) => TargetItemModel.fromJson(Map<String, dynamic>.from(e as Map))).toList()
        : [];

    var rawLogs = json['recent_sales_logs'] as List<dynamic>?;
    List<SalesLogModel> logsList = rawLogs != null
        ? rawLogs.map((e) => SalesLogModel.fromJson(Map<String, dynamic>.from(e as Map))).toList()
        : [];

    return TargetModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      targetType: json['target_type']?.toString() ?? 'overall_amount',
      periodType: json['period_type']?.toString() ?? 'monthly',
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      targetAmount: (json['target_amount'] is num)
          ? (json['target_amount'] as num).toDouble()
          : double.tryParse(json['target_amount']?.toString() ?? '0.0') ?? 0.0,
      targetQuantity: (json['target_quantity'] is num)
          ? (json['target_quantity'] as num).toDouble()
          : double.tryParse(json['target_quantity']?.toString() ?? '0.0') ?? 0.0,
      achievedAmount: (json['achieved_amount'] is num)
          ? (json['achieved_amount'] as num).toDouble()
          : double.tryParse(json['achieved_amount']?.toString() ?? '0.0') ?? 0.0,
      achievedQuantity: (json['achieved_quantity'] is num)
          ? (json['achieved_quantity'] as num).toDouble()
          : double.tryParse(json['achieved_quantity']?.toString() ?? '0.0') ?? 0.0,
      achievementPercentage: (json['achievement_percentage'] is num)
          ? (json['achievement_percentage'] as num).toDouble()
          : double.tryParse(json['achievement_percentage']?.toString() ?? '0.0') ?? 0.0,
      status: json['status']?.toString() ?? 'active',
      notes: json['notes']?.toString(),
      kpiMetric: json['kpi_metric'] is Map<String, dynamic>
          ? KpiMetricModel.fromJson(json['kpi_metric'])
          : (json['kpi_metric'] is Map ? KpiMetricModel.fromJson(Map<String, dynamic>.from(json['kpi_metric'])) : null),
      commissionPlan: json['commission_plan'] is Map<String, dynamic>
          ? CommissionPlanModel.fromJson(json['commission_plan'])
          : (json['commission_plan'] is Map ? CommissionPlanModel.fromJson(Map<String, dynamic>.from(json['commission_plan'])) : null),
      items: itemsList,
      recentSalesLogs: logsList,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'target_type': targetType,
        'period_type': periodType,
        'start_date': startDate,
        'end_date': endDate,
        'target_amount': targetAmount,
        'target_quantity': targetQuantity,
        'achieved_amount': achievedAmount,
        'achieved_quantity': achievedQuantity,
        'achievement_percentage': achievementPercentage,
        'status': status,
        'notes': notes,
        'kpi_metric': kpiMetric?.toJson(),
        'commission_plan': commissionPlan?.toJson(),
        'items': items.map((e) => e.toJson()).toList(),
        'recent_sales_logs': recentSalesLogs.map((e) => e.toJson()).toList(),
      };
}

class PerformlyTargetsResponse {
  final PerformlyStatsModel stats;
  final int total;
  final List<TargetModel> targets;

  PerformlyTargetsResponse({
    required this.stats,
    this.total = 0,
    this.targets = const [],
  });

  factory PerformlyTargetsResponse.fromJson(Map<String, dynamic> json) {
    var rawTargets = json['targets'] as List<dynamic>?;
    List<TargetModel> targetsList = rawTargets != null
        ? rawTargets.map((e) => TargetModel.fromJson(Map<String, dynamic>.from(e as Map))).toList()
        : [];

    return PerformlyTargetsResponse(
      stats: json['stats'] is Map<String, dynamic>
          ? PerformlyStatsModel.fromJson(json['stats'])
          : (json['stats'] is Map ? PerformlyStatsModel.fromJson(Map<String, dynamic>.from(json['stats'])) : PerformlyStatsModel()),
      total: json['total'] is int ? json['total'] : int.tryParse(json['total']?.toString() ?? '0') ?? targetsList.length,
      targets: targetsList,
    );
  }

  Map<String, dynamic> toJson() => {
        'stats': stats.toJson(),
        'total': total,
        'targets': targets.map((e) => e.toJson()).toList(),
      };
}

class SalesLogsHistoryResponse {
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;
  final List<SalesLogModel> items;

  SalesLogsHistoryResponse({
    this.total = 0,
    this.perPage = 15,
    this.currentPage = 1,
    this.lastPage = 1,
    this.items = const [],
  });

  factory SalesLogsHistoryResponse.fromJson(Map<String, dynamic> json) {
    final pagination = json['pagination'] is Map ? Map<String, dynamic>.from(json['pagination'] as Map) : json;
    var rawItems = json['items'] as List<dynamic>? ?? [];

    return SalesLogsHistoryResponse(
      total: pagination['total'] is int ? pagination['total'] : int.tryParse(pagination['total']?.toString() ?? '0') ?? 0,
      perPage: pagination['per_page'] is int ? pagination['per_page'] : int.tryParse(pagination['per_page']?.toString() ?? '15') ?? 15,
      currentPage: pagination['current_page'] is int ? pagination['current_page'] : int.tryParse(pagination['current_page']?.toString() ?? '1') ?? 1,
      lastPage: pagination['last_page'] is int ? pagination['last_page'] : int.tryParse(pagination['last_page']?.toString() ?? '1') ?? 1,
      items: rawItems.map((e) => SalesLogModel.fromJson(Map<String, dynamic>.from(e as Map))).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'pagination': {
          'total': total,
          'per_page': perPage,
          'current_page': currentPage,
          'last_page': lastPage,
        },
        'items': items.map((e) => e.toJson()).toList(),
      };
}
