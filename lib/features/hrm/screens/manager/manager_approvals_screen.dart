import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:auth_ui_app/features/hrm/controllers/controllers.dart';
import 'package:auth_ui_app/features/hrm/models/manager_models.dart';

class ManagerApprovalsScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const ManagerApprovalsScreen({super.key, this.onBack});

  @override
  State<ManagerApprovalsScreen> createState() => _ManagerApprovalsScreenState();
}

class _ManagerApprovalsScreenState extends State<ManagerApprovalsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ManagerLeaveController controller = ManagerLeaveController.instance;
  final ManagerEmployeeController empController = ManagerEmployeeController.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    controller.fetchLeaves();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            Text("Staff Leave Approvals", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            Text("Review & record employee leave requests", style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF2563EB)),
            tooltip: "Refresh",
            onPressed: () => controller.fetchLeaves(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF2563EB),
          unselectedLabelColor: const Color(0xFF64748B),
          indicatorColor: const Color(0xFF2563EB),
          indicatorWeight: 3,
          tabs: [
            Obx(() => Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Iconsax.clock, size: 16),
                      const SizedBox(width: 6),
                      Text("Pending (${controller.pendingLeaves.length})"),
                    ],
                  ),
                )),
            Obx(() => Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Iconsax.verify, size: 16),
                      const SizedBox(width: 6),
                      Text("Approved (${controller.approvedLeaves.length})"),
                    ],
                  ),
                )),
            Obx(() => Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Iconsax.close_circle, size: 16),
                      const SizedBox(width: 6),
                      Text("Rejected (${controller.rejectedLeaves.length})"),
                    ],
                  ),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateLeaveModal(context),
        backgroundColor: const Color(0xFF2563EB),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text("Create Leave", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLeavesList(controller.pendingLeaves, isPending: true),
          _buildLeavesList(controller.approvedLeaves),
          _buildLeavesList(controller.rejectedLeaves),
        ],
      ),
    );
  }

  // =========================================================================
  // LEAVES LIST
  // =========================================================================
  Widget _buildLeavesList(List<ManagerLeaveModel> leaves, {bool isPending = false}) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(color: Color(0xFF2563EB)),
          ),
        );
      }

      if (leaves.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Iconsax.empty_wallet, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                isPending ? "No pending leave requests" : "No leave records found",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 4),
              Text(
                isPending ? "All staff leave requests are up to date" : "Approved and rejected leaves appear here",
                style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.fetchLeaves(),
        color: const Color(0xFF2563EB),
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 90),
          itemCount: leaves.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final item = leaves[index];
            return _buildLeaveCard(item, isPending: isPending);
          },
        ),
      );
    });
  }

  // =========================================================================
  // LEAVE CARD
  // =========================================================================
  Widget _buildLeaveCard(ManagerLeaveModel item, {bool isPending = false}) {
    final isApproved = item.status == 'approved';
    final isRejected = item.status == 'rejected';

    final Color statusColor = isPending
        ? const Color(0xFFD97706)
        : isApproved
            ? const Color(0xFF059669)
            : const Color(0xFFDC2626);

    final Color statusBg = isPending
        ? const Color(0xFFFEF3C7)
        : isApproved
            ? const Color(0xFFDCFCE7)
            : const Color(0xFFFEE2E2);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Employee Name, Leave Type & Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFFEFF6FF),
                    child: Text(
                      item.employeeName != null && item.employeeName!.isNotEmpty ? item.employeeName![0] : 'S',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.employeeName ?? 'Staff', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      Text(
                        item.leaveTypeName ?? 'Leave Request',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF2563EB)),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(6)),
                child: Text(
                  item.status.capitalizeFirst ?? 'Pending',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Date Duration & Days Count Box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Iconsax.calendar_1, size: 16, color: Color(0xFF64748B)),
                    const SizedBox(width: 6),
                    Text(
                      "${item.startDate}  →  ${item.endDate}",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "${item.daysCount.toStringAsFixed(item.daysCount.truncateToDouble() == item.daysCount ? 0 : 1)} Day(s)",
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                  ),
                ),
              ],
            ),
          ),

          if (item.reason != null && item.reason!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              "Reason: ${item.reason}",
              style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
            ),
          ],

          if (item.approverComment != null && item.approverComment!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              "Manager Note: ${item.approverComment}",
              style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF64748B)),
            ),
          ],

          // If Pending, show APPROVE & REJECT action buttons
          if (isPending) ...[
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFDC2626),
                    side: const BorderSide(color: Color(0xFFFCA5A5)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.close_rounded, size: 16),
                  label: const Text("Reject"),
                  onPressed: () => _showReviewDialog(context, item, isApprove: false),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.check_rounded, size: 16),
                  label: const Text("Approve"),
                  onPressed: () => _showReviewDialog(context, item, isApprove: true),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // =========================================================================
  // REVIEW (APPROVE/REJECT) DIALOG
  // =========================================================================
  void _showReviewDialog(BuildContext context, ManagerLeaveModel item, {required bool isApprove}) {
    final commentCtrl = TextEditingController(text: isApprove ? "Approved" : "Rejected");

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          isApprove ? "Approve Leave Request" : "Reject Leave Request",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isApprove ? const Color(0xFF059669) : const Color(0xFFDC2626),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Leave for ${item.employeeName} (${item.startDate} to ${item.endDate})",
              style: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: commentCtrl,
              decoration: const InputDecoration(
                labelText: "Approver Comment (Optional)",
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isApprove ? const Color(0xFF059669) : const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await controller.reviewLeave(
                leaveId: item.id,
                status: isApprove ? 'approved' : 'rejected',
                comment: commentCtrl.text.trim(),
              );
            },
            child: Text(isApprove ? "Approve" : "Reject"),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // CREATE LEAVE FOR STAFF MODAL
  // =========================================================================
  void _showCreateLeaveModal(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final reasonCtrl = TextEditingController();
    final startCtrl = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
    final endCtrl = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));

    int? selectedEmpId = empController.activeEmployees.isNotEmpty ? empController.activeEmployees.first.id : null;
    int leaveTypeId = 1;
    String status = "approved"; // Manager creating is directly approved or pending

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Create Staff Leave", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const Divider(),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    // Employee Dropdown
                    Obx(() => DropdownButtonFormField<int>(
                          value: selectedEmpId,
                          decoration: const InputDecoration(labelText: "Staff Member *", prefixIcon: Icon(Iconsax.user)),
                          items: empController.activeEmployees
                              .map((e) => DropdownMenuItem(value: e.id, child: Text("${e.name} (${e.employeeId})")))
                              .toList(),
                          onChanged: (val) => setSheetState(() => selectedEmpId = val),
                          validator: (v) => v == null ? "Required" : null,
                        )),
                    const SizedBox(height: 12),

                    // Leave Type & Status
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: leaveTypeId,
                            decoration: const InputDecoration(labelText: "Leave Type"),
                            items: const [
                              DropdownMenuItem(value: 1, child: Text("Casual Leave")),
                              DropdownMenuItem(value: 2, child: Text("Sick Leave")),
                              DropdownMenuItem(value: 3, child: Text("Annual Leave")),
                            ],
                            onChanged: (val) => setSheetState(() => leaveTypeId = val ?? 1),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: status,
                            decoration: const InputDecoration(labelText: "Status"),
                            items: const [
                              DropdownMenuItem(value: 'approved', child: Text("Approved")),
                              DropdownMenuItem(value: 'pending', child: Text("Pending")),
                            ],
                            onChanged: (val) => setSheetState(() => status = val ?? 'approved'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Dates
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: startCtrl,
                            decoration: const InputDecoration(labelText: "Start Date (YYYY-MM-DD)"),
                            validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: endCtrl,
                            decoration: const InputDecoration(labelText: "End Date (YYYY-MM-DD)"),
                            validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: reasonCtrl,
                      decoration: const InputDecoration(labelText: "Reason / Details", prefixIcon: Icon(Iconsax.note)),
                    ),
                    const SizedBox(height: 20),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final body = {
                              'employee_id': selectedEmpId,
                              'leave_type_id': leaveTypeId,
                              'start_date': startCtrl.text.trim(),
                              'end_date': endCtrl.text.trim(),
                              'status': status,
                              if (reasonCtrl.text.isNotEmpty) 'reason': reasonCtrl.text.trim(),
                            };

                            final ok = await controller.createLeave(body);
                            if (ok && ctx.mounted) Navigator.pop(ctx);
                          }
                        },
                        child: const Text("Save & Record Leave", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
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
}
