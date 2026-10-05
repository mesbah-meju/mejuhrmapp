import 'package:flutter/material.dart';

class HrmNavItem {
  final String label;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final int badgeCount;

  const HrmNavItem({
    required this.label,
    required this.activeIcon,
    required this.inactiveIcon,
    this.badgeCount = 0,
  });
}

class HrmBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<HrmNavItem> items;
  final Color? activeColor;
  final Color? inactiveColor;

  const HrmBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final primary = activeColor ?? Theme.of(context).primaryColor;
    final muted = inactiveColor ?? const Color(0xFF64748B);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFF1F5F9), width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = currentIndex == index;

              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Icon with Scale & Optional Badge
                      Badge(
                        isLabelVisible: item.badgeCount > 0,
                        label: Text(
                          item.badgeCount > 99 ? '99+' : item.badgeCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: const Color(0xFFEF4444),
                        offset: const Offset(6, -4),
                        child: AnimatedScale(
                          scale: isSelected ? 1.12 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          child: Icon(
                            isSelected ? item.activeIcon : item.inactiveIcon,
                            color: isSelected ? primary : muted,
                            size: 23,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),

                      // Animated Label
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? primary : muted,
                          letterSpacing: -0.1,
                        ),
                        child: Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Short Rounded Bottom Indicator Line
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        width: isSelected ? 18.0 : 0.0,
                        height: 3.5,
                        decoration: BoxDecoration(
                          color: isSelected ? primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
