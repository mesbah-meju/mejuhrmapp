import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:auth_ui_app/services/payroll_service.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class ManagerTeamScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const ManagerTeamScreen({super.key, this.onBack});

  @override
  State<ManagerTeamScreen> createState() => _ManagerTeamScreenState();
}

class _ManagerTeamScreenState extends State<ManagerTeamScreen> {
  final PayrollService _payrollService = PayrollService.instance;
  String _selectedDepartment = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _teamReports = [
    {
      'id': 'EMP-1001',
      'name': 'Rahul Sharma',
      'role': 'Senior Sales Executive',
      'department': 'Sales & Business',
      'avatar': 'RS',
      'salesTarget': 150000.0,
      'salesAchieved': 168000.0,
      'salesPercentage': 112,
      'attendanceRate': 100,
      'tasksCompleted': '12/12',
      'rating': 'Exceeds Expectations (4.9/5.0)',
      'ratingColor': const Color(0xFF059669),
      'status': 'Checked In (09:03 AM)',
      'statusColor': const Color(0xFF059669),
      'recentSales': [
        {'client': 'ABC Corporation', 'amount': 45000.0, 'time': '10:30 AM', 'ref': 'INV-9021', 'status': 'Approved'},
        {'client': 'Global Systems Ltd', 'amount': 78000.0, 'time': '01:15 PM', 'ref': 'INV-9045', 'status': 'Approved'},
        {'client': 'Apex Traders', 'amount': 45000.0, 'time': '04:20 PM', 'ref': 'INV-9088', 'status': 'Approved'},
      ],
    },
    {
      'id': 'EMP-1002',
      'name': 'Ananya Roy',
      'role': 'Sales Associate',
      'department': 'Sales & Operations',
      'avatar': 'AR',
      'salesTarget': 100000.0,
      'salesAchieved': 94000.0,
      'salesPercentage': 94,
      'attendanceRate': 91,
      'tasksCompleted': '9/10',
      'rating': 'Meets Expectations (4.2/5.0)',
      'ratingColor': const Color(0xFF2563EB),
      'status': 'Checked In (09:12 AM)',
      'statusColor': const Color(0xFF059669),
      'recentSales': [
        {'client': 'Metro Retail Outlet', 'amount': 32000.0, 'time': '11:00 AM', 'ref': 'INV-8812', 'status': 'Approved'},
        {'client': 'City Supermart', 'amount': 62000.0, 'time': '02:40 PM', 'ref': 'INV-8834', 'status': 'Approved'},
      ],
    },
    {
      'id': 'EMP-1003',
      'name': 'Tanvir Ahmed',
      'role': 'Business Analyst',
      'department': 'Strategy & Analytics',
      'avatar': 'TA',
      'salesTarget': 80000.0,
      'salesAchieved': 80000.0,
      'salesPercentage': 100,
      'attendanceRate': 100,
      'tasksCompleted': '15/15',
      'rating': 'Top Performer (5.0/5.0)',
      'ratingColor': const Color(0xFF7C3AED),
      'status': 'Checked In (09:00 AM)',
      'statusColor': const Color(0xFF059669),
      'recentSales': [
        {'client': 'Horizon Tech', 'amount': 80000.0, 'time': '09:45 AM', 'ref': 'INV-7721', 'status': 'Approved'},
      ],
    },
    {
      'id': 'EMP-1004',
      'name': 'Nusrat Jahan',
      'role': 'HR Coordinator',
      'department': 'Human Resources',
      'avatar': 'NJ',
      'salesTarget': 50000.0,
      'salesAchieved': 48000.0,
      'salesPercentage': 96,
      'attendanceRate': 95,
      'tasksCompleted': '8/9',
      'rating': 'Good Performance (4.4/5.0)',
      'ratingColor': const Color(0xFF0284C7),
      'status': 'On Field Visit',
      'statusColor': const Color(0xFFD97706),
      'recentSales': [
        {'client': 'Prime Talent Services', 'amount': 48000.0, 'time': '01:30 PM', 'ref': 'INV-6612', 'status': 'Approved'},
      ],
    },
    {
      'id': 'EMP-1005',
      'name': 'Mahmud Hasan',
      'role': 'Support Engineer',
      'avatar': 'MH',
      'salesTarget': 60000.0,
      'salesAchieved': 65000.0,
      'salesPercentage': 108,
      'attendanceRate': 100,
      'tasksCompleted': '18/18',
      'rating': 'Top Performer (4.8/5.0)',
      'ratingColor': const Color(0xFF059669),
      'status': 'Checked In (08:55 AM)',
      'statusColor': const Color(0xFF059669),
      'recentSales': [
        {'client': 'Core IT Solutions', 'amount': 65000.0, 'time': '10:15 AM', 'ref': 'INV-5520', 'status': 'Approved'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: 'BDT ', decimalDigits: 0);

    List<Map<String, dynamic>> filteredList = _teamReports;
    if (_selectedDepartment != 'All') {
      filteredList = filteredList.where((e) => e['department'] == _selectedDepartment).toList();
    }
    if (_searchQuery.isNotEmpty) {
      filteredList = filteredList.where((e) =>
          e['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e['role'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e['id'].toString().toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

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
            Text("Team & Direct Reports", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            Text("Employee Target Performance & Analytics Reports", style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // KPI Summary Header Cards
            _buildTeamSummaryKpi(currencyFormat),

            // Search & Department Filter Chips
            _buildSearchAndFilters(),

            // List of Employee Reports
            Expanded(
              child: filteredList.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        return _buildEmployeeCard(filteredList[index], currencyFormat);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSummaryKpi(NumberFormat format) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total Direct Reports", style: TextStyle(fontSize: 11, color: Color(0xFF1E40AF))),
                  SizedBox(height: 4),
                  Text("5 Employees", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
                  Text("100% Active Staff", style: TextStyle(fontSize: 10, color: Color(0xFF2563EB))),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Avg Target Attainment", style: TextStyle(fontSize: 11, color: Color(0xFF166534))),
                  SizedBox(height: 4),
                  Text("102.8% Target", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF14532D))),
                  Text("Exceeding Benchmarks", style: TextStyle(fontSize: 10, color: Color(0xFF16A34A))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    final departments = ['All', 'Sales & Business', 'Sales & Operations', 'Strategy & Analytics', 'Human Resources', 'IT & Support'];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        children: [
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
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF2563EB))),
            ),
          ),
          const SizedBox(height: 10),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: departments.map((dept) {
                final isSelected = _selectedDepartment == dept;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(dept, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.white : const Color(0xFF475569))),
                    selected: isSelected,
                    selectedColor: const Color(0xFF2563EB),
                    backgroundColor: const Color(0xFFF1F5F9),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedDepartment = dept);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(Map<String, dynamic> emp, NumberFormat format) {
    final salesPct = emp['salesPercentage'] as int;
    final isTargetExceeded = salesPct >= 100;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: InkWell(
        onTap: () => _openDynamicTargetReportModal(emp, format),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Avatar, Name & Status
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFFDBEAFE),
                    child: Text(emp['avatar'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(emp['name'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: (emp['statusColor'] as Color).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                emp['status'],
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: emp['statusColor'] as Color),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text("${emp['role']} • ${emp['department']}", style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              const SizedBox(height: 10),

              // Metrics Grid: Sales, Attendance, Tasks
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Sales Target Goal", style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                        Text("${emp['salesPercentage']}%", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isTargetExceeded ? const Color(0xFF059669) : const Color(0xFFD97706))),
                        Text("${format.format(emp['salesAchieved'])}", style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Attendance Rate", style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                        Text("${emp['attendanceRate']}%", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                        const Text("22/22 Days Present", style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Task Execution", style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                        Text("${emp['tasksCompleted']}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                        const Text("100% On-time", style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Dynamic Target Report Footer Button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Iconsax.chart_2, size: 16, color: emp['ratingColor'] as Color),
                        const SizedBox(width: 6),
                        Text(emp['rating'], style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: emp['ratingColor'] as Color)),
                      ],
                    ),
                    const Row(
                      children: [
                        Text("View Dynamic Target Report", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 10, color: Color(0xFF2563EB)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // DYNAMIC DETAILED TARGET & PERFORMANCE REPORT MODAL SHEET
  // ============================================================================
  void _openDynamicTargetReportModal(Map<String, dynamic> emp, NumberFormat format) {
    final salesPct = emp['salesPercentage'] as int;
    final isTargetExceeded = salesPct >= 100;
    final double targetVal = emp['salesTarget'];
    final double achievedVal = emp['salesAchieved'];
    final double variance = achievedVal - targetVal;
    final recentSales = (emp['recentSales'] as List<Map<String, dynamic>>? ?? []);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.88,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Modal Handle & Top Title Header
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                ),
                child: Column(
                  children: [
                    Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2)))),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: const Color(0xFFDBEAFE),
                              child: Text(emp['avatar'], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${emp['name']}'s Target Analytics",
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                ),
                                Text(
                                  "Employee ID: ${emp['id']} • ${emp['department']}",
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Scrollable Dynamic Content Body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. DYNAMIC HIGHLIGHT CAROUSEL CARD
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isTargetExceeded
                                ? [const Color(0xFF065F46), const Color(0xFF059669)]
                                : [const Color(0xFF1E3A8A), const Color(0xFF2563EB)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: (isTargetExceeded ? const Color(0xFF059669) : const Color(0xFF2563EB)).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("MONTHLY TARGET ATTAINMENT", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF93C5FD), letterSpacing: 0.5)),
                                    const SizedBox(height: 4),
                                    Text(
                                      format.format(achievedVal),
                                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(isTargetExceeded ? Iconsax.award : Iconsax.trend_up, size: 14, color: Colors.white),
                                      const SizedBox(width: 4),
                                      Text(
                                        "$salesPct% Reached",
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Dynamic Progress Bar Indicator
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: (salesPct / 100).clamp(0.0, 1.0),
                                minHeight: 8,
                                backgroundColor: Colors.white.withOpacity(0.2),
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            const SizedBox(height: 12),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Target Goal: ${format.format(targetVal)}",
                                  style: const TextStyle(fontSize: 11, color: Color(0xFFE2E8F0)),
                                ),
                                Text(
                                  isTargetExceeded ? "Surplus: +${format.format(variance)}" : "Remaining: ${format.format(targetVal - achievedVal)}",
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 2. DETAILED METRICS GRID (4 CARDS)
                      const Text("PERFORMANCE ANALYTICS BREAKDOWN", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5)),
                      const SizedBox(height: 10),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.6,
                        children: [
                          _buildAnalyticsTile("Target Revenue Goal", format.format(targetVal), "Baseline Monthly", Iconsax.direct_up, const Color(0xFF2563EB)),
                          _buildAnalyticsTile("Actual Achieved", format.format(achievedVal), "$salesPct% Attainment", Iconsax.money_send, const Color(0xFF059669)),
                          _buildAnalyticsTile("Variance / Surplus", "+${format.format(variance.clamp(0.0, 9999999.0))}", "Exceeding Benchmark", Iconsax.chart_success, const Color(0xFF7C3AED)),
                          _buildAnalyticsTile("Est. Commission", format.format(achievedVal * 0.05), "5% Bonus Earnings", Iconsax.coin_1, const Color(0xFFD97706)),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 3. HOURLY SALES VELOCITY SLOTS (VISUAL BARS)
                      const Text("HOURLY SALES VELOCITY", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: [
                            _buildVelocityBar("Morning Slot (09:00 AM - 12:00 PM)", 0.40, "BDT 65,000 (40%)"),
                            const SizedBox(height: 10),
                            _buildVelocityBar("Afternoon Slot (12:00 PM - 03:00 PM)", 0.45, "BDT 75,000 (45%)"),
                            const SizedBox(height: 10),
                            _buildVelocityBar("Evening Slot (03:00 PM - 06:00 PM)", 0.15, "BDT 28,000 (15%)"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 4. ITEMIZED RECENT SALES LEDGER BREAKDOWN
                      const Text("CONTRIBUTING SALES ENTRIES LEDGER", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5)),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: recentSales.map((sale) {
                            return Column(
                              children: [
                                ListTile(
                                  dense: true,
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(8)),
                                    child: const Icon(Iconsax.receipt_item, size: 18, color: Color(0xFF059669)),
                                  ),
                                  title: Text(sale['client'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                  subtitle: Text("Invoice: ${sale['ref']} • ${sale['time']}", style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(format.format(sale['amount']), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF059669))),
                                      Text(sale['status'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF16A34A))),
                                    ],
                                  ),
                                ),
                                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 5. ACTION BUTTONS FOOTER
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                THelperFunctions.showSnackBar("Exporting ${emp['name']} Target Performance PDF Report...");
                              },
                              icon: const Icon(Iconsax.document_download, size: 16),
                              label: const Text("Export PDF", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                foregroundColor: const Color(0xFF2563EB),
                                side: const BorderSide(color: Color(0xFF93C5FD)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                backgroundColor: const Color(0xFF0F172A),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text("Close Analytics", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnalyticsTile(String title, String value, String sub, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
              Icon(icon, size: 16, color: color),
            ],
          ),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
          Text(sub, style: const TextStyle(fontSize: 9, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }

  Widget _buildVelocityBar(String label, double fraction, String valueStr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
            Text(valueStr, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 6,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text("No employee reports found matching criteria.", style: TextStyle(color: Color(0xFF64748B))),
    );
  }
}
