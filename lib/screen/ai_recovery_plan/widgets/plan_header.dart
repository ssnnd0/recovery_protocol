import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PlanHeader extends StatelessWidget {
  final String title;
  final String duration;
  final String difficulty;
  final VoidCallback onCustomize;

  const PlanHeader({
    super.key,
    required this.title,
    required this.duration,
    required this.difficulty,
    required this.onCustomize,
  });

  Color _getDifficultyColor(String difficulty, ColorScheme colorScheme) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.light
                ? const Color(0x14000000)
                : const Color(0x14FFFFFF),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: onCustomize,
                  icon: CustomIconWidget(
                    iconName: 'tune',
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor:
                        theme.colorScheme.primary.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                _buildInfoChip(
                  context,
                  icon: 'schedule',
                  label: duration,
                  color: theme.colorScheme.secondary,
                ),
                SizedBox(width: 3.w),
                _buildInfoChip(
                  context,
                  icon: 'trending_up',
                  label: difficulty,
                  color: _getDifficultyColor(difficulty, theme.colorScheme),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required String icon,
    required String label,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: color,
            size: 16,
          ),
          SizedBox(width: 1.w),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
