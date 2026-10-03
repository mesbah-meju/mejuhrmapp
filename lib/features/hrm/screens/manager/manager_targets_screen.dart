import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:auth_ui_app/common/widgets/app_page_header.dart';
import 'package:auth_ui_app/common/widgets/form_fields/form_fields.dart';
import 'package:auth_ui_app/features/hrm/controllers/controllers.dart';
import 'package:auth_ui_app/features/hrm/models/manager_models.dart';
import 'package:auth_ui_app/features/hrm/models/target_model.dart';

class ManagerTargetsScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const ManagerTargetsScreen({super.key, this.onBack});

  @override
  State<ManagerTargetsScreen> createState() => _ManagerTargetsScreenState();
}

class _ManagerTargetsScreenState extends State<ManagerTargetsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ManagerTargetController controller = ManagerTargetController.instance;
  final ManagerEmployeeController empController = ManagerEmployeeController.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    controller.fetchTargets();
    controller.fetchSalesLogs();
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateTargetModal(context),
        backgroundColor: const Color(0xFF2563EB),
        icon: const Icon(Icons.add_chart_rounded, color: Colors.white),
        label: const Text("New Target", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            AppPageHeader(
              title: "Sales & Targets",
              onBack: widget.onBack ?? () => Navigator.of(context).maybePop(),
              action: AppHeaderActionBadge.refresh(
                onTap: () {
                  controller.fetchTargets();
                  controller.fetchSalesLogs();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              child: Obx(() => CustomSegmentedTabBar(
                    controller: _tabController,
                    tabs: [
                      SegmentTab(
                        label: "Sales Logs",
                        icon: const Icon(Iconsax.receipt_edit),
                        badgeCount: controller.pendingLogsCount,
                      ),
                      SegmentTab(
                        label: "Sales Targets",
                        icon: const Icon(Iconsax.radar_2),
                        badgeCount: controller.targets.length,
                      ),
                    ],
                  )),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSalesLogsTab(),
                  _buildTargetsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // TAB 1: SALES LOGS VERIFICATION & APPROVAL
  // =========================================================================
  Widget _buildSalesLogsTab() {
    return RefreshIndicator(
      onRefresh: () => controller.fetchSalesLogs(),
      color: const Color(0xFF2563EB),
      child: Column(
        children: [
          // Filter Chips (Pending, Approved, Rejected)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildStatusChip('pending', 'Pending Review'),
                const SizedBox(width: 8),
                _buildStatusChip('approved', 'Approved'),
                const SizedBox(width: 8),
                _buildStatusChip('rejected', 'Rejected'),
              ],
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoadingLogs.value) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
              }

              final logs = controller.salesLogs;

              if (logs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.receipt_item, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 12),
                      const Text("No sales entries found", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                    ],
                  ),
                );
              }

              return ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                itemCount: logs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final log = logs[index];
                  return _buildSalesLogCard(log);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status, String label) {
    return Obx(() {
      final isSelected = controller.selectedLogStatus.value == status;
      return ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (sel) {
          if (sel) controller.updateLogStatusFilter(status);
        },
        selectedColor: const Color(0xFF2563EB),
        labelStyle: TextStyle(
          fontSize: 11,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.white : const Color(0xFF64748B),
        ),
      );
    });
  }

  Widget _buildSalesLogCard(SalesLogModel log) {
    final isPending = log.status.toLowerCase() == 'pending';
    final isApproved = log.status.toLowerCase() == 'approved';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                log.productName ?? log.entryType.replaceAll('_', ' ').capitalizeFirst ?? "Sales Entry",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isPending
                      ? const Color(0xFFFEF3C7)
                      : isApproved
                          ? const Color(0xFFDCFCE7)
                          : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  log.status.capitalizeFirst ?? 'Pending',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isPending
                        ? const Color(0xFFD97706)
                        : isApproved
                            ? const Color(0xFF059669)
                            : const Color(0xFFDC2626),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Date: ${log.logDate}", style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              Text(
                "Qty: ${log.quantity.toStringAsFixed(0)}  •  BDT ${log.totalAmount.toStringAsFixed(0)}",
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
              ),
            ],
          ),

          if (log.customerName != null && log.customerName!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text("Customer: ${log.customerName!}", style: const TextStyle(fontSize: 11, color: Color(0xFF475569))),
          ],
          if (log.invoiceNo != null && log.invoiceNo!.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text("Invoice: ${log.invoiceNo!}", style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          ],

          if (isPending) ...[
            const SizedBox(height: 10),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFDC2626),
                    side: const BorderSide(color: Color(0xFFFCA5A5)),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  ),
                  icon: const Icon(Icons.close_rounded, size: 14),
                  label: const Text("Reject", style: TextStyle(fontSize: 11)),
                  onPressed: () => _showRejectSalesLogDialog(context, log.id),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  icon: const Icon(Icons.check_rounded, size: 14),
                  label: const Text("Approve", style: TextStyle(fontSize: 11)),
                  onPressed: () => controller.approveSalesLog(log.id),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showRejectSalesLogDialog(BuildContext context, int logId) {
    final reasonCtrl = TextEditingController(text: "Invoice mismatched");

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Reject Sales Log", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: reasonCtrl,
          decoration: const InputDecoration(labelText: "Rejection Reason", border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              controller.rejectSalesLog(logId, reasonCtrl.text.trim());
            },
            child: const Text("Reject"),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // TAB 2: SALES TARGETS LIST (CRUD)
  // =========================================================================
  Widget _buildTargetsTab() {
    return Obx(() {
      if (controller.isLoadingTargets.value) {
        return const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)));
      }

      final targets = controller.targets;

      if (targets.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Iconsax.radar, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              const Text("No sales targets created yet", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
              const SizedBox(height: 4),
              const Text("Tap '+ New Target' to configure monthly/quarterly targets", style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.fetchTargets(),
        color: const Color(0xFF2563EB),
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 90),
          itemCount: targets.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final t = targets[index];
            return _buildTargetCard(t);
          },
        ),
      );
    });
  }

  Widget _buildTargetCard(ManagerSalesTargetModel t) {
    final currency = NumberFormat.currency(symbol: 'BDT ', decimalDigits: 0);
    final pct = t.targetAmount > 0 ? ((t.achievedAmount / t.targetAmount) * 100).clamp(0, 200).toInt() : 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    Text("Assigned: ${t.userName ?? 'All Team'}", style: const TextStyle(fontSize: 11, color: Color(0xFF2563EB))),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(6)),
                child: Text(t.periodType.capitalizeFirst ?? 'Monthly', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Target vs Achieved
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Target: ${currency.format(t.targetAmount)}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
              Text("Achieved: ${currency.format(t.achievedAmount)} ($pct%)", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: (pct / 100).clamp(0.0, 1.0),
            backgroundColor: const Color(0xFFE2E8F0),
            color: const Color(0xFF059669),
            minHeight: 6,
            borderRadius: BorderRadius.circular(4),
          ),

          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${t.startDate} to ${t.endDate}", style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
              Row(
                children: [
                  TextButton.icon(
                    style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), minimumSize: Size.zero),
                    icon: const Icon(Iconsax.edit_2, size: 14, color: Color(0xFF2563EB)),
                    label: const Text("Edit", style: TextStyle(fontSize: 11, color: Color(0xFF2563EB))),
                    onPressed: () => _showEditTargetModal(context, t),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Iconsax.trash, size: 15, color: Color(0xFF94A3B8)),
                    onPressed: () => controller.deleteTarget(t.id),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // CREATE / EDIT TARGET MODALS
  // =========================================================================
  void _showCreateTargetModal(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final startCtrl = TextEditingController(text: DateFormat('yyyy-MM-01').format(DateTime.now()));
    final endCtrl = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime(DateTime.now().year, DateTime.now().month + 1, 0)),
    );

    int? assignedUserId = empController.activeEmployees.isNotEmpty ? empController.activeEmployees.first.userId : null;
    String targetType = 'overall';
    String periodType = 'monthly';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Create Sales Target", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const Divider(),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(labelText: "Target Title *", prefixIcon: Icon(Iconsax.radar)),
                      validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
                    ),
                    const SizedBox(height: 10),
                    CustomDropdownField<int?>(
                      label: "Assign to Staff Member",
                      sheetTitle: "Select Staff Member",
                      value: assignedUserId,
                      prefixIcon: const Icon(Iconsax.user, size: 18, color: Color(0xFF64748B)),
                      items: [
                        null,
                        ...empController.activeEmployees.where((e) => e.userId != null).map((e) => e.userId),
                      ],
                      itemLabelBuilder: (id) {
                        if (id == null) return "All Sales Team";
                        final match = empController.activeEmployees.firstWhereOrNull((e) => e.userId == id);
                        return match?.name ?? "Sales Staff ($id)";
                      },
                      onChanged: (val) => setModalState(() => assignedUserId = val),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: CustomDropdownField<String>(
                            label: "Period",
                            sheetTitle: "Select Period",
                            searchable: false,
                            value: periodType,
                            items: const ['monthly', 'quarterly', 'yearly'],
                            itemLabelBuilder: (p) => p.capitalizeFirst ?? p,
                            onChanged: (val) => setModalState(() => periodType = val ?? 'monthly'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: amountCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: "Target Amount (BDT) *"),
                            validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: startCtrl,
                            decoration: const InputDecoration(labelText: "Start Date (YYYY-MM-DD)"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: endCtrl,
                            decoration: const InputDecoration(labelText: "End Date (YYYY-MM-DD)"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
                              'title': titleCtrl.text.trim(),
                              if (assignedUserId != null) 'user_id': assignedUserId,
                              'target_type': targetType,
                              'period_type': periodType,
                              'start_date': startCtrl.text.trim(),
                              'end_date': endCtrl.text.trim(),
                              'target_amount': double.tryParse(amountCtrl.text) ?? 0,
                            };
                            final ok = await controller.createTarget(body);
                            if (ok && ctx.mounted) Navigator.pop(ctx);
                          }
                        },
                        child: const Text("Save & Assign Target", style: TextStyle(fontWeight: FontWeight.bold)),
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

  void _showEditTargetModal(BuildContext context, ManagerSalesTargetModel t) {
    final formKey = GlobalKey<FormState>();
    final titleCtrl = TextEditingController(text: t.title);
    final amountCtrl = TextEditingController(text: t.targetAmount.toStringAsFixed(0));
    String status = t.status;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Edit Target", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const Divider(),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(labelText: "Target Title"),
                      validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: amountCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Target Amount (BDT)"),
                    ),
                    const SizedBox(height: 10),
                    CustomDropdownField<String>(
                      label: "Status",
                      sheetTitle: "Select Status",
                      searchable: false,
                      value: status,
                      items: const ['active', 'completed', 'cancelled'],
                      itemLabelBuilder: (s) => s.capitalizeFirst ?? s,
                      onChanged: (val) => setModalState(() => status = val ?? 'active'),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final body = {
                              'title': titleCtrl.text.trim(),
                              'target_amount': double.tryParse(amountCtrl.text) ?? t.targetAmount,
                              'status': status,
                            };
                            final ok = await controller.updateTarget(t.id, body);
                            if (ok && ctx.mounted) Navigator.pop(ctx);
                          }
                        },
                        child: const Text("Save Changes"),
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
