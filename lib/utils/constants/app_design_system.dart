import 'package:flutter/material.dart';

// ============================================================================
// HRM APP DESIGN SYSTEM
// Central design tokens used across ALL screens for visual consistency.
// ============================================================================

/// App-wide color palette
class AppColors {
  AppColors._();

  // Backgrounds
  static const Color scaffold = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color surfaceMuted = Color(0xFFF1F5F9);
  static const Color surfaceCard = Colors.white;

  // Borders
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderMuted = Color(0xFFF1F5F9);

  // Text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textPlaceholder = Color(0xFFCBD5E1);

  // Primary (Blue) — actions, navigation selected, in-progress
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFFEFF6FF);
  static const Color primaryMid = Color(0xFFBFDBFE);
  static const Color primaryDark = Color(0xFF1D4ED8);

  // Green — success, achieved, present, paid, valid
  static const Color success = Color(0xFF059669);
  static const Color successLight = Color(0xFFECFDF5);
  static const Color successMid = Color(0xFFA7F3D0);

  // Orange — pending, warning, near deadline
  static const Color warning = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFFFBEB);
  static const Color warningMid = Color(0xFFFDE68A);

  // Red — overdue, error, absent, destructive
  static const Color danger = Color(0xFFDC2626);
  static const Color dangerLight = Color(0xFFFFF1F2);
  static const Color dangerMid = Color(0xFFFECACA);

  // Purple — secondary analytics (use sparingly)
  static const Color accent = Color(0xFF7C3AED);
  static const Color accentLight = Color(0xFFFAF5FF);

  // Neutral
  static const Color neutral = Color(0xFF64748B);
  static const Color neutralLight = Color(0xFFF8FAFC);

  // Nav
  static const Color navActive = Color(0xFF2563EB);
  static const Color navInactive = Color(0xFF94A3B8);
}

/// App-wide spacing tokens
class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double base = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;

  /// Standard page horizontal padding
  static const double pagePaddingH = 16.0;

  /// Standard page vertical padding
  static const double pagePaddingV = 12.0;

  /// Gap between cards on a page
  static const double cardGap = 12.0;
}

/// App-wide border radius tokens
class AppRadius {
  AppRadius._();

  static const double xs = 6.0;
  static const double sm = 10.0;
  static const double md = 14.0;
  static const double lg = 18.0;
  static const double xl = 22.0;
  static const double xxl = 28.0;
  static const double full = 999.0;

  static const Radius circle = Radius.circular(full);
  static BorderRadius card = BorderRadius.circular(lg);
  static BorderRadius cardLg = BorderRadius.circular(xl);
  static BorderRadius button = BorderRadius.circular(md);
  static BorderRadius pill = BorderRadius.circular(full);
  static BorderRadius badge = BorderRadius.circular(xs);
}

/// App-wide text style helpers
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Inter';

  // Heading styles
  static const TextStyle pageTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.4,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // Body styles
  static const TextStyle body = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodyBold = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  static const TextStyle captionBold = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
  );

  // Label styles
  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  // Metric / number styles
  static const TextStyle metric = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle metricSm = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  // Page subtitle
  static const TextStyle subtitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );
}

/// Shared card decoration factory
class AppDecorations {
  AppDecorations._();

  static BoxDecoration card({
    Color? color,
    double radius = AppRadius.lg,
    bool showBorder = true,
    bool showShadow = true,
  }) {
    return BoxDecoration(
      color: color ?? AppColors.surface,
      borderRadius: BorderRadius.circular(radius),
      border: showBorder ? Border.all(color: AppColors.border) : null,
      boxShadow: showShadow
          ? [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ]
          : null,
    );
  }

  static BoxDecoration statusBadge(Color bg) {
    return BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(AppRadius.xs),
    );
  }

  static BoxDecoration iconBox(Color bg, {double radius = AppRadius.sm}) {
    return BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(radius),
    );
  }

  static BoxDecoration primaryCard() {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1D4ED8), Color(0xFF2563EB), Color(0xFF3B82F6)],
      ),
      borderRadius: BorderRadius.circular(AppRadius.xl),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.3),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  static BoxDecoration successCard() {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF047857), Color(0xFF059669), Color(0xFF10B981)],
      ),
      borderRadius: BorderRadius.circular(AppRadius.xl),
      boxShadow: [
        BoxShadow(
          color: AppColors.success.withValues(alpha: 0.3),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }
}

