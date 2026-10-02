import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:auth_ui_app/features/hrm/controllers/controllers.dart';
import 'package:auth_ui_app/features/hrm/models/task_model.dart';
import 'package:auth_ui_app/features/hrm/screens/staff/staff_attendance_screen.dart';

class TasksScreen extends StatefulWidget {
  final VoidCallback? onBackToDashboard;

  const TasksScreen({super.key, this.onBackToDashboard});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TaskController controller = TaskController.instance;
  int _activeTabIndex = 0; // 0 = Daily Tasks, 1 = General Tasks, 2 = History

  @override
  void initState() {
    super.initState();
    controller.refreshAll();
  }

  @override
  Widget build(BuildContext context) {
    if (_activeTabIndex == 2) return _buildHistoryView();
    if (_activeTabIndex == 1) return _buildGeneralTasksView();
    return _buildTodayView();
  }

  // =========================================================================
  // VIEW 1: TODAY'S BRANCH TASKS (CLOCK-IN GATED)
  // =========================================================================
  Widget _buildTodayView() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshAll,
          color: const Color(0xFF2563EB),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Obx(() {
              final todayRes = controller.todayResponse.value;
              final isClockedIn = todayRes?.isClockedIn ?? AttendanceController.instance.todayStatus.value?.isClockedIn ?? false;
              final tasks = controller.todayTasks;
              final summary = controller.taskSummary.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header
                  _buildTopHeader(),
                  const SizedBox(height: 16),

                  // Segmented Tabs (Today / History)
                  _buildSegmentedTabs(),
                  const SizedBox(height: 16),

                  if (controller.isLoadingToday.value && tasks.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 60),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (!isClockedIn)
                    // CLOCK-IN GATING NOTIFICATION & EMPTY STATE
                    _buildClockInGatedCard(todayRes?.message)
                  else ...[
                    // Branch Task Summary & Progress Header
                    if (summary != null) _buildBranchSummaryCard(todayRes, summary),
                    const SizedBox(height: 16),

                    // Daily Tasks Section Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Today's Assigned Tasks (${tasks.length})",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        if (summary != null)
                          Text(
                            "${summary.progressPercentage}% Completed",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Tasks List
                    if (tasks.isEmpty)
                      _buildEmptyTasksCard()
                    else
                      ...tasks.map((task) => _buildTaskItemCard(task)),
                  ],

                  const SizedBox(height: 30),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // TOP HEADER
  // =========================================================================
  Widget _buildTopHeader() {
    final todayFormatted = DateFormat('EEEE, dd MMMM').format(DateTime.now());

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (widget.onBackToDashboard != null)
              IconButton(
                onPressed: widget.onBackToDashboard,
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF1E293B)),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              )
            else
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Iconsax.task_square, size: 20, color: Color(0xFF2563EB)),
              ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Branch Tasks",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  todayFormatted,
                  style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),

