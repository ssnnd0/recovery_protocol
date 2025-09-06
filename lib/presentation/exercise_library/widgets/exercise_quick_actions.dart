import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExerciseQuickActions extends StatelessWidget {
  final Map<String, dynamic> exercise;
  final VoidCallback onAddToFavorites;
  final VoidCallback onShare;
  final VoidCallback onAddToCustomPlan;
  final VoidCallback onDismiss;

  const ExerciseQuickActions({
    super.key,
    required this.exercise,
    required this.onAddToFavorites,
    required this.onShare,
    required this.onAddToCustomPlan,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Exercise preview
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomImageWidget(
                    imageUrl: exercise['thumbnail'] as String? ?? '',
                    width: 15.w,
                    height: 15.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise['name'] as String? ?? 'Unknown Exercise',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '${exercise['duration'] ?? '0:00'} • ${exercise['difficulty'] ?? 'Beginner'}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onDismiss,
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          // Action buttons
          Padding(
            padding: EdgeInsets.all(2.w),
            child: Column(
              children: [
                _buildActionButton(
                  icon: 'favorite_border',
                  label: 'Add to Favorites',
                  onTap: () {
                    onAddToFavorites();
                    onDismiss();
                  },
                ),
                _buildActionButton(
                  icon: 'share',
                  label: 'Share Exercise',
                  onTap: () {
                    onShare();
                    onDismiss();
                  },
                ),
                _buildActionButton(
                  icon: 'playlist_add',
                  label: 'Add to Custom Plan',
                  onTap: () {
                    onAddToCustomPlan();
                    onDismiss();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        margin: EdgeInsets.symmetric(vertical: 0.5.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
