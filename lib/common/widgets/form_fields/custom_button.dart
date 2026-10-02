import 'package:flutter/material.dart';

enum CustomButtonVariant {
  primary,
  secondary,
  outlined,
  danger,
  success,
  ghost,
}

enum CustomButtonSize {
  small,
  medium,
  large,
}

/// A comprehensive modern custom button supporting multiple variants, sizes, icons, and loading states.
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final CustomButtonVariant variant;
  final CustomButtonSize size;
  final Widget? icon;
  final bool iconAfterText;
  final bool isLoading;
  final bool fullWidth;
  final double? width;
  final double? height;
  final double borderRadius;
  final Color? customColor;
  final Color? customTextColor;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = CustomButtonVariant.primary,
    this.size = CustomButtonSize.medium,
    this.icon,
    this.iconAfterText = false,
    this.isLoading = false,
    this.fullWidth = true,
    this.width,
    this.height,
    this.borderRadius = 12.0,
    this.customColor,
    this.customTextColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;

    // Height & padding configurations based on size
    double buttonHeight;
    double fontSize;
    EdgeInsets resolvedPadding;

    switch (size) {
      case CustomButtonSize.small:
        buttonHeight = 38.0;
        fontSize = 13.0;
        resolvedPadding = const EdgeInsets.symmetric(horizontal: 14);
        break;
      case CustomButtonSize.medium:
        buttonHeight = 48.0;
        fontSize = 15.0;
        resolvedPadding = const EdgeInsets.symmetric(horizontal: 20);
        break;
      case CustomButtonSize.large:
        buttonHeight = 54.0;
        fontSize = 16.0;
        resolvedPadding = const EdgeInsets.symmetric(horizontal: 24);
        break;
    }

    // Colors mapping
    Color bgColor;
    Color textColor;
    BorderSide borderSide = BorderSide.none;

    switch (variant) {
      case CustomButtonVariant.primary:
        bgColor = customColor ?? const Color(0xFF2563EB);
        textColor = customTextColor ?? Colors.white;
        break;
      case CustomButtonVariant.secondary:
        bgColor = customColor ?? const Color(0xFFF1F5F9);
        textColor = customTextColor ?? const Color(0xFF334155);
        break;
      case CustomButtonVariant.outlined:
        bgColor = Colors.transparent;
        textColor = customTextColor ?? (customColor ?? const Color(0xFF2563EB));
        borderSide = BorderSide(
          color: customColor ?? const Color(0xFFCBD5E1),
          width: 1.5,
        );
        break;
      case CustomButtonVariant.danger:
        bgColor = customColor ?? const Color(0xFFEF4444);
        textColor = customTextColor ?? Colors.white;
        break;
      case CustomButtonVariant.success:
        bgColor = customColor ?? const Color(0xFF10B981);
        textColor = customTextColor ?? Colors.white;
        break;
      case CustomButtonVariant.ghost:
        bgColor = Colors.transparent;
        textColor = customTextColor ?? const Color(0xFF475569);
        break;
    }

    if (!isEnabled && !isLoading) {
      bgColor = Colors.grey.shade200;
      textColor = Colors.grey.shade400;
      borderSide = BorderSide.none;
    }

    Widget content;
    if (isLoading) {
      content = SizedBox(
        height: fontSize + 4,
        width: fontSize + 4,
        child: CircularProgressIndicator(
          strokeWidth: 2.2,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == CustomButtonVariant.outlined || variant == CustomButtonVariant.ghost
                ? (customColor ?? const Color(0xFF2563EB))
                : textColor,
          ),
        ),
      );
    } else {
      final textWidget = Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.2,
        ),
      );

      if (icon != null) {
        content = Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!iconAfterText) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            textWidget,
            if (iconAfterText) ...[
              const SizedBox(width: 8),
              icon!,
            ],
          ],
        );
      } else {
        content = textWidget;
      }
    }

    final button = Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(borderRadius),
      shape: borderSide != BorderSide.none
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: borderSide,
            )
          : null,
      child: InkWell(
        onTap: isEnabled ? onPressed : null,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          height: height ?? buttonHeight,
          width: width,
          padding: padding ?? resolvedPadding,
          alignment: Alignment.center,
          child: content,
        ),
      ),
    );

    if (fullWidth && width == null) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }
}
