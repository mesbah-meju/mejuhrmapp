import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:auth_ui_app/services/payroll_service.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class ManagerPayrollScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const ManagerPayrollScreen({super.key, this.onBack});

  @override
  State<ManagerPayrollScreen> createState() => _ManagerPayrollScreenState();
}

class _ManagerPayrollScreenState extends State<ManagerPayrollScreen> {
  final PayrollService _payrollService = PayrollService.instance;
  String _selectedFilter = 'Pending'; // 'Pending', 'Disbursed', 'All'
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _payrollService.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _payrollService.removeListener(_onServiceUpdate);
    _searchController.dispose();
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = _payrollService.pendingItems.length;
    final totalPending = _payrollService.totalPending;
    final totalDisbursed = _payrollService.totalDisbursed;
    final totalBudget = _payrollService.totalBudget;

    List<PayrollItem> displayList;
    if (_selectedFilter == 'Pending') {
      displayList = _payrollService.pendingItems;
    } else if (_selectedFilter == 'Disbursed') {
      displayList = _payrollService.disbursedItems;
    } else {
      displayList = _payrollService.items;
    }

    if (_searchQuery.isNotEmpty) {
      displayList = displayList
          .where((item) =>
              item.employeeName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              item.employeeId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              item.designation.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    final currencyFormat = NumberFormat.currency(symbol: 'BDT ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
                onPressed: widget.onBack,
              )
            : null,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Payroll & Salary Disbursements",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            Text(
              "Pending Salary Payable & Calculation Engine",
              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.refresh, color: Color(0xFF2563EB), size: 20),
            tooltip: "Reset Payroll Ledger",
            onPressed: () {
              _payrollService.resetToDefault();
              THelperFunctions.showSnackBar("Payroll ledger reset to baseline reference data.");
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // KPI Summary Header Banner
            _buildKpiSummary(
              totalPending: totalPending,
              totalDisbursed: totalDisbursed,
              totalBudget: totalBudget,
              pendingCount: pendingCount,
              format: currencyFormat,
            ),

            // Tab Filters and Search Bar
            _buildFilterAndSearchBar(pendingCount),

            // List of Payroll Items
            Expanded(
              child: displayList.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: displayList.length,
                      itemBuilder: (context, index) {
                        final item = displayList[index];
                        return _buildPayrollCard(item, currencyFormat);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 1. KPI OVERVIEW SUMMARY BANNER
  // ==========================================
  Widget _buildKpiSummary({
    required double totalPending,
    required double totalDisbursed,
    required double totalBudget,
    required int pendingCount,
    required NumberFormat format,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        children: [
          // Primary Highlight Card: Pending Salary Disbursements
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Iconsax.wallet_money, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "PENDING SALARY DISBURSEMENTS",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF93C5FD),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "$pendingCount Payees",
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        format.format(totalPending),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Secondary Cards: Total Budget & Disbursed
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Disbursed Ledger", style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                      const SizedBox(height: 4),
                      Text(
                        format.format(totalDisbursed),
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Total Monthly Allocation", style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                      const SizedBox(height: 4),
                      Text(
                        format.format(totalBudget),
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 2. FILTER & SEARCH BAR
  // ==========================================
  Widget _buildFilterAndSearchBar(int pendingCount) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        children: [
          // Filter Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Pending', 'Pending Disbursements ($pendingCount)'),
                const SizedBox(width: 8),
                _buildFilterChip('Disbursed', 'Disbursed Payroll'),
                const SizedBox(width: 8),
                _buildFilterChip('All', 'All Personnel'),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Search Field
          TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: "Search employee name, ID or designation...",
              hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
              prefixIcon: const Icon(Iconsax.search_normal, size: 18, color: Color(0xFF64748B)),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF2563EB)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedFilter == value;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.white : const Color(0xFF475569),
        ),
      ),
      selected: isSelected,
      selectedColor: const Color(0xFF2563EB),
      backgroundColor: const Color(0xFFF1F5F9),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (selected) {
        if (selected) setState(() => _selectedFilter = value);
      },
    );
  }

  // ==========================================
  // 3. EMPLOYEE PAYROLL CARD
  // ==========================================
  Widget _buildPayrollCard(PayrollItem item, NumberFormat format) {
    final isDisbursed = item.paymentStatus == 'Disbursed';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDisbursed ? const Color(0xFFBBF7D0) : const Color(0xFFE2E8F0),
          width: isDisbursed ? 1.5 : 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header: Employee Info & Status
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: isDisbursed ? const Color(0xFFDCFCE7) : const Color(0xFFDBEAFE),
                  child: Text(
                    _getInitials(item.employeeName),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDisbursed ? const Color(0xFF15803D) : const Color(0xFF1D4ED8),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.employeeName,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isDisbursed ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isDisbursed ? "Disbursement Completed" : "Pending Disbursement",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isDisbursed ? const Color(0xFF15803D) : const Color(0xFFB45309),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${item.designation} • ID: ${item.employeeId}",
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Iconsax.bank, size: 12, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 4),
                          Text(
                            "${item.bankName} (${item.accountNumber})",
                            style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // Calculation Breakdown Section
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFFFAFAFA),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Attendance: ${item.daysPresent}/${item.totalWorkDays} Days (${item.overtimeHours.toStringAsFixed(0)}h Overtime)",
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
                    ),
                    Text(
                      "Base Contract: BDT ${item.baseSalary.toStringAsFixed(0)}",
                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      _buildCalcRow("Earned Base Salary", format.format(item.earnedBaseSalary)),
                      if (item.overtimePay > 0) _buildCalcRow("Overtime Premium (${item.overtimeHours.toStringAsFixed(0)}h)", "+${format.format(item.overtimePay)}", color: const Color(0xFF059669)),
                      if (item.commissionBonus > 0) _buildCalcRow("Performance Incentive", "+${format.format(item.commissionBonus)}", color: const Color(0xFF059669)),
                      if (item.allowances > 0) _buildCalcRow("Allowances (Food/Transport)", "+${format.format(item.allowances)}", color: const Color(0xFF059669)),
                      if (item.deductions > 0) _buildCalcRow("Statutory & Policy Deductions", "-${format.format(item.deductions)}", color: const Color(0xFFDC2626)),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Divider(height: 1, color: Color(0xFFE2E8F0)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Net Payable Amount",
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                          Text(
                            format.format(item.netPayable),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF2563EB)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons: Disburse & Adjust
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _openCalculationModal(item),
                    icon: const Icon(Iconsax.calculator, size: 16),
                    label: const Text("Adjust Breakdown", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      foregroundColor: const Color(0xFF475569),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: ElevatedButton.icon(
                    onPressed: isDisbursed ? () => _showDisbursedDetails(item, format) : () => _openDisbursementModal(item, format),
                    icon: Icon(isDisbursed ? Iconsax.tick_circle : Iconsax.send_2, size: 16),
                    label: Text(
                      isDisbursed ? "Payment Record" : "Authorize Disbursement",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      backgroundColor: isDisbursed ? const Color(0xFF059669) : const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalcRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color ?? const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 4. PAYROLL CALCULATOR BOTTOM SHEET
  // ==========================================
  void _openCalculationModal(PayrollItem item) {
    double daysPresent = item.daysPresent.toDouble();
    double overtimeHours = item.overtimeHours;
    double bonus = item.commissionBonus;
    double deductions = item.deductions;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final earnedBase = (item.baseSalary / item.totalWorkDays) * daysPresent;
            final overtimePay = overtimeHours * item.overtimeRatePerHour;
            final netCalculated = (earnedBase + overtimePay + bonus + item.allowances - deductions).clamp(0.0, 9999999.0);

            return Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Payroll Calculation Engine", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                            Text("Adjust earnings & deductions for ${item.employeeName}", style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(height: 20),

                    // Live Net Calculation Preview Badge
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Adjusted Net Payable:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF))),
                          Text(
                            "BDT ${netCalculated.toStringAsFixed(0)}",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF2563EB)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 1. Attendance Days Slider
                    Text("Attendance Credit (${daysPresent.toInt()}/${item.totalWorkDays} Days)", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Slider(
                      value: daysPresent,
                      min: 0,
                      max: item.totalWorkDays.toDouble(),
                      divisions: item.totalWorkDays,
                      activeColor: const Color(0xFF2563EB),
                      label: "${daysPresent.toInt()} days",
                      onChanged: (val) => setModalState(() => daysPresent = val),
                    ),

                    // 2. Overtime Hours Slider
                    Text("Overtime Premium (${overtimeHours.toInt()} Hours)", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Slider(
                      value: overtimeHours,
                      min: 0,
                      max: 40,
                      divisions: 40,
                      activeColor: const Color(0xFF059669),
                      label: "${overtimeHours.toInt()} hrs",
                      onChanged: (val) => setModalState(() => overtimeHours = val),
                    ),

                    // 3. Commission / Bonus Input
                    const Text("Performance Incentive / Bonus (BDT)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: TextEditingController(text: bonus.toStringAsFixed(0)),
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        final parsed = double.tryParse(val) ?? 0.0;
                        setModalState(() => bonus = parsed);
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        prefixText: "BDT ",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 4. Deductions Input
                    const Text("Statutory & Policy Deductions (BDT)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: TextEditingController(text: deductions.toStringAsFixed(0)),
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        final parsed = double.tryParse(val) ?? 0.0;
                        setModalState(() => deductions = parsed);
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        prefixText: "BDT ",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _payrollService.updateCalculation(
                            item.id,
                            daysPresent: daysPresent.toInt(),
                            overtimeHours: overtimeHours,
                            bonus: bonus,
                            deductions: deductions,
                          );
                          Navigator.pop(context);
                          THelperFunctions.showSnackBar("Payroll calculation updated for ${item.employeeName}.");
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("Save Calculation Adjustments", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================
  // 5. PAYMENT DISBURSEMENT MODAL
  // ==========================================
  void _openDisbursementModal(PayrollItem item, NumberFormat format) {
    String selectedMethod = 'Bank Transfer (EFTN)';
    final refController = TextEditingController(text: "PAY-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Authorize Salary Disbursement", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(height: 16),

                  // Recipient details box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.employeeName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                            Text(format.format(item.netPayable), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF059669))),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text("Bank: ${item.bankName} • Acc: ${item.accountNumber}", style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                        Text("bKash Wallet: ${item.bKashNumber}", style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text("Disbursement Channel", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedMethod,
                    items: const [
                      DropdownMenuItem(value: 'Bank Transfer (EFTN)', child: Text('Bank Transfer (EFTN / NPSB)')),
                      DropdownMenuItem(value: 'bKash Payroll', child: Text('bKash Corporate Payroll')),
                      DropdownMenuItem(value: 'Nagad Disbursement', child: Text('Nagad Mobile Money')),
                      DropdownMenuItem(value: 'Cash / Check Voucher', child: Text('Cash / Check Voucher')),
                    ],
                    onChanged: (val) {
                      if (val != null) setModalState(() => selectedMethod = val);
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text("Audit Transaction Reference", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: refController,
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _payrollService.disbursePayment(
                          item.id,
                          method: selectedMethod,
                          reference: refController.text.trim(),
                        );
                        Navigator.pop(context);
                        THelperFunctions.showSnackBar(
                          "Disbursed ${format.format(item.netPayable)} to ${item.employeeName} via $selectedMethod.",
                        );
                      },
                      icon: const Icon(Iconsax.tick_circle, size: 18),
                      label: const Text("Confirm Disbursement", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFF059669),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showDisbursedDetails(PayrollItem item, NumberFormat format) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Iconsax.tick_circle, color: Color(0xFF059669)),
              SizedBox(width: 8),
              Text("Disbursement Record"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Beneficiary: ${item.employeeName}", style: const TextStyle(fontWeight: FontWeight.bold)),
              Text("Disbursed Net Amount: ${format.format(item.netPayable)}", style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("Channel: ${item.disbursementMethod ?? 'Bank Transfer'}"),
              Text("Transaction Ref: ${item.transactionRef ?? 'N/A'}"),
              Text("Disbursed At: ${item.disbursedAt != null ? DateFormat('dd MMM yyyy, hh:mm a').format(item.disbursedAt!) : 'N/A'}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.empty_wallet, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          const Text("No payroll items found", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
          const SizedBox(height: 4),
          const Text("Adjust search query or category filters.", style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'E';
  }
}
