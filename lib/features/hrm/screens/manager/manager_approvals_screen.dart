import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:auth_ui_app/services/approval_service.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class ManagerApprovalsScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const ManagerApprovalsScreen({super.key, this.onBack});

  @override
  State<ManagerApprovalsScreen> createState() => _ManagerApprovalsScreenState();
}

class _ManagerApprovalsScreenState extends State<ManagerApprovalsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApprovalService _approvalService = ApprovalService.instance;
  late List<ApprovalRequest> _allRequests;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadRequests();
  }

  void _loadRequests() {
    setState(() {
      _allRequests = _approvalService.getRequests();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pendingList = _allRequests.where((r) => r.status == ApprovalStatus.pending).toList();
    final approvedList = _allRequests.where((r) => r.status == ApprovalStatus.approved).toList();
    final rejectedList = _allRequests.where((r) => r.status == ApprovalStatus.rejected).toList();

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
            Text("Employee Sales Approvals", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            Text("Employee-Wise Sales & Correction Approvals", style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF2563EB),
          unselectedLabelColor: const Color(0xFF64748B),
          indicatorColor: const Color(0xFF2563EB),
          indicatorWeight: 3,
          tabs: [
            Tab(text: "Pending (${pendingList.length})"),
            Tab(text: "Approved (${approvedList.length})"),
            Tab(text: "Rejected (${rejectedList.length})"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEmployeeGroupedList(pendingList, isPending: true),
          _buildEmployeeGroupedList(approvedList),
          _buildEmployeeGroupedList(rejectedList),
        ],
      ),
    );
  }

  // ==========================================
  // EMPLOYEE-WISE GROUPED APPROVAL LIST
  // ==========================================
  Widget _buildEmployeeGroupedList(List<ApprovalRequest> requests, {bool isPending = false}) {
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.verify, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            const Text("No approval requests found", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
          ],
        ),
      );
    }

    // Group requests by employee name
    final Map<String, List<ApprovalRequest>> grouped = {};
    for (var req in requests) {
      grouped.putIfAbsent(req.employeeName, () => []).add(req);
    }

    final currencyFormat = NumberFormat.currency(symbol: 'BDT ', decimalDigits: 0);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: grouped.keys.length,
      itemBuilder: (context, index) {
        final employeeName = grouped.keys.elementAt(index);
        final empRequests = grouped[employeeName]!;

        double totalSalesValue = 0;
        for (var r in empRequests) {
          if (r.approvalType == 'manual_sales') {
            totalSalesValue += r.value;
          }
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Employee Header Section
              Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                  border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: const Color(0xFFDBEAFE),
                          child: Text(employeeName[0], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(employeeName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                            Text("${empRequests.length} Request(s) • Total: ${currencyFormat.format(totalSalesValue)}", style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                          ],
                        ),
                      ],
                    ),
                    if (isPending)
                      ElevatedButton.icon(
                        onPressed: () => _approveAllForEmployee(employeeName, empRequests),
                        icon: const Icon(Iconsax.tick_circle, size: 14),
                        label: const Text("Approve All", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          backgroundColor: const Color(0xFF059669),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: Size.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                      ),
                  ],
                ),
              ),

              // Individual Requests under this Employee
              ...empRequests.map((req) => _buildSingleRequestCard(req, isPending, currencyFormat)).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSingleRequestCard(ApprovalRequest req, bool isPending, NumberFormat format) {
    final isSales = req.approvalType == 'manual_sales';

    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isSales ? const Color(0xFFEFF6FF) : const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(isSales ? Iconsax.shopping_cart : Iconsax.clock, size: 16, color: isSales ? const Color(0xFF2563EB) : const Color(0xFFD97706)),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isSales ? "Sales Approval Request" : "Attendance Correction Request",
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              Text(
                req.valueDisplay,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isSales ? const Color(0xFF059669) : const Color(0xFF0F172A)),
              ),
            ],
          ),
          const SizedBox(height: 6),

          Text("Source: ${req.sourceInfo}", style: const TextStyle(fontSize: 11, color: Color(0xFF475569))),
          Text("Reason: ${req.reason}", style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          const SizedBox(height: 10),

          if (isPending)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _approvalService.rejectRequest(req.id, comment: "Rejected by Manager");
                      _loadRequests();
                      THelperFunctions.showSnackBar("Rejected request from ${req.employeeName}");
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      foregroundColor: const Color(0xFFDC2626),
                      side: const BorderSide(color: Color(0xFFFCA5A5)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Reject", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _approvalService.approveRequest(req.id);
                      _loadRequests();
                      THelperFunctions.showSnackBar("Approved sales entry for ${req.employeeName}");
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Approve Sales", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _approveAllForEmployee(String empName, List<ApprovalRequest> requests) {
    for (var req in requests) {
      _approvalService.approveRequest(req.id);
    }
    _loadRequests();
    THelperFunctions.showSnackBar("Approved all ${requests.length} pending requests for $empName!");
  }
}
