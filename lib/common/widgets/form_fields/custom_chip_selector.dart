import 'package:flutter/material.dart';

class ChipItem<T> {
  final String label;
  final T value;
  final Widget? icon;

  const ChipItem({
    required this.label,
    required this.value,
    this.icon,
  });
}

/// A generic single-selection chip group.
class CustomChipSelector<T> extends StatelessWidget {
  final String? label;
  final List<ChipItem<T>> items;
  final T? selectedValue;
  final ValueChanged<T> onSelected;
  final Color? activeColor;
  final bool isRequired;
  final bool scrollable;

  const CustomChipSelector({
    super.key,
    this.label,
    required this.items,
    required this.selectedValue,
    required this.onSelected,
    this.activeColor,
    this.isRequired = false,
    this.scrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? const Color(0xFF2563EB);

    final chipWidgets = items.map((item) {
      final isSelected = item.value == selectedValue;

      return GestureDetector(
        onTap: () => onSelected(item.value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? effectiveActiveColor : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? effectiveActiveColor : Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.icon != null) ...[
                item.icon!,
                const SizedBox(width: 6),
              ],
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF334155),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();

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
          const SizedBox(height: 8),
        ],
        if (scrollable)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: chipWidgets
                  .map((chip) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: chip,
                      ))
                  .toList(),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: chipWidgets,
          ),
      ],
    );
  }
}

/// A generic multi-selection chip filter group.
class CustomMultiChipSelector<T> extends StatelessWidget {
  final String? label;
  final List<ChipItem<T>> items;
  final List<T> selectedValues;
  final ValueChanged<List<T>> onChanged;
  final Color? activeColor;
  final bool isRequired;
  final bool scrollable;

  const CustomMultiChipSelector({
    super.key,
    this.label,
    required this.items,
    required this.selectedValues,
    required this.onChanged,
    this.activeColor,
    this.isRequired = false,
    this.scrollable = false,
  });

  void _toggle(T val) {
    final updated = List<T>.from(selectedValues);
    if (updated.contains(val)) {
      updated.remove(val);
    } else {
      updated.add(val);
    }
    onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? const Color(0xFF2563EB);

    final chipWidgets = items.map((item) {
      final isSelected = selectedValues.contains(item.value);

      return GestureDetector(
        onTap: () => _toggle(item.value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? effectiveActiveColor.withValues(alpha: 0.1) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? effectiveActiveColor : Colors.grey.shade300,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected) ...[
                Icon(Icons.check, size: 14, color: effectiveActiveColor),
                const SizedBox(width: 4),
              ] else if (item.icon != null) ...[
                item.icon!,
                const SizedBox(width: 6),
              ],
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? effectiveActiveColor : const Color(0xFF334155),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();

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
          const SizedBox(height: 8),
        ],
        if (scrollable)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: chipWidgets
                  .map((chip) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: chip,
                      ))
                  .toList(),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: chipWidgets,
          ),
      ],
    );
  }
}
