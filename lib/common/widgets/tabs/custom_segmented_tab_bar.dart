import 'package:flutter/material.dart';

/// Data class representing a single tab item in [CustomSegmentedTabBar]
class SegmentTab {
  final String label;
  final Widget? icon;
  final int? badgeCount;
  final String? badgeText;
  final Color? badgeColor;
  final Color? badgeTextColor;
  final bool disabled;

  const SegmentTab({
    required this.label,
    this.icon,
    this.badgeCount,
    this.badgeText,
    this.badgeColor,
    this.badgeTextColor,
    this.disabled = false,
  });
}

/// Generic item representation for [CustomSegmentedControl]
class SegmentOption<T> {
  final T value;
  final String label;
  final Widget? icon;
  final int? badgeCount;
  final String? badgeText;
  final Color? badgeColor;
  final bool disabled;

  const SegmentOption({
    required this.value,
    required this.label,
    this.icon,
    this.badgeCount,
    this.badgeText,
    this.badgeColor,
    this.disabled = false,
  });
}

/// A modern, shadcn / iOS-inspired Segmented Tab Bar for Flutter.
///
/// Can be used as a standalone widget or as [PreferredSizeWidget] in `AppBar.bottom`.
///
/// Features:
/// - Pill container with active elevated white tab card and subtle shadow.
/// - Fluid tab switching with animation.
/// - Plugs seamlessly into [TabController] or [selectedIndex] callback.
/// - Badge / count pill support.
/// - Fully customizable colors, borders, paddings, and heights.
class CustomSegmentedTabBar extends StatefulWidget implements PreferredSizeWidget {
  final TabController? controller;
  final List<SegmentTab> tabs;
  final int selectedIndex;
  final ValueChanged<int>? onTabChanged;
  final Color backgroundColor;
  final Color activeTabColor;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final Color borderColor;
  final double borderRadius;
  final double tabBorderRadius;
  final double height;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final bool isExpanded;
  final bool isScrollable;

  const CustomSegmentedTabBar({
    super.key,
    this.controller,
    required this.tabs,
    this.selectedIndex = 0,
    this.onTabChanged,
    this.backgroundColor = const Color(0xFFF1F5F9),
    this.activeTabColor = Colors.white,
    this.activeTextColor = const Color(0xFF2563EB),
    this.inactiveTextColor = const Color(0xFF64748B),
    this.borderColor = const Color(0xFFE2E8F0),
    this.borderRadius = 14.0,
    this.tabBorderRadius = 10.0,
    this.height = 46.0,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.padding = const EdgeInsets.all(4.0),
    this.isExpanded = true,
    this.isScrollable = false,
  });

  /// Factory helper for simple string labels
  factory CustomSegmentedTabBar.fromLabels({
    Key? key,
    TabController? controller,
    required List<String> labels,
    int selectedIndex = 0,
    ValueChanged<int>? onTabChanged,
    Color backgroundColor = const Color(0xFFF1F5F9),
    Color activeTabColor = Colors.white,
    Color activeTextColor = const Color(0xFF2563EB),
    Color inactiveTextColor = const Color(0xFF64748B),
    double height = 46.0,
    EdgeInsetsGeometry margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    bool isExpanded = true,
  }) {
    return CustomSegmentedTabBar(
      key: key,
      controller: controller,
      tabs: labels.map((l) => SegmentTab(label: l)).toList(),
      selectedIndex: selectedIndex,
      onTabChanged: onTabChanged,
      backgroundColor: backgroundColor,
      activeTabColor: activeTabColor,
      activeTextColor: activeTextColor,
      inactiveTextColor: inactiveTextColor,
      height: height,
      margin: margin,
      isExpanded: isExpanded,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        height + (margin.vertical),
      );

  @override
  State<CustomSegmentedTabBar> createState() => _CustomSegmentedTabBarState();
}

class _CustomSegmentedTabBarState extends State<CustomSegmentedTabBar> {
  late int _currentIndex;
  double _animationValue = 0.0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.controller?.index ?? widget.selectedIndex;
    _animationValue = _currentIndex.toDouble();
    widget.controller?.animation?.addListener(_handleTabAnimation);
    widget.controller?.addListener(_handleTabControllerChange);
  }

