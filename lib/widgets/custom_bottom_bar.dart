import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Navigation item data class for bottom navigation
class NavigationItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final String route;

  const NavigationItem({
    required this.label,
    required this.icon,
    this.activeIcon,
    required this.route,
  });
}

/// Custom bottom navigation bar implementing adaptive navigation patterns
/// for athletic recovery and injury prevention applications
class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation = 8,
    this.type = BottomNavigationBarType.fixed,
  });

  final int currentIndex;
  final ValueChanged<int>? onTap;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double elevation;
  final BottomNavigationBarType type;

  // Hardcoded navigation items for athletic recovery app
  static const List<NavigationItem> _navigationItems = [
    NavigationItem(
      label: 'Check-in',
      icon: Icons.health_and_safety_outlined,
      activeIcon: Icons.health_and_safety,
      route: '/wellness-check-in-dashboard',
    ),
    NavigationItem(
      label: 'Recovery',
      icon: Icons.psychology_outlined,
      activeIcon: Icons.psychology,
      route: '/ai-recovery-plan',
    ),
    NavigationItem(
      label: 'Exercises',
      icon: Icons.fitness_center_outlined,
      activeIcon: Icons.fitness_center,
      route: '/exercise-library',
    ),
    NavigationItem(
      label: 'Workout',
      icon: Icons.play_circle_outline,
      activeIcon: Icons.play_circle,
      route: '/guided-workout-player',
    ),
    NavigationItem(
      label: 'Progress',
      icon: Icons.analytics_outlined,
      activeIcon: Icons.analytics,
      route: '/progress-analytics-dashboard',
    ),
  ];

  void _handleTap(BuildContext context, int index) {
    if (onTap != null) {
      onTap!(index);
    }

    // Navigate to the selected route
    if (index < _navigationItems.length) {
      final route = _navigationItems[index].route;
      final currentRoute = ModalRoute.of(context)?.settings.name;

      // Only navigate if not already on the target route
      if (currentRoute != route) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          route,
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color:
            backgroundColor ?? theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: theme.brightness == Brightness.light
                      ? const Color(0x14000000)
                      : const Color(0x14FFFFFF),
                  offset: const Offset(0, -2),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex.clamp(0, _navigationItems.length - 1),
          onTap: (index) => _handleTap(context, index),
          type: type,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: selectedItemColor ?? colorScheme.primary,
          unselectedItemColor: unselectedItemColor ??
              (theme.brightness == Brightness.light
                  ? const Color(0xFF6B7280)
                  : const Color(0xFF9CA3AF)),
          selectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
          items: _navigationItems.map((item) {
            final isSelected = _navigationItems.indexOf(item) == currentIndex;
            return BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Icon(
                  isSelected && item.activeIcon != null
                      ? item.activeIcon!
                      : item.icon,
                  size: 24,
                ),
              ),
              label: item.label,
              tooltip: item.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}
