import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:auth_ui_app/common/widgets/app_page_header.dart';

class PayrollScreen extends StatefulWidget {
  final VoidCallback? onBackToDashboard;
  final bool initialShowingHistory;

  const PayrollScreen({
    super.key,
    this.onBackToDashboard,
    this.initialShowingHistory = false,
  });

  @override
  State<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  late bool _showingHistory;
  String _selectedHistoryFilter = 'All'; // 'All', 'Paid', 'Pending', 'Adjustments'

  // Payroll History Records
  final List<Map<String, dynamic>> _payrollHistory = [
    {
      'month': 'September 2026',
      'shortMonth': 'SEP',
      'year': '2026',
      'amount': 'BDT 32,500',
      'paidDate': 'Paid on 30 Sep 2026',
      'details': '20/22 days • 146 hours • BDT 5,200 commission',
      'status': 'Paid',
      'statusColor': Color(0xFF059669),
      'statusBg': Color(0xFFDCFCE7),
    },
    {
      'month': 'August 2026',
      'shortMonth': 'AUG',
      'year': '2026',
      'amount': 'BDT 28,000',
      'paidDate': 'Paid on 31 Aug 2026',
      'details': '22/22 days • 168 hours • BDT 3,000 commission',
      'status': 'Paid',
      'statusColor': Color(0xFF059669),
      'statusBg': Color(0xFFDCFCE7),
    },
    {
      'month': 'July 2026',
      'shortMonth': 'JUL',
      'year': '2026',
      'amount': 'BDT 31,200',
      'paidDate': 'Paid on 31 Jul 2026',
      'details': '21/22 days • 160 hours • BDT 4,500 commission',
      'status': 'Paid',
      'statusColor': Color(0xFF059669),
      'statusBg': Color(0xFFDCFCE7),
    },
    {
      'month': 'June 2026',
      'shortMonth': 'JUN',
      'year': '2026',
      'amount': 'BDT 29,800',
      'paidDate': 'Paid on 30 Jun 2026',
      'details': '20/22 days • 152 hours • BDT 3,800 commission',
      'status': 'Paid',
      'statusColor': Color(0xFF059669),
      'statusBg': Color(0xFFDCFCE7),
    },
    {
      'month': 'May 2026',
      'shortMonth': 'MAY',
      'year': '2026',
      'amount': 'BDT 27,500',
      'paidDate': 'Paid on 31 May 2026',
      'details': '19/22 days • 140 hours • BDT 3,500 commission',
      'status': 'Paid',
      'statusColor': Color(0xFF059669),
      'statusBg': Color(0xFFDCFCE7),
    },
    {
      'month': 'April 2026',
      'shortMonth': 'APR',
      'year': '2026',
      'amount': 'BDT 30,000',
      'paidDate': 'Paid on 30 Apr 2026',
      'details': '21/22 days • 158 hours • BDT 4,000 commission',
      'status': 'Paid',
      'statusColor': Color(0xFF059669),
      'statusBg': Color(0xFFDCFCE7),
    },
  ];

  @override
  void initState() {
    super.initState();
    _showingHistory = widget.initialShowingHistory;
  }

  @override
  Widget build(BuildContext context) {
    return _showingHistory ? _buildHistoryView() : _buildCurrentPayrollView();
  }

