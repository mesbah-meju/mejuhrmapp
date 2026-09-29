import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:auth_ui_app/services/approval_service.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class ApprovalsScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const ApprovalsScreen({super.key, this.onBack});

  @override
  State<ApprovalsScreen> createState() => _ApprovalsScreenState();
}

class _ApprovalsScreenState extends State<ApprovalsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<ApprovalRequest> _requests;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadRequests();
  }

  void _loadRequests() {
    setState(() {
      _requests = ApprovalService.instance.getRequests();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pendingList = _requests.where((r) => r.status == ApprovalStatus.pending).toList();
    final approvedList = _requests.where((r) => r.status == ApprovalStatus.approved).toList();
    final rejectedList = _requests.where((r) => r.status == ApprovalStatus.rejected).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF1E293B)),
          onPressed: widget.onBack ?? () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Approval Engine & Requests",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF2563EB),
          unselectedLabelColor: const Color(0xFF64748B),
          indicatorColor: const Color(0xFF2563EB),
          tabs: [
            Tab(text: "Pending (${pendingList.length})"),
            Tab(text: "Approved (${approvedList.length})"),
            Tab(text: "Rejected (${rejectedList.length})"),
          ],
        ),
      ),
      body: Column(
        children: [
          // Official vs Pending vs Estimated Summary Banner
          _buildOfficialVsPendingBanner(),

          // Tab Bar View List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRequestList(pendingList, isPending: true),
                _buildRequestList(approvedList),
                _buildRequestList(rejectedList),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfficialVsPendingBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Iconsax.calculator, size: 18, color: Color(0xFF2563EB)),
              SizedBox(width: 8),
              Text(
                "Sales & Performance Financial State",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  title: "OFFICIAL",
                  value: "BDT 70,000",
                  subtitle: "Server Confirmed",
                  color: const Color(0xFF059669),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricTile(
                  title: "PENDING",
                  value: "BDT 13,000",
                  subtitle: "Awaiting Approval",
                  color: const Color(0xFFD97706),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricTile(
                  title: "ESTIMATED",
                  value: "BDT 83,000",
                  subtitle: "Official + Pending",
                  color: const Color(0xFF2563EB),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 9, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestList(List<ApprovalRequest> list, {bool isPending = false}) {
    if (list.isEmpty) {
      return const Center(
        child: Text("No approval requests in this category.", style: TextStyle(color: Color(0xFF94A3B8))),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final req = list[index];
        return _buildApprovalCard(req, isPending: isPending);
      },
    );
  }

  Widget _buildApprovalCard(ApprovalRequest req, {required bool isPending}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: const Color(0xFFEFF6FF),
                    child: Text(
                      req.employeeName.substring(0, 1),
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        req.employeeName,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      Text(
                        req.requestedBy,
                        style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  req.valueDisplay,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
              ),
            ],
          ),
          const Divider(height: 16, color: Color(0xFFF1F5F9)),

          Text(
            req.sourceInfo,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
          ),
          const SizedBox(height: 4),
          Text(
            "Reason: ${req.reason}",
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),

          if (req.reviewComment != null) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "Review Comment: ${req.reviewComment}",
                style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF475569)),
              ),
            ),
          ],

          if (isPending) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showRejectDialog(req),
                    style: OutlinedButton.styleFrom(
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
                    onPressed: () async {
                      await ApprovalService.instance.approveRequest(req.id);
                      _loadRequests();
                      THelperFunctions.showSnackBar("Request approved successfully!");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF059669),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Approve", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showRejectDialog(ApprovalRequest req) {
    final commentController = TextEditingController();

    Get.defaultDialog(
      title: "Reject Request",
      titleStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      content: Column(
        children: [
          Text("Reason for rejecting ${req.employeeName}'s request:", style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 10),
          TextField(
            controller: commentController,
            decoration: InputDecoration(
              hintText: "Enter rejection comment...",
              hintStyle: const TextStyle(fontSize: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
      textConfirm: "Confirm Rejection",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFDC2626),
      onConfirm: () async {
        if (commentController.text.trim().isEmpty) {
          THelperFunctions.showSnackBar("Please enter a rejection comment.");
          return;
        }
        Get.back();
        await ApprovalService.instance.rejectRequest(req.id, comment: commentController.text.trim());
        _loadRequests();
        THelperFunctions.showSnackBar("Request rejected.");
      },
    );
  }
}
