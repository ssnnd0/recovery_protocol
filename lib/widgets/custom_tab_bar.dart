import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // Add this import for DragStartBehavior
import 'package:google_fonts/google_fonts.dart';

/// Tab item data class for custom tab bar
class TabItem {
  final String label;
  final IconData? icon;
  final Widget? customIcon;

  const TabItem({
    required this.label,
    this.icon,
    this.customIcon,
  });
}

/// Custom tab bar widget implementing Scientific Minimalism design
/// with therapeutic depth color palette for content organization
class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.isScrollable = false,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorWeight = 3.0,
    this.indicatorPadding = EdgeInsets.zero,
    this.labelPadding,
    this.tabAlignment,
    this.physics,
    this.onTap,
    this.dividerColor,
    this.dividerHeight,
  });

  final List<TabItem> tabs;
  final TabController? controller;
  final bool isScrollable;
  final Color? indicatorColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final double indicatorWeight;
  final EdgeInsetsGeometry indicatorPadding;
  final EdgeInsetsGeometry? labelPadding;
  final TabAlignment? tabAlignment;
  final ScrollPhysics? physics;
  final ValueChanged<int>? onTap;
  final Color? dividerColor;
  final double? dividerHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: dividerHeight != null && dividerHeight! > 0
            ? Border(
                bottom: BorderSide(
                  color: dividerColor ??
                      (theme.brightness == Brightness.light
                          ? const Color(0xFFE5E7EB)
                          : const Color(0xFF374151)),
                  width: dividerHeight!,
                ),
              )
            : null,
      ),
      child: TabBar(
        controller: controller,
        tabs: tabs.map((tabItem) => _buildTab(context, tabItem)).toList(),
        isScrollable: isScrollable,
        indicatorColor: indicatorColor ?? colorScheme.primary,
        labelColor: labelColor ?? colorScheme.primary,
        unselectedLabelColor: unselectedLabelColor ??
            (theme.brightness == Brightness.light
                ? const Color(0xFF6B7280)
                : const Color(0xFF9CA3AF)),
        indicatorWeight: indicatorWeight,
        indicatorPadding: indicatorPadding,
        labelPadding: labelPadding ??
            (isScrollable ? const EdgeInsets.symmetric(horizontal: 16) : null),
        tabAlignment: tabAlignment,
        physics: physics,
        onTap: onTap,
        labelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        indicatorSize: TabBarIndicatorSize.label,
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }

  Widget _buildTab(BuildContext context, TabItem tabItem) {
    if (tabItem.customIcon != null) {
      return Tab(
        icon: tabItem.customIcon,
        text: tabItem.label,
        iconMargin: const EdgeInsets.only(bottom: 4),
      );
    } else if (tabItem.icon != null) {
      return Tab(
        icon: Icon(
          tabItem.icon,
          size: 20,
        ),
        text: tabItem.label,
        iconMargin: const EdgeInsets.only(bottom: 4),
      );
    } else {
      return Tab(
        text: tabItem.label,
        height: 48,
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Custom tab bar view for content display
class CustomTabBarView extends StatelessWidget {
  const CustomTabBarView({
    super.key,
    required this.children,
    this.controller,
    this.physics,
    this.dragStartBehavior = DragStartBehavior.start,
    this.viewportFraction = 1.0,
    this.clipBehavior = Clip.hardEdge,
  });

  final List<Widget> children;
  final TabController? controller;
  final ScrollPhysics? physics;
  final DragStartBehavior dragStartBehavior;
  final double viewportFraction;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller,
      physics: physics,
      dragStartBehavior: dragStartBehavior,
      viewportFraction: viewportFraction,
      clipBehavior: clipBehavior,
      children: children,
    );
  }
}