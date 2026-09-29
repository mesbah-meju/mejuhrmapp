import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:auth_ui_app/services/sync_controller.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

// ============================================================================
// ENUMS & MODELS
// ============================================================================

enum TargetType { itemQuantity, itemAmount, overallQuantity, overallAmount }
enum TargetPeriod { daily, weekly, monthly }
enum TargetStatus { notStarted, inProgress, achieved, overAchieved }

class SalesEntry {
  final String id;
  final String time;
  final String date;
  double amount;
  String client;
  String reference;
  String notes;

  SalesEntry({
    required this.id,
    required this.time,
    required this.date,
    required this.amount,
    this.client = '',
    this.reference = '',
    this.notes = '',
  });

  SalesEntry copyWith({
    String? id,
    String? time,
    String? date,
    double? amount,
    String? client,
    String? reference,
    String? notes,
  }) {
    return SalesEntry(
      id: id ?? this.id,
      time: time ?? this.time,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      client: client ?? this.client,
      reference: reference ?? this.reference,
      notes: notes ?? this.notes,
    );
  }
}

class SalesTarget {
  final String id;
  final String name;
  final String subtitle;
  final TargetType type;
  final String unit; // 'units', 'items', 'BDT'
  final TargetPeriod period;
  final double targetValue;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final List<SalesEntry> entries;

  SalesTarget({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.type,
    required this.unit,
    required this.period,
    required this.targetValue,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.entries,
  });

  // Dynamic Calculated Properties
  double get achieved => entries.fold(0.0, (sum, entry) => sum + entry.amount);
  double get remaining => math.max(0.0, targetValue - achieved);
  double get overAchieved => math.max(0.0, achieved - targetValue);
  double get progressPercentage => targetValue > 0 ? (achieved / targetValue) * 100 : 0.0;
  double get progressFraction => targetValue > 0 ? achieved / targetValue : 0.0;

  TargetStatus get status {
    if (achieved <= 0) return TargetStatus.notStarted;
    if (achieved < targetValue) return TargetStatus.inProgress;
    if (achieved == targetValue) return TargetStatus.achieved;
    return TargetStatus.overAchieved;
  }

  String formatValue(double val) {
    if (unit == 'BDT') {
      return 'BDT ${val >= 1000 ? _formatCurrency(val) : val.toStringAsFixed(0)}';
    }
    return val % 1 == 0 ? val.toInt().toString() : val.toStringAsFixed(1);
  }

  String formatDisplayWithUnit(double val) {
    if (unit == 'BDT') {
      return 'BDT ${_formatCurrency(val)}';
    }
    return '${val % 1 == 0 ? val.toInt() : val.toStringAsFixed(1)} $unit';
  }

  static String _formatCurrency(double val) {
    final intVal = val.toInt();
    final str = intVal.toString();
    final regex = RegExp(r'(\d+?)(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(regex, (match) => '${match[1]},');
  }
}

// History Day Group Model
class HistoryDayTarget {
  final String dateString;
  final String shortDay;
  final String shortMonth;
  final String dayNumber;
  final double targetValue;
  final double achievedValue;
  final String unit;
  final String statusText;
  final Color statusColor;
  final Color statusBg;
  final bool isOverAchieved;
  final double overAmount;
  final List<SalesEntry> entries;

  HistoryDayTarget({
    required this.dateString,
    required this.shortDay,
    required this.shortMonth,
    required this.dayNumber,
    required this.targetValue,
    required this.achievedValue,
    required this.unit,
    required this.statusText,
    required this.statusColor,
    required this.statusBg,
    this.isOverAchieved = false,
    this.overAmount = 0,
    required this.entries,
  });

  double get progressPercentage => targetValue > 0 ? (achievedValue / targetValue) * 100 : 0.0;
}

// ============================================================================
// MAIN TARGETS SCREEN WIDGET
// ============================================================================

enum TargetsViewMode { overview, detail, history, historyDetail }

class TargetsScreen extends StatefulWidget {
  final VoidCallback? onBackToDashboard;
  final bool initialShowingHistory;

  const TargetsScreen({
    super.key,
    this.onBackToDashboard,
    this.initialShowingHistory = false,
  });

  @override
  State<TargetsScreen> createState() => _TargetsScreenState();
}

class _TargetsScreenState extends State<TargetsScreen> with SingleTickerProviderStateMixin {
  TargetsViewMode _viewMode = TargetsViewMode.overview;
  String _selectedPeriodTab = 'Today'; // 'Today', 'This Week', 'This Month'
  String _historyFilterTab = 'Daily'; // 'Daily', 'Weekly', 'Monthly'
  String _selectedProductHistory = 'Product A';
  int _selectedCalendarDay = 28;

  SalesTarget? _selectedTarget;
  HistoryDayTarget? _selectedHistoryDay;

  // Controllers for sales entry form
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _clientController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  double _stepperQuantity = 5.0;

  // ============================================================================
  // SALES TARGETS DATA REPOSITORY (STATEFUL)
  // ============================================================================
  late List<SalesTarget> _targets;
  late List<HistoryDayTarget> _historyRecords;

