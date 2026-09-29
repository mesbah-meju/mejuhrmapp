import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:auth_ui_app/services/sync_controller.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class TasksScreen extends StatefulWidget {
  final VoidCallback? onBackToDashboard;

  const TasksScreen({super.key, this.onBackToDashboard});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  bool _showingHistory = false;
  String _selectedTab = 'Today'; // 'Today', 'Upcoming', 'Overdue'
  String _selectedHistoryFilter = 'All'; // 'All', 'Completed', 'Pending', 'Overdue'
  String _selectedDateRange = '01 Sep 2026 - 28 Sep 2026';

  // Today's Tasks
  final List<Map<String, dynamic>> _todayTasks = [
    {
      'id': 1,
      'title': 'Client Follow-up Calls',
      'subtitle': 'Call 5 potential clients from lead list',
      'time': '09:00 AM',
      'category': 'Sales',
      'categoryIcon': Icons.phone_outlined,
      'completed': true,
      'overdue': false,
    },
    {
      'id': 2,
      'title': 'Prepare Sales Report',
      'subtitle': 'Generate and share weekly report',
      'time': '11:00 AM',
      'category': 'Reporting',
      'categoryIcon': Icons.description_outlined,
      'completed': false,
      'overdue': false,
    },
    {
      'id': 3,
      'title': 'Team Meeting',
      'subtitle': 'Discuss Q3 targets and progress',
      'time': '02:00 PM',
      'category': 'Meeting',
      'categoryIcon': Icons.people_outline_rounded,
      'completed': false,
      'overdue': false,
    },
    {
      'id': 4,
      'title': 'Update CRM',
      'subtitle': 'Add new leads and update status',
      'time': '04:00 PM',
      'category': 'CRM',
      'categoryIcon': Icons.storage_rounded,
      'completed': false,
      'overdue': false,
    },
    {
      'id': 5,
      'title': 'Send Proposal to Client',
      'subtitle': 'Send revised proposal to ABC Ltd.',
      'time': '05:00 PM',
      'category': 'Sales',
      'categoryIcon': Icons.send_outlined,
      'completed': false,
      'overdue': true,
    },
  ];

  // History Task Groups
  final List<Map<String, dynamic>> _historyGroups = [
    {
      'date': '27 Sep 2026',
      'count': '5 tasks',
      'tasks': [
        {
          'title': 'Product Demo with Client',
          'category': 'Sales',
          'categoryIcon': Icons.business_center_outlined,
          'time': '10:00 AM',
          'status': 'completed', // completed, pending, missed
        },
        {
          'title': 'Update Project Documentation',
          'category': 'Development',
          'categoryIcon': Icons.description_outlined,
          'time': '11:30 AM',
          'status': 'completed',
        },
        {
          'title': 'Follow up on Pending Payments',
          'category': 'Finance',
          'categoryIcon': Icons.currency_rupee_rounded,
          'time': '02:00 PM',
          'status': 'pending',
        },
        {
          'title': 'Team Sync Meeting',
          'category': 'Meeting',
          'categoryIcon': Icons.groups_outlined,
          'time': '04:00 PM',
          'status': 'completed',
        },
        {
          'title': 'Prepare Monthly Report',
          'category': 'Reporting',
          'categoryIcon': Icons.article_outlined,
          'time': '06:00 PM',
          'status': 'missed',
        },
      ],
    },
    {
      'date': '26 Sep 2026',
      'count': '4 tasks',
      'tasks': [
        {
          'title': 'Client Call - New Lead',
          'category': 'Sales',
          'categoryIcon': Icons.business_center_outlined,
          'time': '09:30 AM',
          'status': 'completed',
        },
        {
          'title': 'Update CRM',
          'category': 'CRM',
          'categoryIcon': Icons.storage_rounded,
          'time': '11:00 AM',
          'status': 'completed',
        },
        {
          'title': 'Design Review',
          'category': 'Design',
          'categoryIcon': Icons.palette_outlined,
          'time': '03:00 PM',
          'status': 'completed',
        },
        {
          'title': 'Send Quotation',
          'category': 'Sales',
          'categoryIcon': Icons.send_outlined,
          'time': '05:00 PM',
          'status': 'pending',
        },
      ],
    },
    {
      'date': '25 Sep 2026',
      'count': '6 tasks',
      'tasks': [
        {
          'title': 'Team Meeting',
          'category': 'Meeting',
          'categoryIcon': Icons.groups_outlined,
          'time': '10:00 AM',
          'status': 'completed',
        },
        {
          'title': 'Follow-up Calls',
          'category': 'Sales',
          'categoryIcon': Icons.phone_outlined,
          'time': '11:00 AM',
          'status': 'completed',
        },
        {
          'title': 'Update Project',
          'category': 'Development',
          'categoryIcon': Icons.description_outlined,
          'time': '02:00 PM',
          'status': 'completed',
        },
      ],
    },
  ];

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final subController = TextEditingController();
    String category = 'Sales';
    String time = '03:00 PM';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Create New Task",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Task Title",
                  hintText: "e.g. Client Follow-up Calls",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: subController,
                decoration: InputDecoration(
                  labelText: "Description / Notes",
                  hintText: "e.g. Call 5 potential leads",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (titleController.text.trim().isNotEmpty) {
                      setState(() {
                        _todayTasks.add({
                          'id': DateTime.now().millisecondsSinceEpoch,
                          'title': titleController.text.trim(),
                          'subtitle': subController.text.trim().isEmpty ? 'General task' : subController.text.trim(),
                          'time': time,
                          'category': category,
                          'categoryIcon': Icons.task_alt_rounded,
                          'completed': false,
                          'overdue': false,
                        });
                      });
                      Navigator.pop(ctx);
                      THelperFunctions.showSnackBar("Task added successfully!");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Save Task", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _showingHistory ? _buildHistoryView() : _buildTodayView();
  }

  // ==========================================
  // VIEW 1: TODAY'S TASKS VIEW
  // ==========================================
  Widget _buildTodayView() {
    final completedCount = _todayTasks.where((t) => t['completed'] == true).length;
    final overdueCount = _todayTasks.where((t) => t['overdue'] == true && t['completed'] != true).length;
    final pendingCount = _todayTasks.length - completedCount - overdueCount;
    final totalCount = _todayTasks.length;
    final progress = totalCount > 0 ? (completedCount / totalCount) : 0.0;

    List<Map<String, dynamic>> filteredTasks = _todayTasks;
    if (_selectedTab == 'Upcoming') {
      filteredTasks = _todayTasks.where((t) => t['completed'] != true && t['overdue'] != true).toList();
    } else if (_selectedTab == 'Overdue') {
      filteredTasks = _todayTasks.where((t) => t['overdue'] == true && t['completed'] != true).toList();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Title & History Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tasks",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Stay organized and get things done",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  // History Pill Button
                  InkWell(
                    onTap: () => setState(() => _showingHistory = true),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.history_rounded, size: 16, color: Color(0xFF1E293B)),
                          SizedBox(width: 5),
                          Text(
                            "History",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Segmented Tab Selector (Today / Upcoming / Overdue)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    _buildTabButton("Today"),
                    _buildTabButton("Upcoming"),
                    _buildTabButton("Overdue"),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Summary Stats Row (Donut + Done + Pending + Overdue)
              Row(
                children: [
                  // Donut Card
                  Expanded(
                    flex: 12,
                    child: Container(
                      height: 86,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(62, 62),
                            painter: _TasksDonutPainter(
                              progress: progress,
                              progressColor: const Color(0xFF059669),
                              backgroundColor: const Color(0xFFE2E8F0),
                              strokeWidth: 6,
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "$completedCount/$totalCount",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const Text(
                                "Completed",
                                style: TextStyle(
                                  fontSize: 8.5,
                                  color: Color(0xFF64748B),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Done Card
                  Expanded(
                    flex: 9,
                    child: _buildSummaryCountCard(
                      bgColor: const Color(0xFFDCFCE7),
                      count: "$completedCount",
                      countColor: const Color(0xFF059669),
                      label: "Done",
                      labelColor: const Color(0xFF059669),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Pending Card
                  Expanded(
                    flex: 9,
                    child: _buildSummaryCountCard(
                      bgColor: const Color(0xFFFEF3C7),
                      count: "$pendingCount",
                      countColor: const Color(0xFFD97706),
                      label: "Pending",
                      labelColor: const Color(0xFFD97706),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Overdue Card
                  Expanded(
                    flex: 9,
                    child: _buildSummaryCountCard(
                      bgColor: const Color(0xFFFEE2E2),
                      count: "$overdueCount",
                      countColor: const Color(0xFFDC2626),
                      label: "Overdue",
                      labelColor: const Color(0xFFDC2626),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Date Header & Add Task Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF1E293B)),
                      SizedBox(width: 6),
                      Text(
                        "Today, 28 Sep 2026",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: _showAddTaskDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                      minimumSize: const Size(0, 32),
                    ),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text(
                      "Add Task",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // List of Tasks
              ...filteredTasks.map((task) => _buildTodayTaskCard(task)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String label) {
    final isSelected = _selectedTab == label;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCountCard({
    required Color bgColor,
    required String count,
    required Color countColor,
    required String label,
    required Color labelColor,
  }) {
    return Container(
      height: 86,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: countColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: labelColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayTaskCard(Map<String, dynamic> task) {
    final isDone = task['completed'] as bool;
    final isOverdue = (task['overdue'] == true) && !isDone;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isOverdue ? const Color(0xFFFFF1F2) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOverdue ? const Color(0xFFFFE4E6) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox Toggle
          GestureDetector(
            onTap: () {
              setState(() {
                task['completed'] = !isDone;
              });
              final newStatus = !isDone;
              SyncController.instance.enqueueAction(
                actionType: 'task_status_update',
                payload: {
                  'task_id': task['id'],
                  'title': task['title'],
                  'completed': newStatus,
                  'updated_at': DateTime.now().toIso8601String(),
                },
                userMessage: newStatus ? "Task marked as Completed!" : "Task marked as Pending",
              );
            },
            child: Container(
              margin: const EdgeInsets.only(top: 2, right: 12),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isDone
                    ? const Color(0xFF059669)
                    : isOverdue
                        ? Colors.transparent
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isDone
                      ? const Color(0xFF059669)
                      : isOverdue
                          ? const Color(0xFFEF4444)
                          : const Color(0xFFCBD5E1),
                  width: 2,
                ),
              ),
              child: isDone
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),

          // Main Task Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        task['title'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDone ? const Color(0xFF64748B) : const Color(0xFF0F172A),
                          decoration: isDone ? TextDecoration.lineThrough : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Time Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDone
                            ? const Color(0xFFDCFCE7)
                            : isOverdue
                                ? const Color(0xFFFEE2E2)
                                : const Color(0xFFDBEAFE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        task['time'],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isDone
                              ? const Color(0xFF059669)
                              : isOverdue
                                  ? const Color(0xFFDC2626)
                                  : const Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  task['subtitle'],
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(task['categoryIcon'] as IconData, size: 13, color: const Color(0xFF64748B)),
                        const SizedBox(width: 4),
                        Text(
                          task['category'],
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    if (isOverdue)
                      const Row(
                        children: [
                          Icon(Icons.error_outline_rounded, size: 13, color: Color(0xFFDC2626)),
                          SizedBox(width: 4),
                          Text(
                            "Overdue",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFDC2626),
                            ),
                          ),
                        ],
                      )
                    else
                      const Icon(Icons.more_horiz_rounded, size: 18, color: Color(0xFF94A3B8)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // VIEW 2: PREVIOUS TASKS / HISTORY VIEW
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
              // Back Button & Header
              Row(
                children: [
                  IconButton(
                    onPressed: () => setState(() => _showingHistory = false),
                    icon: const Icon(Icons.chevron_left_rounded, size: 30, color: Color(0xFF0F172A)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Previous Tasks",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        "View your task history",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Filter Tabs (All / Completed / Pending / Overdue)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    _buildHistoryFilterTab("All"),
                    _buildHistoryFilterTab("Completed"),
                    _buildHistoryFilterTab("Pending"),
                    _buildHistoryFilterTab("Overdue"),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Date Range Picker & Filter Action Button
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_month_outlined, size: 16, color: Color(0xFF64748B)),
                              const SizedBox(width: 8),
                              Text(
                                _selectedDateRange,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                          const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Color(0xFF64748B)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Filter Funnel Button
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Icon(Icons.filter_list_rounded, size: 18, color: Color(0xFF1E293B)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Grouped History Days List
              ..._historyGroups.map((group) => _buildHistoryGroup(group)),
              const SizedBox(height: 16),
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

  Widget _buildHistoryGroup(Map<String, dynamic> group) {
    final List<Map<String, dynamic>> tasks = (group['tasks'] as List).cast<Map<String, dynamic>>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date & Task count Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              group['date'],
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            Text(
              group['count'],
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Tasks in Group
        ...tasks.map((t) => _buildHistoryTaskRow(t)),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildHistoryTaskRow(Map<String, dynamic> task) {
    final status = task['status'] as String; // completed, pending, missed

    Widget statusIcon;
    Color timeBg;
    Color timeColor;

    if (status == 'completed') {
      statusIcon = const Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 20);
      timeBg = const Color(0xFFDCFCE7);
      timeColor = const Color(0xFF059669);
    } else if (status == 'pending') {
      statusIcon = Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFD97706), width: 2),
        ),
      );
      timeBg = const Color(0xFFFEF3C7);
      timeColor = const Color(0xFFD97706);
    } else {
      statusIcon = const Icon(Icons.cancel_rounded, color: Color(0xFFDC2626), size: 20);
      timeBg = const Color(0xFFFEE2E2);
      timeColor = const Color(0xFFDC2626);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          statusIcon,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['title'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(task['categoryIcon'] as IconData, size: 12, color: const Color(0xFF64748B)),
                    const SizedBox(width: 4),
                    Text(
                      task['category'],
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: timeBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              task['time'],
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: timeColor,
              ),
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.more_vert_rounded, size: 16, color: Color(0xFF94A3B8)),
        ],
      ),
    );
  }
}

// ==========================================
// TASKS CIRCULAR DONUT PAINTER
// ==========================================
class _TasksDonutPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  const _TasksDonutPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, bgPaint);

    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _TasksDonutPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
