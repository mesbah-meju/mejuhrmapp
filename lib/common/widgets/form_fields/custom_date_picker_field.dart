import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A sleek, customizable Date Picker input field.
class CustomDatePickerField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? Function(DateTime?)? validator;
  final bool isRequired;
  final bool enabled;
  final Widget? prefixIcon;
  final DateFormat? dateFormat;
  final VoidCallback? onClear;

  const CustomDatePickerField({
    super.key,
    this.label,
    this.hintText,
    required this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.validator,
    this.isRequired = false,
    this.enabled = true,
    this.prefixIcon,
    this.dateFormat,
    this.onClear,
  });

  Future<void> _pickDate(BuildContext context) async {
    if (!enabled || onDateSelected == null) return;

    final initial = selectedDate ?? DateTime.now();
    final first = firstDate ?? DateTime(2000);
    final last = lastDate ?? DateTime(2100);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(first) ? first : (initial.isAfter(last) ? last : initial),
      firstDate: first,
      lastDate: last,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2563EB),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateSelected!(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = dateFormat ?? DateFormat('yyyy-MM-dd');
    final formattedText = selectedDate != null ? formatter.format(selectedDate!) : '';

    return FormField<DateTime>(
      initialValue: selectedDate,
      validator: (val) => validator != null ? validator!(selectedDate) : null,
      builder: (state) {
        final hasError = state.hasError;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label != null) ...[
              Row(
                children: [
                  Text(
                    label!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                    ),
                  ),
                  if (isRequired)
                    const Text(
                      ' *',
                      style: TextStyle(color: Color(0xFFEF4444), fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
              const SizedBox(height: 6),
            ],
            InkWell(
              onTap: enabled ? () => _pickDate(context) : null,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                decoration: BoxDecoration(
                  color: enabled ? Colors.white : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: hasError
                        ? const Color(0xFFEF4444)
                        : Colors.grey.shade300,
                    width: hasError ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    prefixIcon ??
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 18,
                          color: Color(0xFF64748B),
                        ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        formattedText.isNotEmpty ? formattedText : (hintText ?? 'Select date'),
                        style: TextStyle(
                          fontSize: 14,
                          color: formattedText.isNotEmpty
                              ? const Color(0xFF1E293B)
                              : const Color(0xFF94A3B8),
                          fontWeight: formattedText.isNotEmpty ? FontWeight.w500 : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (selectedDate != null && onClear != null && enabled)
                      GestureDetector(
                        onTap: onClear,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(Icons.close, size: 18, color: Color(0xFF94A3B8)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (hasError) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  state.errorText ?? '',
                  style: const TextStyle(fontSize: 11, color: Color(0xFFEF4444)),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// A sleek, customizable Time Picker input field.
class CustomTimePickerField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay>? onTimeSelected;
  final String? Function(TimeOfDay?)? validator;
  final bool isRequired;
  final bool enabled;
  final Widget? prefixIcon;
  final VoidCallback? onClear;

  const CustomTimePickerField({
    super.key,
    this.label,
    this.hintText,
    required this.selectedTime,
    required this.onTimeSelected,
    this.validator,
    this.isRequired = false,
    this.enabled = true,
    this.prefixIcon,
    this.onClear,
  });

  Future<void> _pickTime(BuildContext context) async {
    if (!enabled || onTimeSelected == null) return;

    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2563EB),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onTimeSelected!(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedText = selectedTime != null ? selectedTime!.format(context) : '';

    return FormField<TimeOfDay>(
      initialValue: selectedTime,
      validator: (val) => validator != null ? validator!(selectedTime) : null,
      builder: (state) {
        final hasError = state.hasError;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label != null) ...[
              Row(
                children: [
                  Text(
                    label!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                    ),
                  ),
                  if (isRequired)
                    const Text(
                      ' *',
                      style: TextStyle(color: Color(0xFFEF4444), fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
              const SizedBox(height: 6),
            ],
            InkWell(
              onTap: enabled ? () => _pickTime(context) : null,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                decoration: BoxDecoration(
                  color: enabled ? Colors.white : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: hasError
                        ? const Color(0xFFEF4444)
                        : Colors.grey.shade300,
                    width: hasError ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    prefixIcon ??
                        const Icon(
                          Icons.access_time_outlined,
                          size: 18,
                          color: Color(0xFF64748B),
                        ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        formattedText.isNotEmpty ? formattedText : (hintText ?? 'Select time'),
                        style: TextStyle(
                          fontSize: 14,
                          color: formattedText.isNotEmpty
                              ? const Color(0xFF1E293B)
                              : const Color(0xFF94A3B8),
                          fontWeight: formattedText.isNotEmpty ? FontWeight.w500 : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (selectedTime != null && onClear != null && enabled)
                      GestureDetector(
                        onTap: onClear,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(Icons.close, size: 18, color: Color(0xFF94A3B8)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (hasError) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  state.errorText ?? '',
                  style: const TextStyle(fontSize: 11, color: Color(0xFFEF4444)),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