  @override
  void initState() {
    super.initState();
    _initializeData();
    if (widget.initialShowingHistory) {
      _viewMode = TargetsViewMode.history;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _clientController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _initializeData() {
    // 1. Product A (Item Quantity Target)
    final productA = SalesTarget(
      id: 'target_prod_a',
      name: 'Product A',
      subtitle: "Today's Target: 20 units",
      type: TargetType.itemQuantity,
      unit: 'units',
      period: TargetPeriod.daily,
      targetValue: 20.0,
      icon: Icons.inventory_2_outlined,
      iconColor: const Color(0xFF2563EB),
      iconBg: const Color(0xFFEFF6FF),
      entries: [
        SalesEntry(id: 'e1', time: '10:25 AM', date: '28 Sep 2026', amount: 5, client: 'ABC Ltd', notes: 'Walk-in bulk purchase'),
        SalesEntry(id: 'e2', time: '09:10 AM', date: '28 Sep 2026', amount: 3, client: 'XYZ Corp', notes: 'Repeat customer order'),
        SalesEntry(id: 'e3', time: '08:45 AM', date: '28 Sep 2026', amount: 2, client: 'Walk-in customer', notes: 'Cash counter sale'),
        SalesEntry(id: 'e4', time: '08:20 AM', date: '28 Sep 2026', amount: 5, client: 'Retail Shop', notes: 'Distributor delivery'),
      ],
    );

    // 2. Product B (Item Quantity Target)
    final productB = SalesTarget(
      id: 'target_prod_b',
      name: 'Product B',
      subtitle: "Target: 10 units",
      type: TargetType.itemQuantity,
      unit: 'units',
      period: TargetPeriod.daily,
      targetValue: 10.0,
      icon: Icons.inventory_2_outlined,
      iconColor: const Color(0xFFEF4444),
      iconBg: const Color(0xFFFFF1F2),
      entries: [
        SalesEntry(id: 'eb1', time: '09:40 AM', date: '28 Sep 2026', amount: 3, client: 'Alpha Traders', notes: 'Wholesale order'),
        SalesEntry(id: 'eb2', time: '08:30 AM', date: '28 Sep 2026', amount: 5, client: 'Metro Store', notes: 'Direct delivery'),
      ],
    );

    // 3. Service C (Item Sales Amount Target)
    final serviceC = SalesTarget(
      id: 'target_service_c',
      name: 'Service C',
      subtitle: "Target: BDT 30,000",
      type: TargetType.itemAmount,
      unit: 'BDT',
      period: TargetPeriod.daily,
      targetValue: 30000.0,
      icon: Icons.miscellaneous_services_rounded,
      iconColor: const Color(0xFF7C3AED),
      iconBg: const Color(0xFFFAF5FF),
      entries: [
        SalesEntry(id: 'ec1', time: '09:15 AM', date: '28 Sep 2026', amount: 8000, client: 'Horizon Tech', reference: 'INV-402', notes: 'Quarterly Maintenance'),
        SalesEntry(id: 'ec2', time: '08:10 AM', date: '28 Sep 2026', amount: 10000, client: 'Blue Sky Ltd', reference: 'INV-398', notes: 'Annual Support package'),
      ],
    );

    // 4. Product D (Item Quantity Target)
    final productD = SalesTarget(
      id: 'target_prod_d',
      name: 'Product D',
      subtitle: "Target: 15 units",
      type: TargetType.itemQuantity,
      unit: 'units',
      period: TargetPeriod.daily,
      targetValue: 15.0,
      icon: Icons.layers_outlined,
      iconColor: const Color(0xFF059669),
      iconBg: const Color(0xFFECFDF5),
      entries: [
        SalesEntry(id: 'ed1', time: '10:00 AM', date: '28 Sep 2026', amount: 6, client: 'City Mart', notes: 'Retail restock'),
        SalesEntry(id: 'ed2', time: '09:05 AM', date: '28 Sep 2026', amount: 6, client: 'Prime Super', notes: 'Counter batch'),
      ],
    );

    // 5. Total Sales Amount (Overall Sales Amount Target)
    final totalSales = SalesTarget(
      id: 'target_total_amount',
      name: 'Total Sales Amount',
      subtitle: "Target: BDT 100,000",
      type: TargetType.overallAmount,
      unit: 'BDT',
      period: TargetPeriod.daily,
      targetValue: 100000.0,
      icon: Icons.insights_rounded,
      iconColor: const Color(0xFFD97706),
      iconBg: const Color(0xFFFFFBEB),
      entries: [
        SalesEntry(id: 'et1', time: '10:25 AM', date: '28 Sep 2026', amount: 25000, client: 'Combined Product A Sales'),
        SalesEntry(id: 'et2', time: '09:40 AM', date: '28 Sep 2026', amount: 12000, client: 'Combined Product B Sales'),
        SalesEntry(id: 'et3', time: '09:15 AM', date: '28 Sep 2026', amount: 18000, client: 'Service C Contract'),
        SalesEntry(id: 'et4', time: '08:20 AM', date: '28 Sep 2026', amount: 10000, client: 'Product D Dispatches'),
      ],
    );

    _targets = [productA, productB, serviceC, productD, totalSales];

    // History Records for Product A across days
    _historyRecords = [
      HistoryDayTarget(
        dateString: '28 September 2026 (Today)',
        shortDay: 'Sat',
        shortMonth: 'Sep',
        dayNumber: '28',
        targetValue: 20,
        achievedValue: 15,
        unit: 'units',
        statusText: 'In Progress',
        statusColor: const Color(0xFF2563EB),
        statusBg: const Color(0xFFEFF6FF),
        entries: productA.entries,
      ),
      HistoryDayTarget(
        dateString: '27 September 2026',
        shortDay: 'Fri',
        shortMonth: 'Sep',
        dayNumber: '27',
        targetValue: 20,
        achievedValue: 22,
        unit: 'units',
        statusText: 'Over Achieved',
        statusColor: const Color(0xFF059669),
        statusBg: const Color(0xFFDCFCE7),
        isOverAchieved: true,
        overAmount: 2,
        entries: [
          SalesEntry(id: 'h27_1', time: '04:30 PM', date: '27 Sep 2026', amount: 8, client: 'Global Impex'),
          SalesEntry(id: 'h27_2', time: '02:15 PM', date: '27 Sep 2026', amount: 6, client: 'Eastern Corp'),
          SalesEntry(id: 'h27_3', time: '11:00 AM', date: '27 Sep 2026', amount: 8, client: 'Retail Depot'),
        ],
      ),
      HistoryDayTarget(
        dateString: '26 September 2026',
        shortDay: 'Thu',
        shortMonth: 'Sep',
        dayNumber: '26',
        targetValue: 20,
        achievedValue: 18,
        unit: 'units',
        statusText: 'In Progress',
        statusColor: const Color(0xFF2563EB),
        statusBg: const Color(0xFFEFF6FF),
        entries: [
          SalesEntry(id: 'h26_1', time: '05:00 PM', date: '26 Sep 2026', amount: 10, client: 'Tech Solutions'),
          SalesEntry(id: 'h26_2', time: '11:30 AM', date: '26 Sep 2026', amount: 8, client: 'Metro Hub'),
        ],
      ),
      HistoryDayTarget(
        dateString: '25 September 2026',
        shortDay: 'Wed',
        shortMonth: 'Sep',
        dayNumber: '25',
        targetValue: 20,
        achievedValue: 12,
        unit: 'units',
        statusText: 'In Progress',
        statusColor: const Color(0xFF2563EB),
        statusBg: const Color(0xFFEFF6FF),
        entries: [
          SalesEntry(id: 'h25_1', time: '03:15 PM', date: '25 Sep 2026', amount: 7, client: 'Urban Stores'),
          SalesEntry(id: 'h25_2', time: '10:00 AM', date: '25 Sep 2026', amount: 5, client: 'Alpha Express'),
        ],
      ),
      HistoryDayTarget(
        dateString: '24 September 2026',
        shortDay: 'Tue',
        shortMonth: 'Sep',
        dayNumber: '24',
        targetValue: 20,
        achievedValue: 20,
        unit: 'units',
        statusText: 'Achieved',
        statusColor: const Color(0xFF059669),
        statusBg: const Color(0xFFDCFCE7),
        entries: [
          SalesEntry(id: 'h24_1', time: '04:45 PM', date: '24 Sep 2026', amount: 10, client: 'Prime Wholesale'),
          SalesEntry(id: 'h24_2', time: '01:20 PM', date: '24 Sep 2026', amount: 10, client: 'Apex Trade'),
        ],
      ),
      HistoryDayTarget(
        dateString: '23 September 2026',
        shortDay: 'Mon',
        shortMonth: 'Sep',
        dayNumber: '23',
        targetValue: 20,
        achievedValue: 8,
        unit: 'units',
        statusText: 'Incomplete',
        statusColor: const Color(0xFFDC2626),
        statusBg: const Color(0xFFFEE2E2),
        entries: [
          SalesEntry(id: 'h23_1', time: '02:00 PM', date: '23 Sep 2026', amount: 8, client: 'Delta Trading'),
        ],
      ),
      HistoryDayTarget(
        dateString: '22 September 2026',
        shortDay: 'Sun',
        shortMonth: 'Sep',
        dayNumber: '22',
        targetValue: 20,
        achievedValue: 16,
        unit: 'units',
        statusText: 'In Progress',
        statusColor: const Color(0xFF2563EB),
        statusBg: const Color(0xFFEFF6FF),
        entries: [
          SalesEntry(id: 'h22_1', time: '04:00 PM', date: '22 Sep 2026', amount: 16, client: 'Beacon Enterprises'),
        ],
      ),
    ];
  }

  // ============================================================================
  // OVERALL AGGREGATION CALCULATOR
  // ============================================================================
  double get _overallTargetAmount => 100000.0;
  double get _overallAchievedAmount {
    // Look at Total Sales Amount target
    final totalTarget = _targets.firstWhere(
      (t) => t.id == 'target_total_amount',
      orElse: () => _targets.first,
    );
    return totalTarget.achieved;
  }
  double get _overallProgressFraction => _overallTargetAmount > 0 ? _overallAchievedAmount / _overallTargetAmount : 0.0;
  double get _overallRemainingAmount => math.max(0.0, _overallTargetAmount - _overallAchievedAmount);
  double get _overallOverAchievedAmount => math.max(0.0, _overallAchievedAmount - _overallTargetAmount);

  // ============================================================================
  // ENTRY SUBMISSION & REALTIME RECALCULATION
  // ============================================================================
  void _handleAddSalesEntry(SalesTarget target) {
    double amountToAdd = 0;

    if (target.unit == 'BDT') {
      final parsed = double.tryParse(_amountController.text.replaceAll(',', '').trim());
      if (parsed == null || parsed <= 0) {
        THelperFunctions.showSnackBar("Please enter a valid sales amount.");
        return;
      }
      amountToAdd = parsed;
    } else {
      if (_stepperQuantity <= 0) {
        THelperFunctions.showSnackBar("Please select a quantity greater than 0.");
        return;
      }
      amountToAdd = _stepperQuantity;
    }

    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final period = now.hour >= 12 ? 'PM' : 'AM';
    final minute = now.minute.toString().padLeft(2, '0');
    final timeStr = '${hour.toString().padLeft(2, '0')}:$minute $period';

    final newEntry = SalesEntry(
      id: 'entry_${DateTime.now().millisecondsSinceEpoch}',
      time: timeStr,
      date: '28 Sep 2026',
      amount: amountToAdd,
      client: _clientController.text.trim().isEmpty ? 'Direct Sale' : _clientController.text.trim(),
      notes: _notesController.text.trim(),
    );

    setState(() {
      target.entries.insert(0, newEntry);

      // Also propagate to Total Sales Amount target if applicable
      if (target.id != 'target_total_amount') {
        final totalTarget = _targets.firstWhere((t) => t.id == 'target_total_amount');
        double moneyContrib = target.unit == 'BDT' ? amountToAdd : (amountToAdd * 1500); // 1 unit approx BDT 1500
        totalTarget.entries.insert(
          0,
          SalesEntry(
            id: 'auto_tot_${DateTime.now().millisecondsSinceEpoch}',
            time: timeStr,
            date: '28 Sep 2026',
            amount: moneyContrib,
            client: '${target.name} (${newEntry.client})',
          ),
        );
      }

      // Reset form
      _amountController.clear();
      _clientController.clear();
      _notesController.clear();
      _stepperQuantity = 5.0;
    });

    final isOver = target.achieved > target.targetValue;
    final isExact = target.achieved == target.targetValue;

    String successMsg = "Added ${target.formatDisplayWithUnit(amountToAdd)} to ${target.name}!";
    if (isOver) {
      successMsg += " 🎉 Target Over-Achieved (${target.progressPercentage.toStringAsFixed(0)}%)!";
    } else if (isExact) {
      successMsg += " 🎯 100% Target Reached!";
    }

    SyncController.instance.enqueueAction(
      actionType: 'target_entry_add',
      payload: {
        'target_id': target.id,
        'target_name': target.name,
        'amount': amountToAdd,
        'entry_id': newEntry.id,
        'date': newEntry.date,
        'time': newEntry.time,
        'client': newEntry.client,
        'notes': newEntry.notes,
      },
      userMessage: successMsg,
    );
  }

  void _handleDeleteEntry(SalesTarget target, SalesEntry entry) {
    Get.defaultDialog(
      title: "Delete Entry",
      middleText: "Remove entry of ${target.formatDisplayWithUnit(entry.amount)} for ${entry.client.isEmpty ? 'Sale' : entry.client}?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFEF4444),
      onConfirm: () {
        setState(() {
          target.entries.removeWhere((e) => e.id == entry.id);
        });
        Get.back();
        THelperFunctions.showSnackBar("Entry removed and targets recalculated.");
      },
    );
  }

  void _handleEditEntry(SalesTarget target, SalesEntry entry) {
    final editAmountCtrl = TextEditingController(text: entry.amount % 1 == 0 ? entry.amount.toInt().toString() : entry.amount.toString());
    final editClientCtrl = TextEditingController(text: entry.client);
    final editNotesCtrl = TextEditingController(text: entry.notes);

    Get.defaultDialog(
      title: "Edit Sales Entry",
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          children: [
            TextField(
              controller: editAmountCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: target.unit == 'BDT' ? "Amount (BDT)" : "Quantity (${target.unit})",
                prefixText: target.unit == 'BDT' ? "BDT " : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: editClientCtrl,
              decoration: InputDecoration(
                labelText: "Client / Customer",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: editNotesCtrl,
              decoration: InputDecoration(
                labelText: "Notes",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
      textConfirm: "Save Changes",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF2563EB),
      onConfirm: () {
        final newAmt = double.tryParse(editAmountCtrl.text.trim());
        if (newAmt != null && newAmt > 0) {
          setState(() {
            entry.amount = newAmt;
            entry.client = editClientCtrl.text.trim();
            entry.notes = editNotesCtrl.text.trim();
          });
          Get.back();
          THelperFunctions.showSnackBar("Entry updated successfully.");
        }
      },
    );
  }

  // Quick Add Sales Dialog from Overview Screen
  void _showQuickAddSalesModal() {
    SalesTarget selected = _targets.first;
    double quickQty = 1;
    final quickAmtCtrl = TextEditingController(text: "1000");
    final quickClientCtrl = TextEditingController();

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Quick Sales Entry",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                      ),
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text("Select Target / Product", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<SalesTarget>(
                        value: selected,
                        isExpanded: true,
                        items: _targets.map((t) {
                          return DropdownMenuItem(
                            value: t,
                            child: Row(
                              children: [
                                Icon(t.icon, size: 18, color: t.iconColor),
                                const SizedBox(width: 8),
                                Text(t.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (newT) {
                          if (newT != null) {
                            setModalState(() => selected = newT);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (selected.unit == 'BDT') ...[
                    const Text("Sales Amount (BDT)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                    const SizedBox(height: 6),
                    TextField(
                      controller: quickAmtCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        prefixText: "BDT ",
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                      ),
                    ),
                  ] else ...[
                    Text("Quantity (${selected.unit})", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (quickQty > 1) setModalState(() => quickQty -= 1);
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.remove_rounded, color: Color(0xFF0F172A)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFBFDBFE)),
                          ),
                          child: Text(
                            quickQty.toInt().toString(),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF2563EB)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        InkWell(
                          onTap: () => setModalState(() => quickQty += 1),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.add_rounded, color: Color(0xFF0F172A)),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  const Text("Client / Customer (Optional)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                  const SizedBox(height: 6),
                  TextField(
                    controller: quickClientCtrl,
                    decoration: InputDecoration(
                      hintText: "e.g. Acme Corp, Retail customer",
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        final amt = selected.unit == 'BDT'
                            ? (double.tryParse(quickAmtCtrl.text.trim()) ?? 0)
                            : quickQty;

                        if (amt <= 0) {
                          THelperFunctions.showSnackBar("Please enter a valid amount.");
                          return;
                        }

                        final now = DateTime.now();
                        final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
                        final period = now.hour >= 12 ? 'PM' : 'AM';
                        final minute = now.minute.toString().padLeft(2, '0');
                        final timeStr = '${hour.toString().padLeft(2, '0')}:$minute $period';

                        final entry = SalesEntry(
                          id: 'entry_${DateTime.now().millisecondsSinceEpoch}',
                          time: timeStr,
                          date: '28 Sep 2026',
                          amount: amt,
                          client: quickClientCtrl.text.trim().isEmpty ? 'Walk-in Sale' : quickClientCtrl.text.trim(),
                        );

                        setState(() {
                          selected.entries.insert(0, entry);
                          if (selected.id != 'target_total_amount') {
                            final totalTarget = _targets.firstWhere((t) => t.id == 'target_total_amount');
                            double moneyVal = selected.unit == 'BDT' ? amt : (amt * 1500);
                            totalTarget.entries.insert(
                              0,
                              SalesEntry(
                                id: 'auto_${DateTime.now().millisecondsSinceEpoch}',
                                time: timeStr,
                                date: '28 Sep 2026',
                                amount: moneyVal,
                                client: '${selected.name} (${entry.client})',
                              ),
                            );
                          }
                        });

                        Get.back();
                        THelperFunctions.showSnackBar("Added ${selected.formatDisplayWithUnit(amt)} to ${selected.name}!");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_rounded, size: 20),
                          SizedBox(width: 8),
                          Text("Add Sales Record", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  // ============================================================================
  // BUILD METHOD (ROUTER)
  // ============================================================================
  @override
  Widget build(BuildContext context) {
    switch (_viewMode) {
      case TargetsViewMode.detail:
        return _buildTargetDetailPage(_selectedTarget ?? _targets.first);
      case TargetsViewMode.history:
        return _buildPreviousTargetsPage();
      case TargetsViewMode.historyDetail:
        return _buildHistoryDayDetailPage(_selectedHistoryDay ?? _historyRecords.first);
      case TargetsViewMode.overview:
        return _buildTargetsOverviewPage();
    }
  }

  // ============================================================================
  // SCREEN 1: TARGETS OVERVIEW PAGE (LEFT SCREEN MOCKUP)
  // ============================================================================
  Widget _buildTargetsOverviewPage() {
    final recentEntries = <Map<String, dynamic>>[];
    for (final target in _targets) {
      for (final entry in target.entries) {
        recentEntries.add({
          'target': target,
          'entry': entry,
        });
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.menu_rounded, size: 28, color: Color(0xFF1E293B)),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 14),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Targets",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.3,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Your sales targets for today",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // History Pill Button
                  InkWell(
                    onTap: () => setState(() => _viewMode = TargetsViewMode.history),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.history_rounded, size: 16, color: Color(0xFF1E293B)),
                          SizedBox(width: 5),
                          Text(
                            "History",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Period Tabs (Today | This Week | This Month)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0).withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    _buildPeriodTab("Today"),
                    _buildPeriodTab("This Week"),
                    _buildPeriodTab("This Month"),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Overall Progress Hero Card
              _buildOverallProgressHeroCard(),
              const SizedBox(height: 18),

              // Section 2: Targets by Item
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Targets by Item",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  InkWell(
                    onTap: _showQuickAddSalesModal,
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2563EB).withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add_rounded, size: 15, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            "Add Sales",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Targets by Item List
              ..._targets.map((target) => _buildTargetItemCard(target)),
              const SizedBox(height: 18),

              // Section 3: Recent Entries
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent Entries",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedTarget = _targets.first;
                        _viewMode = TargetsViewMode.detail;
                      });
                    },
                    child: const Text(
                      "View All",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Recent Entries List
              ...recentEntries.take(4).map((item) {
                final target = item['target'] as SalesTarget;
                final entry = item['entry'] as SalesEntry;
                return _buildRecentEntryRow(target, entry);
              }),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodTab(String label) {
    final isSelected = _selectedPeriodTab == label;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPeriodTab = label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // OVERALL PROGRESS HERO CARD
  // ============================================================================
  Widget _buildOverallProgressHeroCard() {
    final isOverAchieved = _overallAchievedAmount > _overallTargetAmount;
    final pct = (_overallAchievedAmount / _overallTargetAmount) * 100;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left: Radial Gauge Ring (65% BDT 65,000 of 100,000)
          SizedBox(
            width: 125,
            height: 125,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(125, 125),
                  painter: _RadialTargetGaugePainter(
                    progress: _overallProgressFraction,
                    gaugeColor: isOverAchieved ? const Color(0xFF059669) : const Color(0xFF059669),
                    trackColor: const Color(0xFFE2E8F0),
                    strokeWidth: 11,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${pct.toInt()}%",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      "BDT ${(_overallAchievedAmount.toInt()).toString()}",
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const Text(
                      "of 100,000",
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),

          // Right: Target, Achieved, Remaining Tiles
          Expanded(
            child: Column(
              children: [
                // 1. Target
                _buildHeroMetricRow(
                  icon: Icons.track_changes_rounded,
                  iconColor: const Color(0xFF059669),
                  iconBg: const Color(0xFFDCFCE7),
                  title: "BDT ${SalesTarget._formatCurrency(_overallTargetAmount)}",
                  subtitle: "Today's Target",
                ),
                const SizedBox(height: 10),

                // 2. Achieved
                _buildHeroMetricRow(
                  icon: Icons.bar_chart_rounded,
                  iconColor: const Color(0xFF2563EB),
                  iconBg: const Color(0xFFEFF6FF),
                  title: "BDT ${SalesTarget._formatCurrency(_overallAchievedAmount)}",
                  subtitle: "Achieved",
                ),
                const SizedBox(height: 10),

                // 3. Remaining / Over Achieved
                if (isOverAchieved)
                  _buildHeroMetricRow(
                    icon: Icons.arrow_upward_rounded,
                    iconColor: const Color(0xFF059669),
                    iconBg: const Color(0xFFDCFCE7),
                    title: "+ BDT ${SalesTarget._formatCurrency(_overallOverAchievedAmount)}",
                    subtitle: "Over Achieved 🎉",
                  )
                else
                  _buildHeroMetricRow(
                    icon: Icons.access_time_filled_rounded,
                    iconColor: const Color(0xFF7C3AED),
                    iconBg: const Color(0xFFFAF5FF),
                    title: "BDT ${SalesTarget._formatCurrency(_overallRemainingAmount)}",
                    subtitle: "Remaining",
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroMetricRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // TARGET ITEM CARD (IN OVERVIEW)
  // ============================================================================
  Widget _buildTargetItemCard(SalesTarget target) {
    final progress = target.progressFraction;
    final pct = target.progressPercentage;
    final isOver = target.status == TargetStatus.overAchieved;
    final isAchieved = target.status == TargetStatus.achieved;

    Color barColor = const Color(0xFF2563EB);
    if (isOver || isAchieved) {
      barColor = const Color(0xFF059669);
    } else if (pct < 50) {
      barColor = const Color(0xFF3B82F6);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedTarget = target;
              _stepperQuantity = 5.0;
              _viewMode = TargetsViewMode.detail;
            });
          },
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Product Icon Box
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: target.iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(target.icon, color: target.iconColor, size: 20),
                ),
                const SizedBox(width: 12),

                // Main Details & Progress Bar
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            target.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                target.unit == 'BDT'
                                    ? 'BDT ${SalesTarget._formatCurrency(target.achieved)} / ${SalesTarget._formatCurrency(target.targetValue)}'
                                    : '${target.formatValue(target.achieved)} / ${target.formatValue(target.targetValue)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              if (isOver) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_upward_rounded, size: 12, color: Color(0xFF059669)),
                              ],
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            target.subtitle,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          Text(
                            "${pct.toInt()}%",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: isOver || isAchieved ? const Color(0xFF059669) : const Color(0xFF2563EB),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: math.min(1.0, progress),
                          backgroundColor: const Color(0xFFF1F5F9),
                          valueColor: AlwaysStoppedAnimation<Color>(barColor),
                          minHeight: 5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8), size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // RECENT ENTRY ROW
  // ============================================================================
  Widget _buildRecentEntryRow(SalesTarget target, SalesEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: target.iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(target.icon, size: 14, color: target.iconColor),
          ),
          const SizedBox(width: 10),

          // Time
          Text(
            entry.time,
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 14),

          // Product Name
          Expanded(
            child: Text(
              target.name,
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Amount
          Text(
            target.formatDisplayWithUnit(entry.amount),
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF94A3B8)),
        ],
      ),
    );
  }

  // ============================================================================
  // SCREEN 2: TARGET DETAIL / SALES ENTRY PAGE (MIDDLE SCREEN MOCKUP)
  // ============================================================================
  Widget _buildTargetDetailPage(SalesTarget target) {
    final pct = target.progressPercentage;
    final isOver = target.status == TargetStatus.overAchieved;
    final isAchieved = target.status == TargetStatus.achieved;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    onPressed: () => setState(() => _viewMode = TargetsViewMode.overview),
                    icon: const Icon(Icons.chevron_left_rounded, size: 30, color: Color(0xFF0F172A)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${target.name} Target",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          "Track your sales for ${target.name}",
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Top Summary Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: target.iconBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(target.icon, color: target.iconColor, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                target.name,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                              ),
                              Text(
                                target.subtitle,
                                style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isOver || isAchieved ? const Color(0xFFDCFCE7) : const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${pct.toInt()}%",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: isOver || isAchieved ? const Color(0xFF059669) : const Color(0xFF2563EB),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 3-Stat Row (Achieved, Remaining / Over, Target)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildDetailStatColumn(
                          target.formatValue(target.achieved),
                          "Achieved",
                          const Color(0xFF0F172A),
                        ),
                        Container(width: 1, height: 28, color: const Color(0xFFE2E8F0)),
                        if (isOver)
                          _buildDetailStatColumn(
                            "+ ${target.formatValue(target.overAchieved)}",
                            "Over Achieved",
                            const Color(0xFF059669),
                          )
                        else
                          _buildDetailStatColumn(
                            target.formatValue(target.remaining),
                            "Remaining",
                            target.remaining > 0 ? const Color(0xFFEF4444) : const Color(0xFF059669),
                          ),
                        Container(width: 1, height: 28, color: const Color(0xFFE2E8F0)),
                        _buildDetailStatColumn(
                          target.formatValue(target.targetValue),
                          "Target",
                          const Color(0xFF0F172A),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: math.min(1.0, target.progressFraction),
                        backgroundColor: const Color(0xFFF1F5F9),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isOver || isAchieved ? const Color(0xFF059669) : const Color(0xFF2563EB),
                        ),
                        minHeight: 7,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Add Sales Entry Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Add Sales Entry",
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              target.unit == 'BDT' ? "Enter the sales amount" : "Enter the sales quantity for ${target.name}",
                              style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.calendar_today_rounded, size: 12, color: Color(0xFF2563EB)),
                              SizedBox(width: 4),
                              Text(
                                "28 Sep 2026",
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Stepper / Input Field based on Target Type
                    if (target.unit == 'BDT') ...[
                      const Text(
                        "Sales Amount (BDT)",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          prefixText: "BDT ",
                          prefixStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          hintText: "e.g. 5,000",
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                        ),
                      ),
                    ] else ...[
                      Text(
                        "Quantity (${target.unit})",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 48,
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: const Color(0xFFBFDBFE)),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _stepperQuantity.toInt().toString(),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              if (_stepperQuantity > 1) {
                                setState(() => _stepperQuantity -= 1);
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: const Icon(Icons.remove_rounded, color: Color(0xFF0F172A)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => setState(() => _stepperQuantity += 1),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: const Icon(Icons.add_rounded, color: Color(0xFF0F172A)),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 12),

                    // Client & Notes Field
                    const Text(
                      "Client / Customer (Optional)",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _clientController,
                      decoration: InputDecoration(
                        hintText: "e.g. ABC Ltd, Walk-in customer",
                        hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Notes (Optional)",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569)),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        hintText: "e.g. Reference, invoice number, payment mode",
                        hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Add Entry Primary Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => _handleAddSalesEntry(target),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_rounded, size: 18),
                            SizedBox(width: 8),
                            Text(
                              "Add Entry",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Today's Entries Section
              const Text(
                "Today's Entries",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 10),

              if (target.entries.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Center(
                    child: Text(
                      "No sales entries logged today yet.\nAdd your first sale above!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                    ),
                  ),
                )
              else
                ...target.entries.map((entry) => _buildDetailEntryCard(target, entry)),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailStatColumn(String value, String label, Color valueColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: valueColor),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildDetailEntryCard(SalesTarget target, SalesEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          // Icon Box
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: target.iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(target.icon, size: 16, color: target.iconColor),
          ),
          const SizedBox(width: 10),

          // Time
          Text(
            entry.time,
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 14),

          // Amount & Client Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  target.formatDisplayWithUnit(entry.amount),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                ),
                if (entry.client.isNotEmpty)
                  Text(
                    "Client: ${entry.client}",
                    style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),

          // Action Buttons (Edit & Delete)
          IconButton(
            onPressed: () => _handleEditEntry(target, entry),
            icon: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF2563EB)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () => _handleDeleteEntry(target, entry),
            icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFEF4444)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // SCREEN 3: PREVIOUS TARGETS / HISTORY PAGE (RIGHT SCREEN MOCKUP)
  // ============================================================================
  Widget _buildPreviousTargetsPage() {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header with Filter Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => setState(() => _viewMode = TargetsViewMode.overview),
                        icon: const Icon(Icons.chevron_left_rounded, size: 30, color: Color(0xFF0F172A)),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Previous Targets",
                            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                          ),
                          Text(
                            "View your past target performance",
                            style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.filter_list_rounded, size: 15, color: Color(0xFF2563EB)),
                        SizedBox(width: 4),
                        Text(
                          "Filter",
                          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Filter Row: [Daily | Weekly | Monthly] + [Product A v]
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0).withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          _buildHistoryTabItem("Daily"),
                          _buildHistoryTabItem("Weekly"),
                          _buildHistoryTabItem("Monthly"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedProductHistory,
                          isDense: true,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Color(0xFF64748B)),
                          items: const [
                            DropdownMenuItem(value: "Product A", child: Text("Product A", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold))),
                            DropdownMenuItem(value: "Product B", child: Text("Product B", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold))),
                            DropdownMenuItem(value: "Service C", child: Text("Service C", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold))),
                            DropdownMenuItem(value: "Total Sales", child: Text("Total Sales", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold))),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedProductHistory = val);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Calendar Month Strip
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.chevron_left_rounded, size: 20, color: Color(0xFF64748B)),
                        Text(
                          "September 2026",
                          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                        ),
                        Icon(Icons.chevron_right_rounded, size: 20, color: Color(0xFF64748B)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildCalendarDayPill("Sun", 22, const Color(0xFFD97706), isSelected: _selectedCalendarDay == 22),
                        _buildCalendarDayPill("Mon", 23, const Color(0xFFEF4444), isSelected: _selectedCalendarDay == 23),
                        _buildCalendarDayPill("Tue", 24, const Color(0xFF059669), isSelected: _selectedCalendarDay == 24),
                        _buildCalendarDayPill("Wed", 25, const Color(0xFF2563EB), isSelected: _selectedCalendarDay == 25),
                        _buildCalendarDayPill("Thu", 26, const Color(0xFFEF4444), isSelected: _selectedCalendarDay == 26),
                        _buildCalendarDayPill("Fri", 27, const Color(0xFF059669), isSelected: _selectedCalendarDay == 27),
                        _buildCalendarDayPill("Sat", 28, const Color(0xFF059669), isSelected: _selectedCalendarDay == 28),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Selected Target Hero Box (Product A)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.inventory_2_outlined, color: Color(0xFF2563EB), size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Product A",
                                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                              ),
                              Text(
                                "15 / 20",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text("Target: 20 units", style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
                              Text("75%", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: const LinearProgressIndicator(
                              value: 0.75,
                              backgroundColor: Color(0xFFF1F5F9),
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF059669)),
                              minHeight: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Historical Records List
              ..._historyRecords.map((rec) => _buildHistoryDateRecordCard(rec)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryTabItem(String label) {
    final isSelected = _historyFilterTab == label;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _historyFilterTab = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarDayPill(String day, int dateNum, Color dotColor, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () => setState(() => _selectedCalendarDay = dateNum),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dateNum.toString(),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: isSelected ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : dotColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryDateRecordCard(HistoryDayTarget rec) {
    final isOver = rec.isOverAchieved;
    final pct = rec.progressPercentage;

    Color barColor = const Color(0xFF2563EB);
    if (isOver || pct >= 100) {
      barColor = const Color(0xFF059669);
    } else if (pct < 50) {
      barColor = const Color(0xFFEF4444);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedHistoryDay = rec;
            _viewMode = TargetsViewMode.historyDetail;
          });
        },
        child: Row(
          children: [
            // Left Date Box (28 Sep)
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    rec.dayNumber,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF2563EB)),
                  ),
                  Text(
                    rec.shortMonth,
                    style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        rec.dateString,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                      ),
                      Text(
                        "${rec.achievedValue.toInt()} / ${rec.targetValue.toInt()}",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (isOver)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.arrow_upward_rounded, size: 10, color: Color(0xFF059669)),
                              SizedBox(width: 2),
                              Text(
                                "Over Achieved",
                                style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                              ),
                            ],
                          ),
                        )
                      else
                        const SizedBox(),
                      Text(
                        "${pct.toInt()}%",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: isOver || pct >= 100 ? const Color(0xFF059669) : const Color(0xFF2563EB),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: math.min(1.0, rec.achievedValue / rec.targetValue),
                      backgroundColor: const Color(0xFFF1F5F9),
                      valueColor: AlwaysStoppedAnimation<Color>(barColor),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // SCREEN 4: HISTORICAL DAY DETAIL DRILLDOWN
  // ============================================================================
  Widget _buildHistoryDayDetailPage(HistoryDayTarget rec) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => setState(() => _viewMode = TargetsViewMode.history),
                    icon: const Icon(Icons.chevron_left_rounded, size: 30, color: Color(0xFF0F172A)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rec.dateString,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                        ),
                        const Text(
                          "Historical sales logs & breakdown",
                          style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Summary Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Performance: ${rec.statusText}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: rec.statusBg, borderRadius: BorderRadius.circular(8)),
                          child: Text("${rec.progressPercentage.toInt()}%", style: TextStyle(fontWeight: FontWeight.bold, color: rec.statusColor)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildDetailStatColumn("${rec.achievedValue.toInt()} ${rec.unit}", "Achieved", const Color(0xFF0F172A)),
                        _buildDetailStatColumn("${rec.targetValue.toInt()} ${rec.unit}", "Target", const Color(0xFF0F172A)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              const Text("Sales Entries on This Date", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              const SizedBox(height: 10),

              ...rec.entries.map((entry) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF059669), size: 18),
                      const SizedBox(width: 10),
                      Text(entry.time, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.client.isEmpty ? "Direct Customer" : entry.client,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                        ),
                      ),
                      Text(
                        "${entry.amount.toInt()} ${rec.unit}",
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF2563EB)),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// CUSTOM RADIAL TARGET GAUGE PAINTER (CIRCULAR PROGRESS WITH GLOW)
// ============================================================================
class _RadialTargetGaugePainter extends CustomPainter {
  final double progress;
  final Color gaugeColor;
  final Color trackColor;
  final double strokeWidth;

  const _RadialTargetGaugePainter({
    required this.progress,
    required this.gaugeColor,
    required this.trackColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background track ring
    final bgPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, bgPaint);

    // Dynamic progress arc with gradient
    final gradient = SweepGradient(
      startAngle: 0.0,
      endAngle: 2 * math.pi,
      colors: const [
        Color(0xFF10B981),
        Color(0xFF059669),
        Color(0xFF047857),
      ],
    );

    final progressPaint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * math.min(1.0, progress);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RadialTargetGaugePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.gaugeColor != gaugeColor ||
        oldDelegate.trackColor != trackColor;
  }
}
