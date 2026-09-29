import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:auth_ui_app/services/notification_engine_service.dart';
import 'package:auth_ui_app/services/timeline_service.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class ManagerTasksScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const ManagerTasksScreen({super.key, this.onBack});

  @override
  State<ManagerTasksScreen> createState() => _ManagerTasksScreenState();
}

class _ManagerTasksScreenState extends State<ManagerTasksScreen> {
  String _selectedPriority = 'All';

  // Employee-Wise Tasks Data Store
  final List<Map<String, dynamic>> _employeeTaskGroups = [
    {
      'employeeId': 'EMP-1001',
      'employeeName': 'Rahul Sharma',
      'role': 'Senior Sales Executive',
      'avatar': 'RS',
      'tasks': [
        {'id': 'T-101', 'title': 'Client Follow-up Calls (5 Enterprise Leads)', 'time': '09:00 AM', 'completed': true, 'priority': 'High'},
        {'id': 'T-102', 'title': 'Submit Monthly Sales Reconciliation', 'time': '11:30 AM', 'completed': true, 'priority': 'Normal'},
        {'id': 'T-103', 'title': 'Conduct Product Demo for Acme Corp', 'time': '02:00 PM', 'completed': false, 'priority': 'High'},
        {'id': 'T-104', 'title': 'Update CRM Deal Pipeline', 'time': '05:00 PM', 'completed': false, 'priority': 'Normal'},
      ]
    },
    {
      'employeeId': 'EMP-1002',
      'employeeName': 'Ananya Roy',
      'role': 'Sales Associate',
      'avatar': 'AR',
      'tasks': [
        {'id': 'T-105', 'title': 'Prepare Showroom Quotations', 'time': '10:00 AM', 'completed': true, 'priority': 'Normal'},
        {'id': 'T-106', 'title': 'Verify Payment Slips for Walk-in Clients', 'time': '01:00 PM', 'completed': false, 'priority': 'High'},
        {'id': 'T-107', 'title': 'Organize Promotional Material Stock', 'time': '04:30 PM', 'completed': false, 'priority': 'Normal'},
      ]
    },
    {
      'employeeId': 'EMP-1003',
      'employeeName': 'Tanvir Ahmed',
      'role': 'Business Analyst',
      'avatar': 'TA',
      'tasks': [
        {'id': 'T-108', 'title': 'Quarterly Revenue Forecast Model', 'time': '09:30 AM', 'completed': true, 'priority': 'High'},
        {'id': 'T-109', 'title': 'Analyze Regional Store Performance', 'time': '03:00 PM', 'completed': true, 'priority': 'Normal'},
      ]
    },
    {
      'employeeId': 'EMP-1004',
      'employeeName': 'Nusrat Jahan',
      'role': 'HR Coordinator',
      'avatar': 'NJ',
      'tasks': [
        {'id': 'T-110', 'title': 'Process New Employee Onboarding Files', 'time': '11:00 AM', 'completed': true, 'priority': 'Normal'},
        {'id': 'T-111', 'title': 'Prepare Weekly Attendance Log Report', 'time': '04:00 PM', 'completed': false, 'priority': 'High'},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    int totalTasks = 0;
    int completedTasks = 0;
    for (var group in _employeeTaskGroups) {
      final tasks = group['tasks'] as List;
      totalTasks += tasks.length;
      completedTasks += tasks.where((t) => t['completed'] == true).length;
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
            Text("Employee-Wise Task Board", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            Text("Assign & Track Team Member Tasks", style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.add_circle, color: Color(0xFF2563EB), size: 24),
            tooltip: "Assign New Task",
            onPressed: () => _openAssignTaskModal(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // KPI Summary Header
            _buildTaskProgressBanner(completedTasks, totalTasks),

            // Employee-Wise Task Cards List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _employeeTaskGroups.length,
                itemBuilder: (context, index) {
                  return _buildEmployeeTaskCard(_employeeTaskGroups[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAssignTaskModal(),
        backgroundColor: const Color(0xFF2563EB),
        icon: const Icon(Iconsax.task_square, color: Colors.white),
        label: const Text("Assign Task", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Widget _buildTaskProgressBanner(int completed, int total) {
    final progress = total > 0 ? completed / total : 0.0;
    final pendingCount = total - completed;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("TEAM TASK EXECUTION", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
                    const SizedBox(height: 2),
                    Text("$completed / $total Tasks Completed", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text("${(progress * 100).toInt()}% Done", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: const Color(0xFF334155),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF38BDF8)),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFF1E293B)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Iconsax.notification_bing, color: Color(0xFF60A5FA), size: 16),
                    const SizedBox(width: 6),
                    Text(
                      "$pendingCount Pending Tasks Remaining",
                      style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _remindAllMembersToCompleteTasks,
                  icon: const Icon(Iconsax.send_2, size: 12),
                  label: const Text("Broadcast Nudge", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _remindAllMembersToCompleteTasks() {
    int pendingCount = 0;
    for (var group in _employeeTaskGroups) {
      final tasks = group['tasks'] as List;
      pendingCount += tasks.where((t) => t['completed'] == false).length;
    }

    NotificationEngineService.instance.addNotification(
      AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        uuid: '01K-REM-TASK-${DateTime.now().millisecondsSinceEpoch}',
        category: 'task',
        title: '⚡ Task Deadline Reminder',
        body: 'Manager nudge: Please complete your $pendingCount pending assigned tasks.',
        data: {'type': 'task_reminder'},
        deepLinkRoute: '/tasks',
        createdAt: DateTime.now(),
      ),
    );

    TimelineService.instance.logEvent(
      ActivityEvent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        uuid: '01K-EVT-TASKREM-${DateTime.now().millisecondsSinceEpoch}',
        eventType: 'task.started',
        title: 'Task Reminder Nudge Dispatched',
        description: 'Manager sent push reminder notification to all team members for $pendingCount pending tasks.',
        metadata: {'pending_tasks_count': pendingCount},
        eventAt: DateTime.now(),
        status: 'completed',
      ),
    );

    THelperFunctions.showSnackBar("⚡ Sent task completion push reminder to all team members for $pendingCount pending tasks!");
  }

  Widget _buildEmployeeTaskCard(Map<String, dynamic> group) {
    final tasks = group['tasks'] as List<Map<String, dynamic>>;
    final empName = group['employeeName'] as String;
    final role = group['role'] as String;
    final avatar = group['avatar'] as String;

    final completed = tasks.where((t) => t['completed'] == true).length;
    final total = tasks.length;

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
          // Header: Employee Avatar & Add Task Quick Button
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
                      child: Text(avatar, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(empName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                        Text("$role • $completed/$total Completed", style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Iconsax.add_circle, color: Color(0xFF2563EB), size: 20),
                  tooltip: "Assign Task to $empName",
                  onPressed: () => _openAssignTaskModal(preSelectedEmp: empName),
                ),
              ],
            ),
          ),

          // List of Tasks assigned to this Employee
          ...tasks.map((task) {
            final isDone = task['completed'] as bool;
            final isHigh = task['priority'] == 'High';

            return Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  leading: Checkbox(
                    value: isDone,
                    activeColor: const Color(0xFF059669),
                    onChanged: (val) {
                      setState(() {
                        task['completed'] = val ?? false;
                      });
                    },
                  ),
                  title: Text(
                    task['title'],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                      color: isDone ? const Color(0xFF94A3B8) : const Color(0xFF0F172A),
                    ),
                  ),
                  subtitle: Text("Due by ${task['time']}", style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isHigh ? const Color(0xFFFEE2E2) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      isHigh ? "High Priority" : "Normal",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isHigh ? const Color(0xFFDC2626) : const Color(0xFF475569),
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  void _openAssignTaskModal({String? preSelectedEmp}) {
    String assignedTo = preSelectedEmp ?? _employeeTaskGroups[0]['employeeName'];
    final titleController = TextEditingController();
    String priority = 'Normal';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Assign New Task", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                    ],
                  ),
                  const Divider(height: 16),

                  const Text("Select Employee", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: assignedTo,
                    items: _employeeTaskGroups.map((g) {
                      return DropdownMenuItem<String>(
                        value: g['employeeName'] as String,
                        child: Text(g['employeeName'] as String),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => assignedTo = val);
                    },
                    decoration: InputDecoration(isDense: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                  ),
                  const SizedBox(height: 14),

                  const Text("Task Title & Description", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "e.g. Conduct Client Follow-up Call",
                      isDense: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 14),

                  const Text("Priority Level", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text("Normal Priority"),
                        selected: priority == 'Normal',
                        selectedColor: const Color(0xFF2563EB),
                        onSelected: (val) => setModalState(() => priority = 'Normal'),
                      ),
                      const SizedBox(width: 10),
                      ChoiceChip(
                        label: const Text("High Priority"),
                        selected: priority == 'High',
                        selectedColor: const Color(0xFFDC2626),
                        onSelected: (val) => setModalState(() => priority = 'High'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (titleController.text.trim().isEmpty) return;
                        setState(() {
                          final group = _employeeTaskGroups.firstWhere((g) => g['employeeName'] == assignedTo);
                          (group['tasks'] as List).add({
                            'id': 'T-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                            'title': titleController.text.trim(),
                            'time': '05:00 PM',
                            'completed': false,
                            'priority': priority,
                          });
                        });
                        Navigator.pop(context);
                        THelperFunctions.showSnackBar("Assigned task to $assignedTo!");
                      },
                      icon: const Icon(Iconsax.add, size: 18),
                      label: const Text("Assign Task Now", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
