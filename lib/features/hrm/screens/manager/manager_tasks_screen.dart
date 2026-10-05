import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:auth_ui_app/common/widgets/app_page_header.dart';
import 'package:auth_ui_app/common/widgets/form_fields/form_fields.dart';
import 'package:auth_ui_app/features/hrm/controllers/controllers.dart';
import 'package:auth_ui_app/features/hrm/models/manager_models.dart';
import 'package:auth_ui_app/features/hrm/models/task_model.dart';

class ManagerTasksScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const ManagerTasksScreen({super.key, this.onBack});

  @override
  State<ManagerTasksScreen> createState() => _ManagerTasksScreenState();
}

class _ManagerTasksScreenState extends State<ManagerTasksScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ManagerTaskController controller = ManagerTaskController.instance;
  final ManagerEmployeeController empController = ManagerEmployeeController.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    controller.fetchCompletions();
    controller.fetchBranchTasks();
    controller.fetchReport();
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
        onPressed: () => _showCreateBranchTaskModal(context),
        backgroundColor: const Color(0xFF2563EB),
        icon: const Icon(Icons.add_task_rounded, color: Colors.white),
        label: const Text("New Task", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            AppPageHeader(
              title: "Daily Branch Tasks",
              onBack: widget.onBack ?? () => Navigator.of(context).maybePop(),
              action: AppHeaderActionBadge.refresh(
                onTap: () {
                  controller.fetchCompletions();
                  controller.fetchBranchTasks();
                  controller.fetchReport();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              child: Obx(() => CustomSegmentedTabBar(
                    controller: _tabController,
                    tabs: [
                      SegmentTab(
                        label: "Submissions",
                        icon: const Icon(Iconsax.task_square),
                        badgeCount: controller.pendingCount.value,
                      ),
                      SegmentTab(
                        label: "Branch Tasks",
                        icon: const Icon(Iconsax.setting_2),
                        badgeCount: controller.branchTasks.length,
                      ),
                      const SegmentTab(
                        label: "Analytics",
                        icon: Icon(Iconsax.chart_2),
                      ),
                    ],
                  )),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSubmissionsTab(),
                  _buildBranchTasksTab(),
                  _buildAnalyticsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // TAB 1: TASK SUBMISSIONS REVIEW BOARD
  // =========================================================================
  Widget _buildSubmissionsTab() {
    return RefreshIndicator(
      onRefresh: () => controller.fetchCompletions(),
      color: const Color(0xFF2563EB),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 90),
        child: Obx(() {
          final completions = controller.filteredCompletions;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCounters(),
              const SizedBox(height: 14),
              _buildFilterChips(),
              const SizedBox(height: 14),

              if (controller.isLoading.value && completions.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: CircularProgressIndicator(color: Color(0xFF2563EB)),
                  ),
                )
              else if (completions.isEmpty)
                _buildEmptyState()
              else
                ...completions.map((item) => _buildCompletionReviewCard(item)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSummaryCounters() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            _buildStatBadge("Needs Review", "${controller.pendingCount.value}", const Color(0xFFD97706), const Color(0xFFFEF3C7)),
            const SizedBox(width: 8),
            _buildStatBadge("Approved", "${controller.approvedCount.value}", const Color(0xFF059669), const Color(0xFFDCFCE7)),
            const SizedBox(width: 8),
            _buildStatBadge("Rejected", "${controller.rejectedCount.value}", const Color(0xFFDC2626), const Color(0xFFFEE2E2)),
          ],
        ),
      );
    });
  }

  Widget _buildStatBadge(String label, String count, Color color, Color bg) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Text(count, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'completed', 'approved', 'rejected'];
    final labels = ['All Tasks', 'Needs Review', 'Approved', 'Rejected'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(filters.length, (index) {
          final filter = filters[index];
          final label = labels[index];
          final isSelected = controller.selectedStatusFilter.value == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) controller.setStatusFilter(filter);
              },
              selectedColor: const Color(0xFF2563EB),
              labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Iconsax.task, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            const Text(
              "No task submissions found",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 4),
            const Text(
              "Submissions from clocked-in employees will appear here",
              style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionReviewCard(ManagerTaskCompletionModel item) {
    final isPending = item.status == 'completed' || item.status == 'pending';
    final isApproved = item.status == 'approved';

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
      margin: const EdgeInsets.only(bottom: 12),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFFEFF6FF),
                    child: Text(
                      item.employeeName.isNotEmpty ? item.employeeName[0] : 'S',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.employeeName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      if (item.branchName != null)
                        Text(item.branchName!, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(6)),
                child: Text(
                  isPending ? "Needs Review" : item.status.capitalizeFirst ?? 'Completed',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Task Name
          Text(
            item.taskName,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          if (item.notes != null && item.notes!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(6)),
              child: Text(
                "Staff Notes: ${item.notes}",
                style: const TextStyle(fontSize: 11, color: Color(0xFF475569)),
              ),
            ),
          ],
          if (item.managerComment != null && item.managerComment!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              "Manager Feedback: ${item.managerComment}",
              style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF2563EB)),
            ),
          ],

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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.close_rounded, size: 14),
                  label: const Text("Reject", style: TextStyle(fontSize: 12)),
                  onPressed: () => _showTaskReviewCommentDialog(context, item, isApprove: false),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.check_rounded, size: 14),
                  label: const Text("Approve", style: TextStyle(fontSize: 12)),
                  onPressed: () => _showTaskReviewCommentDialog(context, item, isApprove: true),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showTaskReviewCommentDialog(BuildContext context, ManagerTaskCompletionModel item, {required bool isApprove}) {
    final commentCtrl = TextEditingController(text: isApprove ? "Verified & Approved" : "Needs rework");

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          isApprove ? "Approve Task Submission" : "Reject Task Submission",
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
            Text("Task: ${item.taskName}", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            Text("By: ${item.employeeName}", style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
            const SizedBox(height: 12),
            TextField(
              controller: commentCtrl,
              decoration: const InputDecoration(
                labelText: "Manager Feedback / Comment",
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isApprove ? const Color(0xFF059669) : const Color(0xFFDC2626),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              if (isApprove) {
                await controller.approveTask(item.id, comment: commentCtrl.text.trim());
              } else {
                await controller.rejectTask(item.id, comment: commentCtrl.text.trim());
              }
            },
            child: Text(isApprove ? "Approve" : "Reject"),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // TAB 2: BRANCH TASKS CRUD LIST
  // =========================================================================
  Widget _buildBranchTasksTab() {
    return Obx(() {
      if (controller.isLoadingBranchTasks.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(color: Color(0xFF2563EB)),
          ),
        );
      }

      final tasks = controller.branchTasks;

      if (tasks.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Iconsax.task, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              const Text(
                "No branch tasks configured",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 4),
              const Text(
                "Tap '+ New Task' to create daily branch tasks for employees",
                style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.fetchBranchTasks(),
        color: const Color(0xFF2563EB),
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 90),
          itemCount: tasks.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final task = tasks[index];
            return _buildBranchTaskCrudCard(task);
          },
        ),
      );
    });
  }

  Widget _buildBranchTaskCrudCard(ManagerBranchTaskCrudModel task) {
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
                child: Text(
                  task.taskName,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: task.isActive ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  task.isActive ? "Active" : "Inactive",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: task.isActive ? const Color(0xFF059669) : const Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
          if (task.description != null && task.description!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              task.description!,
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
          ],
          if (task.branchName != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Iconsax.building, size: 12, color: Color(0xFF94A3B8)),
                const SizedBox(width: 4),
                Text(task.branchName!, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
              ],
            ),
          ],

          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), minimumSize: Size.zero),
                icon: const Icon(Iconsax.edit_2, size: 14, color: Color(0xFF2563EB)),
                label: const Text("Edit", style: TextStyle(fontSize: 11, color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
                onPressed: () => _showEditBranchTaskModal(context, task),
              ),
              const SizedBox(width: 8),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Iconsax.trash, size: 16, color: Color(0xFF94A3B8)),
                onPressed: () => _confirmDeleteBranchTask(context, task),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // CREATE / EDIT BRANCH TASK MODALS
  // =========================================================================
  void _showCreateBranchTaskModal(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    int? branchId = empController.options.value?.branches.isNotEmpty == true
        ? empController.options.value!.branches.first.id
        : null;
    bool isActive = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Container(
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
                  const Text("Create Daily Branch Task", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const Divider(height: 20),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      label: "Task Title",
                      hintText: "e.g. Morning Counter Inspection",
                      controller: titleCtrl,
                      prefixIcon: const Icon(Icons.assignment_outlined, size: 18, color: Color(0xFF64748B)),
                      isRequired: true,
                      validator: (v) => (v == null || v.trim().isEmpty) ? "Task title is required" : null,
                    ),
                    const SizedBox(height: 12),
                    CustomTextArea(
                      label: "Description / Checklist",
                      hintText: "Enter daily task requirements or checklist...",
                      controller: descCtrl,
                      minLines: 2,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 12),
                    if (empController.options.value?.branches.isNotEmpty == true)
                      CustomDropdownField<int>(
                        label: "Assign to Branch",
                        value: branchId,
                        prefixIcon: const Icon(Icons.business_outlined, size: 18, color: Color(0xFF64748B)),
                        items: empController.options.value!.branches.map((b) => b.id).toList(),
                        itemLabelBuilder: (id) => empController.options.value!.branches.firstWhere((b) => b.id == id).name,
                        onChanged: (val) => setModalState(() => branchId = val),
                      ),
                    const SizedBox(height: 12),
                    CustomSwitchTile(
                      title: "Task Active for Staff",
                      subtitle: "When enabled, clocked-in staff will see this task",
                      value: isActive,
                      isCard: true,
                      onChanged: (val) => setModalState(() => isActive = val),
                    ),
                    const SizedBox(height: 20),
                    Obx(() => CustomButton(
                          text: "Save & Publish Task",
                          variant: CustomButtonVariant.primary,
                          isLoading: controller.isLoading.value,
                          icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              final body = {
                                'task_name': titleCtrl.text.trim(),
                                if (descCtrl.text.isNotEmpty) 'description': descCtrl.text.trim(),
                                if (branchId != null) 'branch_id': branchId,
                                'is_active': isActive ? 1 : 0,
                              };
                              final ok = await controller.createBranchTask(body);
                              if (ok && ctx.mounted) Navigator.pop(ctx);
                            }
                          },
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditBranchTaskModal(BuildContext context, ManagerBranchTaskCrudModel task) {
    final formKey = GlobalKey<FormState>();
    final titleCtrl = TextEditingController(text: task.taskName);
    final descCtrl = TextEditingController(text: task.description ?? '');
    bool isActive = task.isActive;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.edit_note, color: Color(0xFF2563EB), size: 18),
                      ),
                      const SizedBox(width: 10),
                      const Text("Edit Branch Task", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  IconButton(icon: const Icon(Icons.close, color: Color(0xFF64748B)), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const Divider(height: 20),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      label: "Task Title",
                      controller: titleCtrl,
                      isRequired: true,
                      validator: (v) => (v == null || v.trim().isEmpty) ? "Required" : null,
                    ),
                    const SizedBox(height: 12),
                    CustomTextArea(
                      label: "Description",
                      controller: descCtrl,
                      minLines: 2,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 12),
                    CustomSwitchTile(
                      title: "Task Active",
                      subtitle: "Toggle task visibility for employee shifts",
                      value: isActive,
                      isCard: true,
                      onChanged: (val) => setModalState(() => isActive = val),
                    ),
                    const SizedBox(height: 20),
                    Obx(() => CustomButton(
                          text: "Save Task Changes",
                          variant: CustomButtonVariant.primary,
                          isLoading: controller.isLoading.value,
                          icon: const Icon(Icons.save_outlined, color: Colors.white, size: 18),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              final body = {
                                'task_name': titleCtrl.text.trim(),
                                'description': descCtrl.text.trim(),
                                'is_active': isActive ? 1 : 0,
                              };
                              final ok = await controller.updateBranchTask(task.id, body);
                              if (ok && ctx.mounted) Navigator.pop(ctx);
                            }
                          },
                        )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

  void _confirmDeleteBranchTask(BuildContext context, ManagerBranchTaskCrudModel task) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete Branch Task?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Text("Are you sure you want to delete '${task.taskName}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(ctx);
              await controller.deleteBranchTask(task.id);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // TAB 3: MANAGER TASK ANALYTICS & MONITORING REPORT
  // =========================================================================
  Widget _buildAnalyticsTab() {
    return RefreshIndicator(
      onRefresh: () => controller.fetchReport(),
      color: const Color(0xFF2563EB),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 90),
        child: Obx(() {
          if (controller.isLoadingReport.value && controller.report.value == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: CircularProgressIndicator(color: Color(0xFF2563EB)),
              ),
            );
          }

          final reportData = controller.report.value;
          final summary = reportData?.summary;
          final employees = reportData?.employees ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Month Selector Header
              _buildReportMonthSelector(),
              const SizedBox(height: 14),

              // Overview Summary Grid
              if (summary != null) ...[
                _buildReportOverviewGrid(summary),
                const SizedBox(height: 18),
              ],

              // Employee Performance List Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Employee Task Performance (${employees.length})",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              if (employees.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        Icon(Iconsax.note_remove, size: 40, color: Colors.grey[400]),
                        const SizedBox(height: 8),
                        const Text(
                          "No employee task analytics for this period",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...employees.map((emp) => _buildEmployeeTaskReportCard(emp)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildReportMonthSelector() {
    final currentMonthDate = DateTime(controller.selectedReportYear.value, controller.selectedReportMonth.value);
    final monthName = "${_getMonthName(currentMonthDate.month)} ${currentMonthDate.year}";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              final prev = DateTime(controller.selectedReportYear.value, controller.selectedReportMonth.value - 1);
              controller.fetchReport(month: prev.month, year: prev.year);
            },
            icon: const Icon(Icons.chevron_left_rounded, color: Color(0xFF1E293B)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Row(
            children: [
              const Icon(Iconsax.calendar_1, size: 16, color: Color(0xFF2563EB)),
              const SizedBox(width: 8),
              Text(
                monthName,
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              final next = DateTime(controller.selectedReportYear.value, controller.selectedReportMonth.value + 1);
              controller.fetchReport(month: next.month, year: next.year);
            },
            icon: const Icon(Icons.chevron_right_rounded, color: Color(0xFF1E293B)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  Widget _buildReportOverviewGrid(ManagerTaskReportSummaryModel summary) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Organization Task Summary",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "${summary.totalEmployeesMonitored} Staff Monitored",
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF2563EB)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildReportStatBox("Completions", "${summary.totalCompletions}", const Color(0xFF2563EB), const Color(0xFFEFF6FF)),
              const SizedBox(width: 8),
              _buildReportStatBox("Approved", "${summary.totalApproved}", const Color(0xFF059669), const Color(0xFFDCFCE7)),
              const SizedBox(width: 8),
              _buildReportStatBox("Pending", "${summary.totalPendingReview}", const Color(0xFFD97706), const Color(0xFFFEF3C7)),
              const SizedBox(width: 8),
              _buildReportStatBox("Rejected", "${summary.totalRejected}", const Color(0xFFDC2626), const Color(0xFFFEE2E2)),
            ],
          ),
          if (summary.totalAdditionalTasksCreated > 0) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E8FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.add_task_rounded, size: 14, color: Color(0xFF7C3AED)),
                  const SizedBox(width: 6),
                  Text(
                    "${summary.totalAdditionalTasksCreated} Ad-Hoc / Additional duties logged by team",
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF7C3AED)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReportStatBox(String label, String value, Color color, Color bg) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeTaskReportCard(ManagerTaskReportEmployeeModel emp) {
    final double approvalRate = emp.totalCompletions > 0 ? (emp.approvedCount / emp.totalCompletions) : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFFEFF6FF),
                    child: Text(
                      emp.name.isNotEmpty ? emp.name[0] : 'E',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(emp.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      Text(
                        "${emp.department ?? 'Staff'} • ${emp.branch ?? 'Main Branch'}",
                        style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "${emp.totalCompletions} Completed",
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Mini metrics row
          Row(
            children: [
              _buildEmpMiniTag("Approved: ${emp.approvedCount}", const Color(0xFF059669), const Color(0xFFDCFCE7)),
              const SizedBox(width: 6),
              _buildEmpMiniTag("Pending: ${emp.pendingReviewCount}", const Color(0xFFD97706), const Color(0xFFFEF3C7)),
              const SizedBox(width: 6),
              if (emp.rejectedCount > 0) ...[
                _buildEmpMiniTag("Rejected: ${emp.rejectedCount}", const Color(0xFFDC2626), const Color(0xFFFEE2E2)),
                const SizedBox(width: 6),
              ],
              if (emp.additionalTasksLogged > 0)
                _buildEmpMiniTag("+${emp.additionalTasksLogged} Ad-Hoc", const Color(0xFF7C3AED), const Color(0xFFF3E8FF)),
            ],
          ),
          const SizedBox(height: 8),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: approvalRate,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpMiniTag(String text, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4)),
      child: Text(
        text,
        style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  }
}
