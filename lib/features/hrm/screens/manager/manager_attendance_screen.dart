import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:auth_ui_app/features/hrm/controllers/controllers.dart';
import 'package:auth_ui_app/features/hrm/models/manager_models.dart';

class ManagerAttendanceScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const ManagerAttendanceScreen({super.key, this.onBack});

  @override
  State<ManagerAttendanceScreen> createState() => _ManagerAttendanceScreenState();
}

class _ManagerAttendanceScreenState extends State<ManagerAttendanceScreen> {
  final ManagerAttendanceController controller = ManagerAttendanceController.instance;
  final ManagerEmployeeController empController = ManagerEmployeeController.instance;

  @override
  void initState() {
    super.initState();
    controller.fetchAttendances();
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
            Text("Staff Attendance", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            Text("Daily Overview & Manual Clocking", style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF2563EB)),
            tooltip: "Refresh",
            onPressed: () => controller.fetchAttendances(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showManualAttendanceSheet(context),
        backgroundColor: const Color(0xFF2563EB),
        icon: const Icon(Icons.more_time_rounded, color: Colors.white),
        label: const Text("Manual Entry", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // DATE & FILTER CONTROLS
          _buildFilterBar(),

          // SUMMARY METRIC CHIPS
          _buildSummaryCounters(),

          // ATTENDANCE LIST
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(color: Color(0xFF2563EB)),
                  ),
                );
              }

              final records = controller.attendances;

