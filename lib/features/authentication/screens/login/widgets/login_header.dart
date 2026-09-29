import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:auth_ui_app/utils/constants/sizes.dart';
import 'package:auth_ui_app/utils/constants/text_strings.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

class TLoginHeader extends StatelessWidget {
  const TLoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HRM Brand Emblem
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF3B82F6),
                Color(0xFF1D4ED8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1D4ED8).withOpacity(0.3),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Iconsax.people,
              size: 32,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),
        Text(
          TTexts.loginTitle,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: TSizes.sm),
        Text(
          TTexts.loginSubTitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: dark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
        ),
      ],
    );
  }
}

