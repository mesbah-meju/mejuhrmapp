import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:auth_ui_app/utils/constants/colors.dart';
import 'package:auth_ui_app/utils/constants/sizes.dart';
import 'package:auth_ui_app/utils/helpers/helper_functions.dart';

enum HrmSlideType { attendance, payroll, team }

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.slideType,
    required this.title,
    required this.subTitle,
  });

  final HrmSlideType slideType;
  final String title, subTitle;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
        child: Column(
          children: [
            SizedBox(height: THelperFunctions.screenHeight() * 0.06),

            // Rich HRM Visual Card
            _buildIllustration(context, dark),

            const SizedBox(height: TSizes.spaceBtwSections),

            // Title
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // SubTitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
              child: Text(
                subTitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: dark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      height: 1.5,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections * 1.5),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(BuildContext context, bool dark) {
    switch (slideType) {
      case HrmSlideType.attendance:
        return _buildAttendanceCard(dark);
      case HrmSlideType.payroll:
        return _buildPayrollCard(dark);
      case HrmSlideType.team:
        return _buildTeamCard(dark);
    }
  }

  // 1. Attendance & Geo-Location Card
  Widget _buildAttendanceCard(bool dark) {
    return Container(
      width: double.infinity,
      height: 290,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [const Color(0xFFEEF2FF), const Color(0xFFE0E7FF)],
        ),
        border: Border.all(
          color: dark ? const Color(0xFF334155) : const Color(0xFFC7D2FE),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: TColors.primary.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background ambient circles
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: TColors.primary.withOpacity(0.08),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(TSizes.md),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Pulsing GPS & Clock-in Indicator
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF3B82F6).withOpacity(0.18),
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2563EB).withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Iconsax.location,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                // Geo-fencing Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF10B981).withOpacity(0.4),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 16),
                      SizedBox(width: 6),
                      Text(
                        "Office Geofence Verified",
                        style: TextStyle(
                          color: Color(0xFF10B981),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TSizes.md),

                // Live Shift Stat Pill
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: dark ? const Color(0xFF0F172A).withOpacity(0.8) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: dark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text("Clock In", style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                          SizedBox(height: 2),
                          Text("09:00 AM", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                      VerticalDivider(thickness: 1, width: 20),
                      Column(
                        children: [
                          Text("Shift Type", style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                          SizedBox(height: 2),
                          Text("Regular (9h)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                      VerticalDivider(thickness: 1, width: 20),
                      Column(
                        children: [
                          Text("Status", style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                          SizedBox(height: 2),
                          Text("On Time", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981), fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. Leaves & Payroll Hub Card
  Widget _buildPayrollCard(bool dark) {
    return Container(
      width: double.infinity,
      height: 290,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [const Color(0xFFF0FDF4), const Color(0xFFDCFCE7)],
        ),
        border: Border.all(
          color: dark ? const Color(0xFF334155) : const Color(0xFFBBF7D0),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(TSizes.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Floating Leave & Salary Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF059669).withOpacity(0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Iconsax.calendar_tick, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4F46E5).withOpacity(0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Iconsax.wallet_money, color: Colors.white, size: 26),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Balance Summary Tile
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: dark ? const Color(0xFF0F172A).withOpacity(0.8) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: dark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFFDCFCE7),
                    child: Icon(Iconsax.document_text, color: Color(0xFF16A34A), size: 18),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Annual Leave Balance", style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                        Text("14 Days Available", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                  ),
                  Text("Approved", style: TextStyle(color: Color(0xFF16A34A), fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Payslip Notification Tile
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: dark ? const Color(0xFF0F172A).withOpacity(0.8) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: dark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFFEEF2FF),
                    child: Icon(Iconsax.receipt_item, color: Color(0xFF4F46E5), size: 18),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Latest Payslip", style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                        Text("Salary Disbursed", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                  ),
                  Icon(Icons.download_rounded, color: Color(0xFF4F46E5), size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. Team & Performance Insights Card
  Widget _buildTeamCard(bool dark) {
    return Container(
      width: double.infinity,
      height: 290,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [const Color(0xFFFAF5FF), const Color(0xFFF3E8FF)],
        ),
        border: Border.all(
          color: dark ? const Color(0xFF334155) : const Color(0xFFE9D5FF),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(TSizes.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Center KPI Progress badge
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: dark ? const Color(0xFF0F172A).withOpacity(0.8) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: dark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Iconsax.chart_2, color: Color(0xFF8B5CF6), size: 20),
                          SizedBox(width: 8),
                          Text("Performance & KPI Score", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        ],
                      ),
                      Text("96%", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6), fontSize: 15)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: const LinearProgressIndicator(
                      value: 0.96,
                      backgroundColor: Color(0xFFF3E8FF),
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Team presence pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: dark ? const Color(0xFF0F172A).withOpacity(0.8) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: dark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                ),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFFF3E8FF),
                    child: Icon(Iconsax.profile_2user, color: Color(0xFF8B5CF6), size: 18),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Active Team Members", style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                        Text("48 On Duty Today", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                  ),
                  Icon(Icons.fiber_manual_record, color: Color(0xFF10B981), size: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
