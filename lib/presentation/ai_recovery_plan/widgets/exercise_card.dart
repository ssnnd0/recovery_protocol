import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExerciseCard extends StatelessWidget {
  final Map<String, dynamic> exercise;
  final VoidCallback onTap;
  final VoidCallback onPreview;
  final VoidCallback onSubstitution;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.onTap,
    required this.onPreview,
    required this.onSubstitution,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(exercise["id"]),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onPreview(),
              backgroundColor: theme.colorScheme.secondary,
              foregroundColor: theme.colorScheme.onSecondary,
              icon: Icons.play_circle_outline,
              label: 'Preview',
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onSubstitution(),
              backgroundColor: theme.colorScheme.tertiary,
              foregroundColor: theme.colorScheme.onTertiary,
              icon: Icons.swap_horiz,
              label: 'Substitute',
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
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
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CustomImageWidget(
                      imageUrl: exercise["thumbnail"] as String,
                      width: 20.w,
                      height: 20.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise["name"] as String,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'schedule',
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 16,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              exercise["duration"] as String,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Wrap(
                          spacing: 2.w,
                          children: (exercise["targetAreas"] as List)
                              .map((area) => Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2.w,
                                      vertical: 0.5.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      area as String,
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  CustomIconWidget(
                    iconName: 'chevron_right',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
