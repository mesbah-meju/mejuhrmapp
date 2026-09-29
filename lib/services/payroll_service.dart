import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:auth_ui_app/services/timeline_service.dart';

class PayrollItem {
  final String id;
  final String employeeName;
  final String employeeId;
  final String designation;
  final String department;
  final String bankName;
  final String accountNumber;
  final String bKashNumber;
  
  double baseSalary;
  int daysPresent;
  int totalWorkDays;
  double overtimeHours;
  double overtimeRatePerHour;
  double commissionBonus;
  double allowances;
  double deductions;
  
  String paymentStatus; // 'Pending', 'Disbursed', 'Processing'
  DateTime? disbursedAt;
  String? disbursementMethod;
  String? transactionRef;

  PayrollItem({
    required this.id,
    required this.employeeName,
    required this.employeeId,
    required this.designation,
    required this.department,
    required this.bankName,
    required this.accountNumber,
    required this.bKashNumber,
    required this.baseSalary,
    this.daysPresent = 22,
    this.totalWorkDays = 22,
    this.overtimeHours = 0.0,
    this.overtimeRatePerHour = 200.0,
    this.commissionBonus = 0.0,
    this.allowances = 0.0,
    this.deductions = 0.0,
    this.paymentStatus = 'Pending',
    this.disbursedAt,
    this.disbursementMethod,
    this.transactionRef,
  });

  /// Earned Base Salary based on attendance days
  double get earnedBaseSalary => (baseSalary / (totalWorkDays > 0 ? totalWorkDays : 1)) * daysPresent;

  /// Calculated Total Overtime Pay
  double get overtimePay => overtimeHours * overtimeRatePerHour;

  /// Gross Earnings before deductions
  double get grossEarnings => earnedBaseSalary + overtimePay + commissionBonus + allowances;

  /// Net Amount Payable to Employee
  double get netPayable => (grossEarnings - deductions).clamp(0.0, 9999999.0);

  Map<String, dynamic> toJson() => {
        'id': id,
        'employeeName': employeeName,
        'employeeId': employeeId,
        'designation': designation,
        'department': department,
        'bankName': bankName,
        'accountNumber': accountNumber,
        'bKashNumber': bKashNumber,
        'baseSalary': baseSalary,
        'daysPresent': daysPresent,
        'totalWorkDays': totalWorkDays,
        'overtimeHours': overtimeHours,
        'overtimeRatePerHour': overtimeRatePerHour,
        'commissionBonus': commissionBonus,
        'allowances': allowances,
        'deductions': deductions,
        'paymentStatus': paymentStatus,
        'disbursedAt': disbursedAt?.toIso8601String(),
        'disbursementMethod': disbursementMethod,
        'transactionRef': transactionRef,
      };

  factory PayrollItem.fromJson(Map<String, dynamic> json) => PayrollItem(
        id: json['id'],
        employeeName: json['employeeName'],
        employeeId: json['employeeId'],
        designation: json['designation'],
        department: json['department'],
        bankName: json['bankName'] ?? 'City Bank Ltd',
        accountNumber: json['accountNumber'] ?? '110-2394829-01',
        bKashNumber: json['bKashNumber'] ?? '01711-908234',
        baseSalary: (json['baseSalary'] as num).toDouble(),
        daysPresent: json['daysPresent'] ?? 22,
        totalWorkDays: json['totalWorkDays'] ?? 22,
        overtimeHours: (json['overtimeHours'] as num? ?? 0.0).toDouble(),
        overtimeRatePerHour: (json['overtimeRatePerHour'] as num? ?? 200.0).toDouble(),
        commissionBonus: (json['commissionBonus'] as num? ?? 0.0).toDouble(),
        allowances: (json['allowances'] as num? ?? 0.0).toDouble(),
        deductions: (json['deductions'] as num? ?? 0.0).toDouble(),
        paymentStatus: json['paymentStatus'] ?? 'Pending',
        disbursedAt: json['disbursedAt'] != null ? DateTime.parse(json['disbursedAt']) : null,
        disbursementMethod: json['disbursementMethod'],
        transactionRef: json['transactionRef'],
      );
}

class PayrollService extends ChangeNotifier {
  static final PayrollService instance = PayrollService._internal();
  factory PayrollService() => instance;
  PayrollService._internal() {
    _loadFromStorage();
  }

  final List<PayrollItem> _items = [];
  final GetStorage _storage = GetStorage();
  static const String _storageKey = 'manager_payroll_items_v1';

  List<PayrollItem> get items => List.unmodifiable(_items);

  List<PayrollItem> get pendingItems => _items.where((i) => i.paymentStatus == 'Pending').toList();
  List<PayrollItem> get disbursedItems => _items.where((i) => i.paymentStatus == 'Disbursed').toList();

  double get totalBudget => _items.fold(0.0, (sum, item) => sum + item.netPayable);
  double get totalDisbursed => _items.where((i) => i.paymentStatus == 'Disbursed').fold(0.0, (sum, item) => sum + item.netPayable);
  double get totalPending => _items.where((i) => i.paymentStatus == 'Pending').fold(0.0, (sum, item) => sum + item.netPayable);

  void _loadFromStorage() {
    try {
      final List<dynamic>? raw = _storage.read<List<dynamic>>(_storageKey);
      if (raw != null && raw.isNotEmpty) {
        _items.clear();
        _items.addAll(raw.map((e) => PayrollItem.fromJson(Map<String, dynamic>.from(e))));
        notifyListeners();
        return;
      }
    } catch (e) {
      debugPrint("Failed to load payroll from storage: $e");
    }
    _seedDefaultItems();
  }

