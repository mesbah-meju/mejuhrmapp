import 'package:flutter/material.dart';

class TFormDivider extends StatelessWidget {
  const TFormDivider({super.key, required this.dividerText});

  final String dividerText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Flexible(child: Divider(color: Color(0xFFE2E8F0), thickness: 1, indent: 20, endIndent: 12)),
        Text(
          dividerText,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF94A3B8),
          ),
        ),
        const Flexible(child: Divider(color: Color(0xFFE2E8F0), thickness: 1, indent: 12, endIndent: 20)),
      ],
    );
  }
}
