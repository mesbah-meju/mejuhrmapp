import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:auth_ui_app/services/approval_service.dart';
import 'package:auth_ui_app/services/auth_service.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class ApplyLeaveSheet extends StatefulWidget {
  final VoidCallback? onLeaveApplied;

  const ApplyLeaveSheet({super.key, this.onLeaveApplied});

  static void show(BuildContext context, {VoidCallback? onLeaveApplied}) {
    Get.bottomSheet(
      ApplyLeaveSheet(onLeaveApplied: onLeaveApplied),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  State<ApplyLeaveSheet> createState() => _ApplyLeaveSheetState();
}

class _ApplyLeaveSheetState extends State<ApplyLeaveSheet> {
  String _selectedLeaveType = 'Casual Leave';
  final List<String> _leaveTypes = [
    'Casual Leave',
    'Sick Leave',
    'Annual Leave',
    'Maternity / Paternity',
    'Unpaid Leave',
  ];

  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime _endDate = DateTime.now().add(const Duration(days: 2));

  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _contactController = TextEditingController(text: '+880 1712-345678');
  bool _isSubmitting = false;

  int get _totalDays {
    final diff = _endDate.difference(_startDate).inDays + 1;
    return diff > 0 ? diff : 1;
  }

  Future<void> _selectDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2563EB),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _startDate = _endDate;
          }
        }
      });
    }
  }

  void _submitLeave() async {
    final reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      THelperFunctions.showSnackBar("Please specify a reason for your leave request.");
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = AuthService.instance.getUser();
      final userName = user?['name'] ?? 'Rahul Sharma';
      final empId = user?['employee_id'] ?? 'EMP-00125';

      final startStr = DateFormat('dd MMM yyyy').format(_startDate);
      final endStr = DateFormat('dd MMM yyyy').format(_endDate);

      final req = ApprovalRequest(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        uuid: '01K-LV-${DateTime.now().millisecondsSinceEpoch}',
        requestedBy: empId.toString(),
        employeeName: userName,
        approvalType: 'leave_request',
        entityType: 'leave',
        entityId: DateTime.now().millisecondsSinceEpoch.toString(),
        entityUuid: '01K-LEAVE-${DateTime.now().millisecondsSinceEpoch}',
        value: _totalDays.toDouble(),
        valueDisplay: '$_totalDays Day(s) — $_selectedLeaveType',
        sourceInfo: '$startStr to $endStr',
        reason: reason,
        metadata: {
          'leave_type': _selectedLeaveType,
          'start_date': startStr,
          'end_date': endStr,
          'total_days': _totalDays,
          'emergency_contact': _contactController.text.trim(),
        },
        requestedAt: DateTime.now(),
      );

      await ApprovalService.instance.submitRequest(req);

      Get.back();
      THelperFunctions.showSnackBar("Leave application submitted successfully for manager review!");
      widget.onLeaveApplied?.call();
    } catch (e) {
      THelperFunctions.showSnackBar("Failed to submit leave application. Please try again.");
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('EEE, dd MMM yyyy');

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Sheet Title & Close
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Iconsax.calendar_add, color: Color(0xFF2563EB), size: 24),
                    SizedBox(width: 10),
                    Text(
                      "Apply for Leave",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                ),
              ],
            ),
            const Divider(height: 24, color: Color(0xFFF1F5F9)),

            // 1. Leave Type Selection
            const Text(
              "LEAVE TYPE",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _leaveTypes.map((type) {
                final isSelected = _selectedLeaveType == type;
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  selectedColor: const Color(0xFF2563EB),
                  backgroundColor: const Color(0xFFF8FAFC),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF475569),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 12.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedLeaveType = type);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 18),

            // 2. Date Range Picker Cards
            const Text(
              "DURATION",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(true),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("From Date", style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                          const SizedBox(height: 4),
                          Text(
                            dateFmt.format(_startDate),
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(false),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("To Date", style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                          const SizedBox(height: 4),
                          Text(
                            dateFmt.format(_endDate),
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Total requested duration: $_totalDays day(s)",
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2563EB)),
              ),
            ),
            const SizedBox(height: 18),

            // 3. Reason Text Field
            const Text(
              "REASON FOR LEAVE",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Enter detailed reason for leave request...",
                hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                fillColor: const Color(0xFFF8FAFC),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 4. Emergency Contact Phone
            const Text(
              "EMERGENCY CONTACT",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _contactController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.phone_outlined, size: 20, color: Color(0xFF64748B)),
                hintText: "Phone number during leave",
                hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                fillColor: const Color(0xFFF8FAFC),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitLeave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        "Submit Leave Application",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