  void _seedDefaultItems() {
    _items.clear();
    _items.addAll([
      PayrollItem(
        id: 'PAY-001',
        employeeName: 'Rahul Sharma',
        employeeId: 'EMP-1001',
        designation: 'Senior Sales Executive',
        department: 'Sales & Business',
        bankName: 'BRAC Bank PLC',
        accountNumber: '1501-204918-001',
        bKashNumber: '01819-234567',
        baseSalary: 45000.0,
        daysPresent: 22,
        totalWorkDays: 22,
        overtimeHours: 14.0,
        overtimeRatePerHour: 250.0,
        commissionBonus: 12000.0,
        allowances: 4000.0,
        deductions: 1500.0,
        paymentStatus: 'Pending',
      ),
      PayrollItem(
        id: 'PAY-002',
        employeeName: 'Ananya Roy',
        employeeId: 'EMP-1002',
        designation: 'Sales Associate',
        department: 'Sales & Operations',
        bankName: 'Dutch-Bangla Bank',
        accountNumber: '110-105-983421',
        bKashNumber: '01712-345678',
        baseSalary: 32000.0,
        daysPresent: 20,
        totalWorkDays: 22,
        overtimeHours: 8.0,
        overtimeRatePerHour: 200.0,
        commissionBonus: 6500.0,
        allowances: 3000.0,
        deductions: 2909.0, // deducted for 2 days absent
        paymentStatus: 'Pending',
      ),
      PayrollItem(
        id: 'PAY-003',
        employeeName: 'Tanvir Ahmed',
        employeeId: 'EMP-1003',
        designation: 'Business Analyst',
        department: 'Strategy & Analytics',
        bankName: 'City Bank Ltd',
        accountNumber: '220-3948512-01',
        bKashNumber: '01911-876543',
        baseSalary: 40000.0,
        daysPresent: 22,
        totalWorkDays: 22,
        overtimeHours: 6.0,
        overtimeRatePerHour: 220.0,
        commissionBonus: 4000.0,
        allowances: 3500.0,
        deductions: 1000.0,
        paymentStatus: 'Disbursed',
        disbursedAt: DateTime.now().subtract(const Duration(days: 2)),
        disbursementMethod: 'Bank Transfer (EFTN)',
        transactionRef: 'EFTN-8492049182',
      ),
      PayrollItem(
        id: 'PAY-004',
        employeeName: 'Nusrat Jahan',
        employeeId: 'EMP-1004',
        designation: 'HR Coordinator',
        department: 'Human Resources',
        bankName: 'Eastern Bank Ltd',
        accountNumber: '104-120-492019',
        bKashNumber: '01615-998877',
        baseSalary: 28000.0,
        daysPresent: 21,
        totalWorkDays: 22,
        overtimeHours: 0.0,
        commissionBonus: 2500.0,
        allowances: 2500.0,
        deductions: 1272.0,
        paymentStatus: 'Pending',
      ),
      PayrollItem(
        id: 'PAY-005',
        employeeName: 'Mahmud Hasan',
        employeeId: 'EMP-1005',
        designation: 'Support Engineer',
        department: 'IT & Support',
        bankName: 'Mutual Trust Bank',
        accountNumber: '002-3948102-99',
        bKashNumber: '01511-223344',
        baseSalary: 35000.0,
        daysPresent: 22,
        totalWorkDays: 22,
        overtimeHours: 18.0,
        overtimeRatePerHour: 220.0,
        commissionBonus: 5000.0,
        allowances: 3000.0,
        deductions: 800.0,
        paymentStatus: 'Disbursed',
        disbursedAt: DateTime.now().subtract(const Duration(days: 1)),
        disbursementMethod: 'bKash Payroll',
        transactionRef: 'BKASH-TXN-994821',
      ),
    ]);
    _saveToStorage();
  }

  void _saveToStorage() {
    try {
      final data = _items.map((e) => e.toJson()).toList();
      _storage.write(_storageKey, data);
    } catch (e) {
      debugPrint("Failed saving payroll to storage: $e");
    }
  }

  /// Update calculations for an employee
  void updateCalculation(
    String id, {
    double? bonus,
    double? overtimeHours,
    double? deductions,
    int? daysPresent,
  }) {
    final index = _items.indexWhere((i) => i.id == id);
    if (index != -1) {
      if (bonus != null) _items[index].commissionBonus = bonus;
      if (overtimeHours != null) _items[index].overtimeHours = overtimeHours;
      if (deductions != null) _items[index].deductions = deductions;
      if (daysPresent != null) _items[index].daysPresent = daysPresent;
      _saveToStorage();
      notifyListeners();
    }
  }

  /// Disburse / Pay Salary to Employee
  void disbursePayment(String id, {required String method, required String reference}) {
    final index = _items.indexWhere((i) => i.id == id);
    if (index != -1) {
      final item = _items[index];
      item.paymentStatus = 'Disbursed';
      item.disbursedAt = DateTime.now();
      item.disbursementMethod = method;
      item.transactionRef = reference;

      // Log in timeline
      TimelineService.instance.logEvent(
        ActivityEvent(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          uuid: '01K-PAY-${DateTime.now().millisecondsSinceEpoch}',
          eventType: 'payroll.paid',
          title: 'Payroll Disbursed: ${item.employeeName}',
          description: 'BDT ${item.netPayable.toStringAsFixed(0)} paid via $method (Ref: $reference)',
          metadata: {
            'amount': item.netPayable,
            'method': method,
            'reference': reference,
            'employee_id': item.employeeId,
          },
          eventAt: DateTime.now(),
          status: 'completed',
        ),
      );

      _saveToStorage();
      notifyListeners();
    }
  }

  void resetToDefault() {
    _seedDefaultItems();
    notifyListeners();
  }
}
