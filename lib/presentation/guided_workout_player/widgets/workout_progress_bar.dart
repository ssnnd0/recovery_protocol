import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WorkoutProgressBar extends StatelessWidget {
  final double progress;
  final int currentExercise;
  final int totalExercises;
  final Duration elapsedTime;
  final Duration totalTime;

  const WorkoutProgressBar({
    super.key,
    required this.progress,
    required this.currentExercise,
    required this.totalExercises,
    required this.elapsedTime,
    required this.totalTime,
  });

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Color _getProgressColor() {
    if (progress < 0.3) {
      return AppTheme.lightTheme.primaryColor;
    } else if (progress < 0.7) {
      return const Color(0xFFF59E0B);
    } else {
      return AppTheme.lightTheme.colorScheme.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Progress Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Workout Progress',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Exercise $currentExercise of $totalExercises',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                  vertical: 1.h,
                ),
                decoration: BoxDecoration(
                  color: _getProgressColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: _getProgressColor(),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Progress Bar
          Container(
            width: double.infinity,
            height: 8,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Stack(
              children: [
                // Background
                Container(
                  width: double.infinity,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                // Progress Fill
                FractionallySizedBox(
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.lightTheme.primaryColor,
                          _getProgressColor(),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Time Information
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'schedule',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Elapsed: ${_formatDuration(elapsedTime)}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'timer',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Total: ${_formatDuration(totalTime)}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Exercise Dots Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalExercises, (index) {
              final isCompleted = index < currentExercise - 1;
              final isCurrent = index == currentExercise - 1;

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 1.w),
                width: isCurrent ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppTheme.lightTheme.colorScheme.secondary
                      : isCurrent
                          ? _getProgressColor()
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
