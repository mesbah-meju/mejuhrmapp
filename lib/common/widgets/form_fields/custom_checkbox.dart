import 'package:flutter/material.dart';

/// A modern, styled checkbox tile with title, subtitle, optional icon, and rounded card or clean styling.
class CustomCheckboxTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final Widget? leading;
  final Color? activeColor;
  final Color? checkColor;
  final bool isCard;
  final EdgeInsetsGeometry? contentPadding;
  final bool enabled;

  const CustomCheckboxTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.leading,
    this.activeColor,
    this.checkColor,
    this.isCard = false,
    this.contentPadding,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = activeColor ?? const Color(0xFF2563EB);

    final tileContent = InkWell(
      onTap: enabled && onChanged != null ? () => onChanged!(!value) : null,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: contentPadding ??
            EdgeInsets.symmetric(
              horizontal: isCard ? 14 : 4,
              vertical: isCard ? 12 : 8,
            ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: enabled ? const Color(0xFF1E293B) : Colors.grey.shade400,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: enabled ? Colors.grey.shade600 : Colors.grey.shade400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: value
                    ? (enabled ? primaryColor : Colors.grey.shade300)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: value
                      ? (enabled ? primaryColor : Colors.grey.shade300)
                      : Colors.grey.shade400,
                  width: 1.8,
                ),
              ),
              child: value
                  ? Icon(
                      Icons.check,
                      size: 15,
                      color: checkColor ?? Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );

    if (isCard) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: value ? primaryColor.withValues(alpha: 0.04) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value
                ? primaryColor.withValues(alpha: 0.5)
                : Colors.grey.shade200,
            width: value ? 1.5 : 1,
          ),
        ),
        child: tileContent,
      );
    }

    return tileContent;
  }
}

/// Standalone rounded custom checkbox widget.
class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final Color? activeColor;
  final Color? checkColor;
  final double size;
  final double borderRadius;
  final bool enabled;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.checkColor,
    this.size = 22,
    this.borderRadius = 6,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? const Color(0xFF2563EB);

    return GestureDetector(
      onTap: enabled && onChanged != null ? () => onChanged!(!value) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: value
              ? (enabled ? effectiveActiveColor : Colors.grey.shade300)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: value
                ? (enabled ? effectiveActiveColor : Colors.grey.shade300)
                : Colors.grey.shade400,
            width: 1.8,
          ),
        ),
        child: value
            ? Icon(
                Icons.check,
                size: size * 0.68,
                color: checkColor ?? Colors.white,
              )
            : null,
      ),
    );
  }
}