        // History Toggle Button
        InkWell(
          onTap: () {
            controller.fetchHistory();
            setState(() => _activeTabIndex = 2);
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Row(
              children: [
                Icon(Iconsax.document_text, size: 15, color: Color(0xFF2563EB)),
                SizedBox(width: 6),
                Text(
                  "History",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // SEGMENTED TABS
  // =========================================================================
  Widget _buildSegmentedTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _buildTabItem(0, "Daily Tasks"),
          _buildTabItem(1, "General Tasks"),
          _buildTabItem(2, "Task History"),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    final isSelected = _activeTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (index == 2) controller.fetchHistory();
          setState(() => _activeTabIndex = index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // CLOCK-IN GATED EMPTY STATE
  // =========================================================================
  Widget _buildClockInGatedCard(String? customMessage) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFDBEAFE), width: 2),
            ),
            child: const Center(
              child: Icon(Iconsax.lock, color: Color(0xFF2563EB), size: 30),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Clock In Required",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            customMessage ?? "You must clock in first to access and complete your daily branch tasks.",
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF64748B),
              height: 1.35,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => Get.to(() => const AttendanceScreen()),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF059669),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            icon: const Icon(Icons.location_on_rounded, size: 16),
            label: const Text(
              "Go to Clock In",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // BRANCH SUMMARY CARD
  // =========================================================================
  Widget _buildBranchSummaryCard(TodayTasksResponse? response, TaskSummaryModel summary) {
    final branchName = response?.branchName ?? "Assigned Branch";

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 5),
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
                  const Icon(Iconsax.building, size: 16, color: Colors.white70),
                  const SizedBox(width: 6),
                  Text(
                    branchName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "ACTIVE SHIFT",
                  style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Progress Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Daily Completion Progress",
                style: TextStyle(fontSize: 11.5, color: Colors.white70, fontWeight: FontWeight.w600),
              ),
              Text(
                "${summary.completedTasks} / ${summary.totalTasks} Tasks",
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: summary.totalTasks > 0 ? summary.completedTasks / summary.totalTasks : 0.0,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF34D399)),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // TASK ITEM CARD
  // =========================================================================
  Widget _buildTaskItemCard(BranchTaskModel task) {
    final isDone = task.isCompleted;
    final isApproved = task.status == 'approved';
    final isRejected = task.status == 'rejected';
    final isByOther = task.completedByOther;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isApproved
              ? const Color(0xFF86EFAC)
              : (isRejected
                  ? const Color(0xFFFCA5A5)
                  : (isDone ? const Color(0xFFE2E8F0) : const Color(0xFFE2E8F0))),
          width: isApproved || isRejected ? 1.5 : 1,
        ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Interactive Checkbox / Status Circle
              GestureDetector(
                onTap: task.canToggle ? () => _showTaskCompletionSheet(task) : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 26,
                  height: 26,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    color: isDone
                        ? (isApproved
                            ? const Color(0xFF059669)
                            : (isByOther ? const Color(0xFF64748B) : const Color(0xFF2563EB)))
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDone ? Colors.transparent : const Color(0xFFCBD5E1),
                      width: 2,
                    ),
                  ),
                  child: isDone
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: 12),

              // Task Title & Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.taskName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: isDone ? const Color(0xFF475569) : const Color(0xFF0F172A),
                        decoration: isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (task.description != null && task.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description!,
                        style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B), height: 1.3),
                      ),
                    ],
                  ],
                ),
              ),

              // Status Badges
              if (isApproved)
                _buildBadge("Approved", const Color(0xFF059669), const Color(0xFFDCFCE7))
              else if (isRejected)
                _buildBadge("Rejected", const Color(0xFFDC2626), const Color(0xFFFEE2E2))
              else if (isByOther)
                _buildBadge("Done by ${task.completedByName ?? 'Other'}", const Color(0xFF64748B), const Color(0xFFF1F5F9))
              else if (isDone)
                _buildBadge("Completed", const Color(0xFF2563EB), const Color(0xFFEFF6FF)),
            ],
          ),

          // Completion Notes / Manager Comment Box
          if (task.notes != null && task.notes!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(Iconsax.note_text, size: 14, color: Color(0xFF64748B)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Note: ${task.notes!}",
                      style: const TextStyle(fontSize: 11, color: Color(0xFF475569), fontStyle: FontStyle.italic),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (task.managerComment != null && task.managerComment!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isApproved ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isApproved ? const Color(0xFFBBF7D0) : const Color(0xFFFECACA)),
              ),
              child: Row(
                children: [
                  Icon(
                    isApproved ? Icons.verified_rounded : Icons.info_outline,
                    size: 14,
                    color: isApproved ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Manager: ${task.managerComment!}",
                      style: TextStyle(
                        fontSize: 11,
                        color: isApproved ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: textColor),
      ),
    );
  }

  // =========================================================================
  // TASK COMPLETION BOTTOM SHEET
  // =========================================================================
  void _showTaskCompletionSheet(BranchTaskModel task) {
    final notesController = TextEditingController(text: task.notes ?? "");

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    task.isCompleted ? "Update / Revert Task" : "Complete Branch Task",
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                task.taskName,
                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF2563EB)),
              ),
              if (task.description != null) ...[
                const SizedBox(height: 4),
                Text(task.description!, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ],
              const SizedBox(height: 16),

              const Text(
                "Completion Notes (Optional)",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF334155)),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "e.g. Checked all displays, restocked shelves...",
                  hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    controller.toggleTask(task, notes: notesController.text.trim());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: task.isCompleted ? const Color(0xFFDC2626) : const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    task.isCompleted ? "Revert to Pending" : "Submit Completion",
                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildEmptyTasksCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Column(
        children: [
          Icon(Iconsax.task, size: 48, color: Color(0xFF94A3B8)),
          SizedBox(height: 12),
          Text(
            "No tasks scheduled for today",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
          SizedBox(height: 4),
          Text(
            "All branch tasks are up to date.",
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // VIEW 2: STAFF PERSONAL TASK HISTORY
  // =========================================================================
  Widget _buildHistoryView() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => controller.fetchHistory(),
          color: const Color(0xFF2563EB),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Obx(() {
              final items = controller.filteredHistory;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // History Top Header
                  _buildHistoryTopBar(),
                  const SizedBox(height: 16),

                  // Month Selector
                  _buildMonthSelector(),
                  const SizedBox(height: 14),

                  // Filter Chips (All, Completed, Approved, Rejected)
                  _buildHistoryFilterChips(),
                  const SizedBox(height: 16),

                  if (controller.isLoadingHistory.value)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (items.isEmpty)
                    _buildEmptyHistoryState()
                  else
                    ...items.map((item) => _buildHistoryItemCard(item)),

                  const SizedBox(height: 30),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => setState(() => _activeTabIndex = 0),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF1E293B)),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Task History",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF0F172A), letterSpacing: -0.3),
                ),
                SizedBox(height: 2),
                Text("Your completed tasks & approvals", style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () => controller.fetchHistory(),
          icon: const Icon(Icons.refresh_rounded, color: Color(0xFF2563EB)),
        ),
      ],
    );
  }

  Widget _buildMonthSelector() {
    final currentMonthDate = DateTime(controller.selectedYear.value, controller.selectedMonth.value);
    final monthName = DateFormat('MMMM yyyy').format(currentMonthDate);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              final prev = DateTime(controller.selectedYear.value, controller.selectedMonth.value - 1);
              controller.changeMonth(prev.month, prev.year);
            },
            icon: const Icon(Icons.chevron_left_rounded, color: Color(0xFF1E293B)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Row(
            children: [
              const Icon(Iconsax.calendar_2, size: 18, color: Color(0xFF2563EB)),
              const SizedBox(width: 8),
              Text(
                monthName,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              final next = DateTime(controller.selectedYear.value, controller.selectedMonth.value + 1);
              controller.changeMonth(next.month, next.year);
            },
            icon: const Icon(Icons.chevron_right_rounded, color: Color(0xFF1E293B)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryFilterChips() {
    final filters = ['All', 'completed', 'approved', 'rejected'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: filters.map((f) {
          final isSelected = controller.selectedFilter.value.toLowerCase() == f.toLowerCase();
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(f.capitalizeFirst ?? f),
              selected: isSelected,
              onSelected: (_) => controller.setFilter(f),
              selectedColor: const Color(0xFF2563EB),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHistoryItemCard(TaskHistoryItemModel item) {
    final isApproved = item.status == 'approved';
    final isRejected = item.status == 'rejected';
    final Color badgeColor = isApproved ? const Color(0xFF059669) : (isRejected ? const Color(0xFFDC2626) : const Color(0xFF2563EB));
    final Color badgeBg = isApproved ? const Color(0xFFDCFCE7) : (isRejected ? const Color(0xFFFEE2E2) : const Color(0xFFEFF6FF));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
              Text(
                item.date,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
              ),
              _buildBadge(item.status.toUpperCase(), badgeColor, badgeBg),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.taskName,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
          if (item.taskDescription != null) ...[
            const SizedBox(height: 4),
            Text(item.taskDescription!, style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
          ],
          if (item.notes != null && item.notes!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text("Notes: ${item.notes!}", style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF475569))),
          ],
          if (item.managerComment != null && item.managerComment!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text("Manager Feedback: ${item.managerComment!}", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: badgeColor)),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyHistoryState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Column(
        children: [
          Icon(Iconsax.note_remove, size: 48, color: Color(0xFF94A3B8)),
          SizedBox(height: 12),
          Text(
            "No task history found",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
          SizedBox(height: 4),
          Text(
            "There are no recorded task completions for this period.",
            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // VIEW 3: GENERAL TASKS (TASK MANAGEMENT MODULE SYNC)
  // =========================================================================
  Widget _buildGeneralTasksView() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopHeader(),
              const SizedBox(height: 16),
              _buildSegmentedTabs(),
              const SizedBox(height: 16),

              // Task Management Sync Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Iconsax.task, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Task Management Integration",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                          SizedBox(height: 3),
                          Text(
                            "Project deadlines, departmental workflows, and sprint tasks will sync directly from Task Management.",
                            style: TextStyle(fontSize: 11.5, color: Colors.white70, height: 1.3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ongoing Workflows & Projects",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Sample Workflow Task Cards
              _buildWorkflowTaskCard(
                title: "Client Onboarding Document Review",
                project: "Operations",
                priority: "High",
                priorityColor: const Color(0xFFDC2626),
                priorityBg: const Color(0xFFFEE2E2),
                dueDate: "Due Tomorrow, 5:00 PM",
                progress: 0.75,
              ),
              _buildWorkflowTaskCard(
                title: "Q4 Performance Milestone Tracking",
                project: "Sales & Marketing",
                priority: "Medium",
                priorityColor: const Color(0xFFD97706),
                priorityBg: const Color(0xFFFEF3C7),
                dueDate: "Due Oct 15, 2026",
                progress: 0.40,
              ),
              _buildWorkflowTaskCard(
                title: "Monthly Expense Receipt Verification",
                project: "Finance & Admin",
                priority: "Normal",
                priorityColor: const Color(0xFF2563EB),
                priorityBg: const Color(0xFFEFF6FF),
                dueDate: "Due Oct 20, 2026",
                progress: 0.15,
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkflowTaskCard({
    required String title,
    required String project,
    required String priority,
    required Color priorityColor,
    required Color priorityBg,
    required String dueDate,
    required double progress,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  project.toUpperCase(),
                  style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: Color(0xFF475569)),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: priorityBg, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  priority,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: priorityColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.access_time_rounded, size: 13, color: Color(0xFF94A3B8)),
              const SizedBox(width: 4),
              Text(
                dueDate,
                style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
