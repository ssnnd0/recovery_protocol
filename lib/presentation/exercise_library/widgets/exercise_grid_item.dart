import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExerciseGridItem extends StatelessWidget {
  final Map<String, dynamic> exercise;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final bool isFavorite;

  const ExerciseGridItem({
    super.key,
    required this.exercise,
    required this.onTap,
    this.onLongPress,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with favorite indicator
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: CustomImageWidget(
                      imageUrl: exercise['thumbnail'] as String? ?? '',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Play button overlay
                  Positioned(
                    top: 2.w,
                    left: 2.w,
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: CustomIconWidget(
                        iconName: 'play_arrow',
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  // Favorite indicator
                  if (isFavorite)
                    Positioned(
                      top: 2.w,
                      right: 2.w,
                      child: Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: CustomIconWidget(
                          iconName: 'favorite',
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  // Duration badge
                  Positioned(
                    bottom: 2.w,
                    right: 2.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        exercise['duration'] as String? ?? '0:00',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Exercise details
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Exercise name
                    Text(
                      exercise['name'] as String? ?? 'Unknown Exercise',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    // Difficulty and equipment row
                    Row(
                      children: [
                        // Difficulty indicator
                        _buildDifficultyIndicator(
                            exercise['difficulty'] as String? ?? 'beginner'),
                        const Spacer(),
                        // Equipment icons
                        if (exercise['equipment'] != null)
                          _buildEquipmentIcons(
                              exercise['equipment'] as List<dynamic>),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    // Target body areas
                    if (exercise['targetAreas'] != null)
                      _buildTargetAreas(
                          exercise['targetAreas'] as List<dynamic>),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyIndicator(String difficulty) {
    Color difficultyColor;
    int level;

    switch (difficulty.toLowerCase()) {
      case 'beginner':
        difficultyColor = AppTheme.lightTheme.colorScheme.secondary;
        level = 1;
        break;
      case 'intermediate':
        difficultyColor = const Color(0xFFF59E0B);
        level = 2;
        break;
      case 'advanced':
        difficultyColor = AppTheme.lightTheme.colorScheme.error;
        level = 3;
        break;
      default:
        difficultyColor = AppTheme.lightTheme.colorScheme.secondary;
        level = 1;
    }

    return Row(
      children: List.generate(3, (index) {
        return Container(
          width: 1.5.w,
          height: 1.5.w,
          margin: EdgeInsets.only(right: 0.5.w),
          decoration: BoxDecoration(
            color: index < level
                ? difficultyColor
                : difficultyColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(1),
          ),
        );
      }),
    );
  }

  Widget _buildEquipmentIcons(List<dynamic> equipment) {
    if (equipment.isEmpty) return const SizedBox.shrink();

    return Row(
      children: equipment.take(2).map((eq) {
        return Padding(
          padding: EdgeInsets.only(left: 1.w),
          child: CustomIconWidget(
            iconName: _getEquipmentIcon(eq as String),
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 14,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTargetAreas(List<dynamic> targetAreas) {
    if (targetAreas.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 1.w,
      children: targetAreas.take(2).map((area) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.2.h),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            area as String,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontSize: 9.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getEquipmentIcon(String equipment) {
    switch (equipment.toLowerCase()) {
      case 'dumbbell':
      case 'dumbbells':
        return 'fitness_center';
      case 'resistance band':
      case 'band':
        return 'linear_scale';
      case 'foam roller':
        return 'roller_skating';
      case 'mat':
      case 'yoga mat':
        return 'sports_gymnastics';
      case 'ball':
      case 'exercise ball':
        return 'sports_volleyball';
      case 'none':
      case 'bodyweight':
        return 'accessibility_new';
      default:
        return 'sports_gymnastics';
    }
  }
}