              if (records.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.calendar_remove, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 12),
                      const Text(
                        "No attendance records for this date",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Tap '+ Manual Entry' to log clock-in/out for a staff member",
                        style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.fetchAttendances(),
                color: const Color(0xFF2563EB),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                  itemCount: records.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = records[index];
                    return _buildAttendanceCard(item);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // FILTER BAR (DATE PICKER & BRANCH FILTER)
  // =========================================================================
  Widget _buildFilterBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          // Date Selector Button
          Expanded(
            child: InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: controller.selectedDate.value,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (picked != null) {
                  controller.updateDate(picked);
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Icon(Iconsax.calendar_1, size: 16, color: Color(0xFF2563EB)),
                    const SizedBox(width: 8),
                    Obx(() => Text(
                          DateFormat('dd MMM yyyy').format(controller.selectedDate.value),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        )),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Status Filter Chip Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: DropdownButtonHideUnderline(
              child: Obx(() => DropdownButton<String>(
                    value: controller.selectedStatus.value,
                    icon: const Icon(Icons.arrow_drop_down, size: 18, color: Color(0xFF64748B)),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text("All Status", style: TextStyle(fontSize: 12))),
                      DropdownMenuItem(value: 'present', child: Text("Present", style: TextStyle(fontSize: 12))),
                      DropdownMenuItem(value: 'late', child: Text("Late", style: TextStyle(fontSize: 12))),
                      DropdownMenuItem(value: 'absent', child: Text("Absent", style: TextStyle(fontSize: 12))),
                    ],
                    onChanged: (val) {
                      if (val != null) controller.updateStatus(val);
                    },
                  )),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // SUMMARY METRICS COUNTER
  // =========================================================================
  Widget _buildSummaryCounters() {
    return Obx(() {
      final records = controller.attendances;
      final present = records.where((r) => r.status.toLowerCase() == 'present').length;
      final late = records.where((r) => r.isLate).length;
      final absent = records.where((r) => r.status.toLowerCase() == 'absent').length;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: const Color(0xFFF8FAFC),
        child: Row(
          children: [
            _buildStatBadge("Present", "$present", const Color(0xFF059669), const Color(0xFFDCFCE7)),
            const SizedBox(width: 8),
            _buildStatBadge("Late", "$late", const Color(0xFFD97706), const Color(0xFFFEF3C7)),
            const SizedBox(width: 8),
            _buildStatBadge("Absent", "$absent", const Color(0xFFDC2626), const Color(0xFFFEE2E2)),
          ],
        ),
      );
    });
  }

  Widget _buildStatBadge(String label, String count, Color color, Color bg) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
            const SizedBox(width: 4),
            Text(count, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // ATTENDANCE CARD
  // =========================================================================
  Widget _buildAttendanceCard(ManagerAttendanceModel item) {
    final bool isPresent = item.status.toLowerCase() == 'present';
    final bool isLate = item.isLate;

    final Color statusColor = isLate
        ? const Color(0xFFD97706)
        : isPresent
            ? const Color(0xFF059669)
            : const Color(0xFFDC2626);

    final Color statusBg = isLate
        ? const Color(0xFFFEF3C7)
        : isPresent
            ? const Color(0xFFDCFCE7)
            : const Color(0xFFFEE2E2);

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
          // Header: Employee Name, Code & Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFFEFF6FF),
                    child: Text(
                      item.employeeName != null && item.employeeName!.isNotEmpty ? item.employeeName![0] : 'E',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.employeeName ?? 'Staff', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      if (item.employeeCode != null && item.employeeCode!.isNotEmpty)
                        Text(item.employeeCode!, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(6)),
                child: Text(
                  isLate ? "Late" : item.status.capitalizeFirst ?? 'Present',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Clock In & Clock Out Times
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text("Clock In", style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                    const SizedBox(height: 2),
                    Text(
                      item.clockIn ?? '--:--',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                  ],
                ),
                Container(height: 24, width: 1, color: const Color(0xFFE2E8F0)),
                Column(
                  children: [
                    const Text("Clock Out", style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                    const SizedBox(height: 2),
                    Text(
                      item.clockOut ?? '--:--',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                  ],
                ),
                Container(height: 24, width: 1, color: const Color(0xFFE2E8F0)),
                Column(
                  children: [
                    const Text("Work Hours", style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                    const SizedBox(height: 2),
                    Text(
                      item.workHours ?? '--',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (item.lateReason != null && item.lateReason!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              "Reason: ${item.lateReason}",
              style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFFD97706)),
            ),
          ],

          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 6),

          // Action buttons: Edit & Delete
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(Iconsax.edit_2, size: 14, color: Color(0xFF2563EB)),
                label: const Text("Edit Record", style: TextStyle(fontSize: 11, color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
                onPressed: () => _showEditAttendanceDialog(context, item),
              ),
              const SizedBox(width: 8),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Iconsax.trash, size: 16, color: Color(0xFF94A3B8)),
                tooltip: "Delete Record",
                onPressed: () => _confirmDeleteAttendance(context, item),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // MANUAL CLOCK IN/OUT MODAL
  // =========================================================================
  void _showManualAttendanceSheet(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final clockInCtrl = TextEditingController(text: "09:00:00");
    final clockOutCtrl = TextEditingController(text: "18:00:00");
    final notesCtrl = TextEditingController();

    int? selectedEmpId = empController.activeEmployees.isNotEmpty ? empController.activeEmployees.first.id : null;
    String status = "present";
    DateTime date = controller.selectedDate.value;

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
                  const Text("Log Manual Attendance", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
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
                          decoration: const InputDecoration(labelText: "Select Staff Member *", prefixIcon: Icon(Iconsax.user)),
                          items: empController.activeEmployees
                              .map((e) => DropdownMenuItem(value: e.id, child: Text("${e.name} (${e.employeeId})")))
                              .toList(),
                          onChanged: (val) => setSheetState(() => selectedEmpId = val),
                          validator: (v) => v == null ? "Please select staff" : null,
                        )),
                    const SizedBox(height: 12),

                    // Date & Status
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: status,
                            decoration: const InputDecoration(labelText: "Status *"),
                            items: const [
                              DropdownMenuItem(value: 'present', child: Text("Present")),
                              DropdownMenuItem(value: 'late', child: Text("Late")),
                              DropdownMenuItem(value: 'absent', child: Text("Absent")),
                              DropdownMenuItem(value: 'half_day', child: Text("Half Day")),
                            ],
                            onChanged: (val) => setSheetState(() => status = val ?? 'present'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Clock In & Clock Out
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: clockInCtrl,
                            decoration: const InputDecoration(labelText: "Clock In (HH:MM:SS)"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: clockOutCtrl,
                            decoration: const InputDecoration(labelText: "Clock Out (HH:MM:SS)"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: notesCtrl,
                      decoration: const InputDecoration(labelText: "Notes / Late Reason", prefixIcon: Icon(Iconsax.note)),
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
                              'date': DateFormat('yyyy-MM-dd').format(date),
                              'clock_in': clockInCtrl.text.trim(),
                              'clock_out': clockOutCtrl.text.trim(),
                              'status': status,
                              if (notesCtrl.text.isNotEmpty) 'notes': notesCtrl.text.trim(),
                            };

                            final ok = await controller.createAttendance(body);
                            if (ok && ctx.mounted) Navigator.pop(ctx);
                          }
                        },
                        child: const Text("Save Attendance Record", style: TextStyle(fontWeight: FontWeight.bold)),
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

  // =========================================================================
  // EDIT ATTENDANCE DIALOG
  // =========================================================================
  void _showEditAttendanceDialog(BuildContext context, ManagerAttendanceModel item) {
    final formKey = GlobalKey<FormState>();
    final clockInCtrl = TextEditingController(text: item.clockIn ?? '');
    final clockOutCtrl = TextEditingController(text: item.clockOut ?? '');
    final notesCtrl = TextEditingController(text: item.notes ?? '');
    final reasonCtrl = TextEditingController(text: item.lateReason ?? '');
    String status = item.status.toLowerCase();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("Edit Attendance (${item.employeeName})", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: status,
                    decoration: const InputDecoration(labelText: "Status"),
                    items: const [
                      DropdownMenuItem(value: 'present', child: Text("Present")),
                      DropdownMenuItem(value: 'late', child: Text("Late")),
                      DropdownMenuItem(value: 'absent', child: Text("Absent")),
                    ],
                    onChanged: (val) => setDialogState(() => status = val ?? 'present'),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: clockInCtrl,
                    decoration: const InputDecoration(labelText: "Clock In (HH:MM:SS)"),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: clockOutCtrl,
                    decoration: const InputDecoration(labelText: "Clock Out (HH:MM:SS)"),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: reasonCtrl,
                    decoration: const InputDecoration(labelText: "Late Reason"),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: notesCtrl,
                    decoration: const InputDecoration(labelText: "Manager Notes"),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel", style: TextStyle(color: Color(0xFF64748B))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final body = {
                    'clock_in': clockInCtrl.text.trim(),
                    'clock_out': clockOutCtrl.text.trim(),
                    'status': status,
                    'late_reason': reasonCtrl.text.trim(),
                    'notes': notesCtrl.text.trim(),
                  };

                  final ok = await controller.updateAttendance(item.id, body);
                  if (ok && ctx.mounted) Navigator.pop(ctx);
                }
              },
              child: const Text("Update"),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // DELETE ATTENDANCE CONFIRMATION
  // =========================================================================
  void _confirmDeleteAttendance(BuildContext context, ManagerAttendanceModel item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete Attendance Record?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Text(
          "Are you sure you want to delete the attendance record for ${item.employeeName} on ${item.date}?",
          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await controller.deleteAttendance(item.id);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
