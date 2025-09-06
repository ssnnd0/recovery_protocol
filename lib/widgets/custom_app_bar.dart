import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom app bar widget implementing Scientific Minimalism design
/// with adaptive behavior for athletic recovery applications
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.showBackButton = true,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.centerTitle = true,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.titleSpacing,
    this.toolbarHeight = kToolbarHeight,
  });

  final String? title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool centerTitle;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final double? titleSpacing;
  final double toolbarHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: foregroundColor ?? colorScheme.onSurface,
                letterSpacing: -0.5,
              ),
            )
          : null,
      backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      elevation: elevation,
      shadowColor: elevation > 0
          ? (theme.brightness == Brightness.light
              ? const Color(0x14000000)
              : const Color(0x14FFFFFF))
          : null,
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading && showBackButton,
      titleSpacing: titleSpacing,
      toolbarHeight: toolbarHeight,
      actions: actions != null
          ? [
              ...actions!,
              const SizedBox(width: 8), // Consistent spacing
            ]
          : null,
      iconTheme: IconThemeData(
        color: foregroundColor ?? colorScheme.onSurface,
        size: 24,
      ),
      actionsIconTheme: IconThemeData(
        color: foregroundColor ?? colorScheme.onSurface,
        size: 24,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}