  @override
  void didUpdateWidget(CustomSegmentedTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.animation?.removeListener(_handleTabAnimation);
      oldWidget.controller?.removeListener(_handleTabControllerChange);
      widget.controller?.animation?.addListener(_handleTabAnimation);
      widget.controller?.addListener(_handleTabControllerChange);
      _currentIndex = widget.controller?.index ?? widget.selectedIndex;
      _animationValue = _currentIndex.toDouble();
    } else if (widget.controller == null && widget.selectedIndex != _currentIndex) {
      _currentIndex = widget.selectedIndex;
      _animationValue = _currentIndex.toDouble();
    }
  }

  @override
  void dispose() {
    widget.controller?.animation?.removeListener(_handleTabAnimation);
    widget.controller?.removeListener(_handleTabControllerChange);
    super.dispose();
  }

  void _handleTabAnimation() {
    if (widget.controller?.animation != null && mounted) {
      setState(() {
        _animationValue = widget.controller!.animation!.value;
        _currentIndex = widget.controller!.index;
      });
    }
  }

  void _handleTabControllerChange() {
    if (widget.controller != null && widget.controller!.index != _currentIndex && mounted) {
      setState(() {
        _currentIndex = widget.controller!.index;
        _animationValue = _currentIndex.toDouble();
      });
    }
  }

  void _onTabSelected(int index) {
    if (widget.tabs[index].disabled) return;

    if (widget.controller != null) {
      widget.controller!.animateTo(index);
    } else {
      setState(() {
        _currentIndex = index;
        _animationValue = index.toDouble();
      });
    }
    widget.onTabChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final tabCount = widget.tabs.length;
    final hasController = widget.controller != null;

    final alignmentX = tabCount > 1
        ? (-1.0 + (2.0 * (hasController ? _animationValue : _currentIndex) / (tabCount - 1))).clamp(-1.0, 1.0)
        : 0.0;

    final indicatorCard = FractionallySizedBox(
      widthFactor: tabCount > 0 ? 1.0 / tabCount : 1.0,
      heightFactor: 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: widget.activeTabColor,
          borderRadius: BorderRadius.circular(widget.tabBorderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
            BoxShadow(
              color: widget.activeTextColor.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );

    return Container(
      margin: widget.margin,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: widget.borderColor, width: 1),
      ),
      padding: widget.padding,
      child: widget.isScrollable
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  widget.tabs.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: _buildTabItem(index, isExpanded: false),
                  ),
                ),
              ),
            )
          : Stack(
              children: [
                // 1. Single smooth sliding indicator card
                if (hasController)
                  Align(
                    alignment: Alignment(alignmentX, 0.0),
                    child: indicatorCard,
                  )
                else
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeInOutCubic,
                    alignment: Alignment(alignmentX, 0.0),
                    child: indicatorCard,
                  ),

                // 2. Interactive text/icon labels layer
                Row(
                  children: List.generate(
                    widget.tabs.length,
                    (index) => widget.isExpanded
                        ? Expanded(child: _buildTabItem(index, isExpanded: true))
                        : _buildTabItem(index, isExpanded: false),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTabItem(int index, {required bool isExpanded}) {
    final tab = widget.tabs[index];
    final isSelected = _currentIndex == index;

    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      alignment: Alignment.center,
      color: Colors.transparent,
      child: Row(
        mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (tab.icon != null) ...[
            AnimatedTheme(
              data: Theme.of(context).copyWith(
                iconTheme: IconThemeData(
                  size: 16,
                  color: isSelected ? widget.activeTextColor : widget.inactiveTextColor,
                ),
              ),
              child: tab.icon!,
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? widget.activeTextColor : widget.inactiveTextColor,
                letterSpacing: -0.1,
              ),
              child: Text(
                tab.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (tab.badgeCount != null || tab.badgeText != null) ...[
            const SizedBox(width: 6),
            _buildBadge(tab, isSelected),
          ],
        ],
      ),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: tab.disabled ? null : () => _onTabSelected(index),
        borderRadius: BorderRadius.circular(widget.tabBorderRadius),
        splashColor: widget.activeTextColor.withValues(alpha: 0.05),
        highlightColor: Colors.transparent,
        child: child,
      ),
    );
  }

  Widget _buildBadge(SegmentTab tab, bool isSelected) {
    final text = tab.badgeText ?? '${tab.badgeCount}';
    final bg = tab.badgeColor ??
        (isSelected
            ? widget.activeTextColor.withValues(alpha: 0.12)
            : const Color(0xFFE2E8F0));
    final textColor = tab.badgeTextColor ??
        (isSelected ? widget.activeTextColor : const Color(0xFF475569));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}

/// Generic Value-based Segmented Control (e.g. for reactive state management)
class CustomSegmentedControl<T> extends StatelessWidget {
  final T selectedValue;
  final List<SegmentOption<T>> items;
  final ValueChanged<T> onValueChanged;
  final Color backgroundColor;
  final Color activeTabColor;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final Color borderColor;
  final double borderRadius;
  final double tabBorderRadius;
  final double height;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final bool isExpanded;

  const CustomSegmentedControl({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.onValueChanged,
    this.backgroundColor = const Color(0xFFF1F5F9),
    this.activeTabColor = Colors.white,
    this.activeTextColor = const Color(0xFF2563EB),
    this.inactiveTextColor = const Color(0xFF64748B),
    this.borderColor = const Color(0xFFE2E8F0),
    this.borderRadius = 14.0,
    this.tabBorderRadius = 10.0,
    this.height = 46.0,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.padding = const EdgeInsets.all(4.0),
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final selectedIndex = items.indexWhere((item) => item.value == selectedValue);

    return CustomSegmentedTabBar(
      tabs: items
          .map((item) => SegmentTab(
                label: item.label,
                icon: item.icon,
                badgeCount: item.badgeCount,
                badgeText: item.badgeText,
                badgeColor: item.badgeColor,
                disabled: item.disabled,
              ))
          .toList(),
      selectedIndex: selectedIndex >= 0 ? selectedIndex : 0,
      onTabChanged: (index) {
        if (index >= 0 && index < items.length) {
          onValueChanged(items[index].value);
        }
      },
      backgroundColor: backgroundColor,
      activeTabColor: activeTabColor,
      activeTextColor: activeTextColor,
      inactiveTextColor: inactiveTextColor,
      borderColor: borderColor,
      borderRadius: borderRadius,
      tabBorderRadius: tabBorderRadius,
      height: height,
      margin: margin,
      padding: padding,
      isExpanded: isExpanded,
    );
  }
}

/// A composite header with title, subtitle, optional action button, and segmented tabs.
class CustomHeaderWithTabs extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final List<SegmentTab> tabs;
  final TabController? tabController;
  final int selectedIndex;
  final ValueChanged<int>? onTabChanged;
  final EdgeInsetsGeometry padding;

  const CustomHeaderWithTabs({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.tabs,
    this.tabController,
    this.selectedIndex = 0,
    this.onTabChanged,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 8),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.4,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 12),
          CustomSegmentedTabBar(
            controller: tabController,
            tabs: tabs,
            selectedIndex: selectedIndex,
            onTabChanged: onTabChanged,
            margin: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