/// Icon sizes
class AppIconSizes {
  AppIconSizes._();

  static const double xs = 14.0;
  static const double sm = 16.0;
  static const double md = 20.0;
  static const double lg = 24.0;
  static const double xl = 28.0;
  static const double xxl = 32.0;
}

// ============================================================================
// REUSABLE WIDGET COMPONENTS
// ============================================================================

/// Standard page header used by all module screens (Tasks, Attendance, etc.)
class AppPageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onHistoryTap;
  final String historyLabel;
  final Widget? trailingWidget;
  final bool showHistory;

  const AppPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onHistoryTap,
    this.historyLabel = 'History',
    this.trailingWidget,
    this.showHistory = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pagePaddingH,
        vertical: AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Title + Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.pageTitle),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: AppTextStyles.subtitle),
                ],
              ],
            ),
          ),

          // Right: History button or custom trailing widget
          if (trailingWidget != null)
            trailingWidget!
          else if (showHistory && onHistoryTap != null)
            _HistoryPillButton(
              label: historyLabel,
              onTap: onHistoryTap!,
            ),
        ],
      ),
    );
  }
}

/// History pill button — shared across Tasks, Attendance, Targets, Payroll
class _HistoryPillButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _HistoryPillButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.history_rounded, size: AppIconSizes.sm, color: AppColors.textPrimary),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Back-navigation header for detail screens
class AppDetailHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onBack;
  final Widget? action;

  const AppDetailHeader({
    super.key,
    required this.title,
    this.subtitle,
    required this.onBack,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.chevron_left_rounded, size: AppIconSizes.xl, color: AppColors.textPrimary),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.3)),
                if (subtitle != null) Text(subtitle!, style: AppTextStyles.subtitle),
              ],
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}

/// Period selector tabs (Today / This Week / This Month)
class AppPeriodSelector extends StatelessWidget {
  final List<String> periods;
  final String selected;
  final ValueChanged<String> onChanged;

  const AppPeriodSelector({
    super.key,
    required this.periods,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: periods.map((p) {
          final isSelected = p == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(p),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  p,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? AppColors.primary : AppColors.textMuted,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Status badge chip
class AppStatusBadge extends StatelessWidget {
  final String label;
  final AppBadgeStyle style;

  const AppStatusBadge({
    super.key,
    required this.label,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (style) {
      case AppBadgeStyle.success:
        bgColor = AppColors.successLight;
        textColor = AppColors.success;
        break;
      case AppBadgeStyle.warning:
        bgColor = AppColors.warningLight;
        textColor = AppColors.warning;
        break;
      case AppBadgeStyle.danger:
        bgColor = AppColors.dangerLight;
        textColor = AppColors.danger;
        break;
      case AppBadgeStyle.primary:
        bgColor = AppColors.primaryLight;
        textColor = AppColors.primary;
        break;
      case AppBadgeStyle.neutral:
        bgColor = AppColors.surfaceMuted;
        textColor = AppColors.neutral;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(AppRadius.xs)),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: textColor)),
    );
  }
}

enum AppBadgeStyle { success, warning, danger, primary, neutral }

/// Compact metric summary card (used in dashboard & me page)
class AppSummaryCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String value;
  final String? subtitle;
  final VoidCallback? onTap;

  const AppSummaryCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.value,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(AppRadius.sm)),
                  child: Icon(icon, color: iconColor, size: AppIconSizes.sm),
                ),
                if (onTap != null) const Icon(Icons.chevron_right_rounded, size: 14, color: AppColors.textPlaceholder),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(value, style: AppTextStyles.metricSm),
            const SizedBox(height: 2),
            Text(title, style: AppTextStyles.caption),
            if (subtitle != null) Text(subtitle!, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

/// Empty state widget — consistent across all screens
class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: AppColors.textMuted),
            ),
            const SizedBox(height: AppSpacing.base),
            Text(title, style: AppTextStyles.cardTitle, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.xs),
            Text(description, style: AppTextStyles.caption, textAlign: TextAlign.center),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.base),
              TextButton(
                onPressed: onAction,
                child: Text(actionLabel!, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Skeleton loading card
class AppSkeletonCard extends StatefulWidget {
  final double height;
  final double? width;
  final double radius;

  const AppSkeletonCard({
    super.key,
    this.height = 80,
    this.width,
    this.radius = AppRadius.lg,
  });

  @override
  State<AppSkeletonCard> createState() => _AppSkeletonCardState();
}

class _AppSkeletonCardState extends State<AppSkeletonCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this)..repeat(reverse: true);
    _shimmer = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (context, child) {
        return Container(
          height: widget.height,
          width: widget.width ?? double.infinity,
          decoration: BoxDecoration(
            color: Color.lerp(const Color(0xFFE2E8F0), const Color(0xFFF1F5F9), _shimmer.value),
            borderRadius: BorderRadius.circular(widget.radius),
          ),
        );
      },
    );
  }
}

