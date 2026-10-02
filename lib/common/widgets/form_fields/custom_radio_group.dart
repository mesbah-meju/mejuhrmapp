import 'package:flutter/material.dart';

class RadioOption<T> {
  final T value;
  final String title;
  final String? subtitle;
  final IconData? icon;

  const RadioOption({
    required this.value,
    required this.title,
    this.subtitle,
    this.icon,
  });
}

/// Production-ready Radio Group & Radio Card components
class CustomRadioGroup<T> extends StatelessWidget {
  final String? label;
  final T? selectedValue;
  final List<RadioOption<T>> options;
  final void Function(T) onChanged;
  final Axis direction;
  final bool isCardStyle;
  final Color activeColor;

  const CustomRadioGroup({
    super.key,
    this.label,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
    this.direction = Axis.vertical,
    this.isCardStyle = true,
    this.activeColor = const Color(0xFF2563EB),
  });

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: 8),
        ],
        if (direction == Axis.vertical)
          ...options.map((opt) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildItem(opt),
              ))
        else
          Row(
            children: options.map((opt) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _buildItem(opt),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildItem(RadioOption<T> option) {
    final isSelected = selectedValue == option.value;

    if (isCardStyle) {
      return InkWell(
        onTap: () => onChanged(option.value),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? activeColor.withValues(alpha: 0.06) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? activeColor : const Color(0xFFE2E8F0),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              if (option.icon != null) ...[
                Icon(
                  option.icon,
                  size: 20,
                  color: isSelected ? activeColor : const Color(0xFF64748B),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF334155),
                      ),
                    ),
                    if (option.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        option.subtitle!,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? activeColor : const Color(0xFFCBD5E1),
                    width: isSelected ? 5.5 : 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Standard list tile style
    return InkWell(
      onTap: () => onChanged(option.value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? activeColor : const Color(0xFFCBD5E1),
                  width: isSelected ? 5.5 : 1.5,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              option.title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
