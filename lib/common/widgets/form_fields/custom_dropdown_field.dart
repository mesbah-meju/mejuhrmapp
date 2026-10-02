import 'package:flutter/material.dart';

/// Generic, highly styled Select / Dropdown form field component
class CustomDropdownField<T> extends StatelessWidget {
  final String? label;
  final String? hintText;
  final String? helperText;
  final T? value;
  final List<T> items;
  final String Function(T)? itemLabelBuilder;
  final Widget Function(T)? itemBuilder;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final Widget? prefixIcon;
  final bool enabled;
  final Color? fillColor;
  final BorderRadius? borderRadius;

  const CustomDropdownField({
    super.key,
    this.label,
    this.hintText,
    this.helperText,
    required this.value,
    required this.items,
    this.itemLabelBuilder,
    this.itemBuilder,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.enabled = true,
    this.fillColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final borderRad = borderRadius ?? BorderRadius.circular(12);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 6),
        ],
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: itemBuilder != null
                  ? itemBuilder!(item)
                  : Text(
                      itemLabelBuilder != null ? itemLabelBuilder!(item) : item.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0F172A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
            );
          }).toList(),
          onChanged: enabled ? onChanged : null,
          validator: validator,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20,
            color: Color(0xFF64748B),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            helperText: helperText,
            hintStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: Color(0xFF94A3B8),
            ),
            fillColor: fillColor ?? (enabled ? const Color(0xFFF8FAFC) : const Color(0xFFF1F5F9)),
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            prefixIcon: prefixIcon,
            border: OutlineInputBorder(
              borderRadius: borderRad,
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: borderRad,
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: borderRad,
              borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: borderRad,
              borderSide: const BorderSide(color: Color(0xFFEF4444)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: borderRad,
              borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