/// Skeleton row with icon, title, subtitle
class AppSkeletonRow extends StatelessWidget {
  const AppSkeletonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const AppSkeletonCard(height: 38, width: 38, radius: AppRadius.sm),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppSkeletonCard(height: 14, radius: AppRadius.xs),
                const SizedBox(height: 6),
                Row(children: const [
                  Expanded(flex: 2, child: AppSkeletonCard(height: 10, radius: AppRadius.xs)),
                  Spacer(flex: 1),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Section header widget (section title with optional action link)
class AppSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.sectionTitle),
        if (actionLabel != null && onAction != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
          ),
      ],
    );
  }
}

/// Animated linear progress bar with smooth updates
class AppProgressBar extends StatelessWidget {
  final double value; // 0.0 to 1.0+
  final Color? color;
  final double height;

  const AppProgressBar({
    super.key,
    required this.value,
    this.color,
    this.height = 5,
  });

  @override
  Widget build(BuildContext context) {
    final clampedValue = value.clamp(0.0, 1.0);
    final barColor = color ?? (value >= 1.0 ? AppColors.success : AppColors.primary);

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        tween: Tween<double>(begin: 0, end: clampedValue),
        builder: (context, animValue, child) {
          return LinearProgressIndicator(
            value: animValue,
            backgroundColor: AppColors.surfaceMuted,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
            minHeight: height,
          );
        },
      ),
    );
  }
}

/// Filter tab row (All / Completed / Pending / Overdue)
class AppFilterTabs extends StatelessWidget {
  final List<String> tabs;
  final String selected;
  final ValueChanged<String> onChanged;

  const AppFilterTabs({
    super.key,
    required this.tabs,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: tabs.map((t) {
          final isSelected = t == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(t),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryLight : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  t,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? AppColors.primary : AppColors.textMuted,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Primary action button — standard across the app
class AppPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? color;
  final double height;

  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.color,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: AppIconSizes.md),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

/// Outlined danger button — for Log Out style actions
class AppDangerButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  const AppDangerButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.danger,
          side: const BorderSide(color: AppColors.dangerMid, width: 1.5),
          backgroundColor: AppColors.dangerLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: AppIconSizes.md, color: AppColors.danger),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.danger)),
          ],
        ),
      ),
    );
  }
}

/// Standard icon box (small icon container used in list rows)
class AppIconBox extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final double size;
  final double padding;

  const AppIconBox({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    this.size = AppIconSizes.sm,
    this.padding = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(AppRadius.sm)),
      child: Icon(icon, color: iconColor, size: size),
    );
  }
}

/// Divider used inside cards (indent for icon alignment)
class AppCardDivider extends StatelessWidget {
  final double indent;

  const AppCardDivider({super.key, this.indent = 0});

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, indent: indent, color: AppColors.borderMuted);
  }
}

/// Info row used for detail pages (label + value)
class AppInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const AppInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTextStyles.body),
              Expanded(
                child: Text(value, style: AppTextStyles.bodyBold, textAlign: TextAlign.end, maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
        if (!isLast) const AppCardDivider(indent: 0),
      ],
    );
  }
}

/// Ledger row for payroll breakdown (item + amount)
class AppLedgerRow extends StatelessWidget {
  final String label;
  final String amount;
  final bool isTotal;
  final Color? amountColor;

  const AppLedgerRow({
    super.key,
    required this.label,
    required this.amount,
    this.isTotal = false,
    this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary)
                : const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isTotal ? 14 : 12.5,
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.w700,
              color: amountColor ?? (isTotal ? AppColors.textPrimary : AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