  // ==========================================
  // VIEW 1: CURRENT PAYROLL VIEW
  // ==========================================
  Widget _buildCurrentPayrollView() {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header with Title and History Button
              AppPageHeader(
                title: "Payroll & Salary",
                padding: EdgeInsets.zero,
                onBack: widget.onBackToDashboard ?? () => Navigator.of(context).maybePop(),
                action: AppHeaderActionBadge.history(
                  onTap: () => setState(() => _showingHistory = true),
                ),
              ),
              const SizedBox(height: 16),

              // Estimated Salary Banner Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF047857),
                      Color(0xFF059669),
                      Color(0xFF10B981),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF059669).withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Iconsax.wallet_3, color: Colors.white, size: 22),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Estimated Salary (This Month)",
                              style: TextStyle(
                                fontSize: 12.5,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.bar_chart_rounded, color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text(
                                "In Progress",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "BDT 32,500",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Based on 20/22 working days • Updated today",
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 3 Metric Cards Row (Working Days, Total Hours, Commission)
              Row(
                children: [
                  Expanded(
                    child: _buildMetricPill(
                      icon: Icons.calendar_today_rounded,
                      iconColor: const Color(0xFF2563EB),
                      title: "Working Days",
                      value: "20 / 22",
                      subtitle: "Completed",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildHoursPill(),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricPill(
                      icon: Icons.bar_chart_rounded,
                      iconColor: const Color(0xFF059669),
                      title: "Commission",
                      value: "BDT 5,200",
                      subtitle: "From 12 deals",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Dual Cards Row (To Be Paid vs You Owe)
              Row(
                children: [
                  // To Be Paid Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFA7F3D0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF059669),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.arrow_downward_rounded, size: 14, color: Colors.white),
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  "To Be Paid (You Will Get)",
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF065F46)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "BDT 32,500",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF065F46)),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Expected on 30 Sep 2026",
                            style: TextStyle(fontSize: 10, color: Color(0xFF059669)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // You Owe Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F2),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFFFE4E6)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFDC2626),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.arrow_upward_rounded, size: 14, color: Colors.white),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "You Owe",
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF991B1B)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "BDT 2,000",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFFDC2626)),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Loan / Advance",
                            style: TextStyle(fontSize: 10, color: Color(0xFF991B1B)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Earning Breakdown Card
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
                    const Row(
                      children: [
                        Icon(Icons.pie_chart_outline_rounded, size: 18, color: Color(0xFF7C3AED)),
                        SizedBox(width: 8),
                        Text(
                          "Earning Breakdown (This Month)",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildBreakdownRow("Basic Salary (20/22 days)", "BDT 25,000"),
                    _buildBreakdownRow("Overtime (16 hours)", "BDT 3,200"),
                    _buildBreakdownRow("Commission (12 deals)", "BDT 5,200"),
                    _buildBreakdownRow("Allowances", "BDT 1,100"),
                    const SizedBox(height: 6),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Total Earnings",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                        ),
                        Text(
                          "BDT 34,500",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF059669)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Deductions Card
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
                    const Row(
                      children: [
                        Icon(Icons.remove_circle_outline_rounded, size: 18, color: Color(0xFFDC2626)),
                        SizedBox(width: 8),
                        Text(
                          "Deductions",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildBreakdownRow("Loan / Advance", "BDT 2,000"),
                    _buildBreakdownRow("Late Deduction (1 day)", "BDT 0"),
                    const SizedBox(height: 6),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Total Deductions",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
                        ),
                        Text(
                          "BDT 2,000",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFFDC2626)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Net Payable Banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Net Payable (You Will Get)",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E3A8A)),
                        ),
                      ],
                    ),
                    const Text(
                      "BDT 32,500",
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF2563EB)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricPill({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }

  Widget _buildHoursPill() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.access_time_filled_rounded, size: 16, color: Color(0xFF2563EB)),
          const SizedBox(height: 6),
          const Text("Total Hours", style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
          const SizedBox(height: 2),
          const Text(
            "146h / 176h",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Text("83%", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
              const SizedBox(width: 4),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 0.83,
                    backgroundColor: Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                    minHeight: 4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(String title, String amount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          Text(
            amount,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // VIEW 2: PAYROLL HISTORY VIEW
  // ==========================================
  Widget _buildHistoryView() {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Back Button & Header
              AppPageHeader(
                title: "Payroll History",
                padding: EdgeInsets.zero,
                onBack: () => setState(() => _showingHistory = false),
              ),
              const SizedBox(height: 16),

              // Filter Tabs (All / Paid / Pending / Adjustments)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    _buildHistoryFilterTab("All"),
                    _buildHistoryFilterTab("Paid"),
                    _buildHistoryFilterTab("Pending"),
                    _buildHistoryFilterTab("Adjustments"),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Monthly Salary Payment Records List
              ..._payrollHistory.map((record) => _buildHistoryCard(record)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryFilterTab(String label) {
    final isSelected = _selectedHistoryFilter == label;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedHistoryFilter = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFDBEAFE) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month Label Title
          Text(
            record['month'],
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),

          // Main Card Content
          Row(
            children: [
              // Date Box (SEP 2026)
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      record['shortMonth'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    Text(
                      record['year'],
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // Salary Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          record['amount'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: record['statusBg'] as Color,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            record['status'],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: record['statusColor'] as Color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 12, color: Color(0xFF64748B)),
                        const SizedBox(width: 4),
                        Text(
                          record['paidDate'],
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.description_outlined, size: 12, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            record['details'],
                            style: const TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF94A3B8)),
            ],
          ),
        ],
      ),
    );
  }
}
