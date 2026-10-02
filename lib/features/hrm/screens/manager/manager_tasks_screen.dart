import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:auth_ui_app/features/hrm/controllers/controllers.dart';
import 'package:auth_ui_app/features/hrm/models/manager_models.dart';
import 'package:auth_ui_app/features/hrm/models/task_model.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

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
    _tabController = TabController(length: 2, vsync: this);
    controller.fetchCompletions();
    controller.fetchBranchTasks();
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
            Text(
              "Daily Branch Tasks",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            Text(
              "Task Verification & Branch Task CRUD",
              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF2563EB)),
            tooltip: "Refresh",
            onPressed: () {
              controller.fetchCompletions();
              controller.fetchBranchTasks();
            },
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
                      const Icon(Iconsax.task_square, size: 16),
                      const SizedBox(width: 6),
                      Text("Submissions (${controller.pendingCount.value})"),
                    ],
                  ),
                )),
            Obx(() => Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Iconsax.setting_2, size: 16),
                      const SizedBox(width: 6),
                      Text("Branch Tasks (${controller.branchTasks.length})"),
                    ],
                  ),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateBranchTaskModal(context),
        backgroundColor: const Color(0xFF2563EB),
        icon: const Icon(Icons.add_task_rounded, color: Colors.white),
        label: const Text("New Task", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSubmissionsTab(),
          _buildBranchTasksTab(),
        ],
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
              const Divider(),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(labelText: "Task Title *", prefixIcon: Icon(Iconsax.task)),
                      validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: descCtrl,
                      decoration: const InputDecoration(labelText: "Description / Checklist", prefixIcon: Icon(Iconsax.note)),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    if (empController.options.value?.branches.isNotEmpty == true)
                      DropdownButtonFormField<int>(
                        value: branchId,
                        decoration: const InputDecoration(labelText: "Branch", prefixIcon: Icon(Iconsax.building)),
                        items: empController.options.value!.branches
                            .map((b) => DropdownMenuItem(value: b.id, child: Text(b.name)))
                            .toList(),
                        onChanged: (val) => setModalState(() => branchId = val),
                      ),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      title: const Text("Task Active for Staff", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      value: isActive,
                      activeColor: const Color(0xFF2563EB),
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setModalState(() => isActive = val),
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
                              'task_name': titleCtrl.text.trim(),
                              if (descCtrl.text.isNotEmpty) 'description': descCtrl.text.trim(),
                              if (branchId != null) 'branch_id': branchId,
                              'is_active': isActive ? 1 : 0,
                            };
                            final ok = await controller.createBranchTask(body);
                            if (ok && ctx.mounted) Navigator.pop(ctx);
                          }
                        },
                        child: const Text("Save & Publish Task", style: TextStyle(fontWeight: FontWeight.bold)),
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

  void _showEditBranchTaskModal(BuildContext context, ManagerBranchTaskCrudModel task) {
    final formKey = GlobalKey<FormState>();
    final titleCtrl = TextEditingController(text: task.taskName);
    final descCtrl = TextEditingController(text: task.description ?? '');
    int? branchId = task.branchId;
    bool isActive = task.isActive;

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
                  const Text("Edit Branch Task", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
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
                      decoration: const InputDecoration(labelText: "Task Title *"),
                      validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: descCtrl,
                      decoration: const InputDecoration(labelText: "Description"),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      title: const Text("Task Active", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      value: isActive,
                      activeColor: const Color(0xFF2563EB),
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) => setModalState(() => isActive = val),
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
                              'task_name': titleCtrl.text.trim(),
                              'description': descCtrl.text.trim(),
                              'is_active': isActive ? 1 : 0,
                            };
                            final ok = await controller.updateBranchTask(task.id, body);
                            if (ok && ctx.mounted) Navigator.pop(ctx);
                          }
                        },
                        child: const Text("Save Changes", style: TextStyle(fontWeight: FontWeight.bold)),
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
}
