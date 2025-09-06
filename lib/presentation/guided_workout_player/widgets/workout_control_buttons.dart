import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WorkoutControlButtons extends StatelessWidget {
  final VoidCallback? onPreviousExercise;
  final VoidCallback? onPlayPause;
  final VoidCallback? onNextExercise;
  final bool isPlaying;
  final bool canGoPrevious;
  final bool canGoNext;

  const WorkoutControlButtons({
    super.key,
    this.onPreviousExercise,
    this.onPlayPause,
    this.onNextExercise,
    required this.isPlaying,
    this.canGoPrevious = true,
    this.canGoNext = true,
  });

  void _handleButtonPress(VoidCallback? onPressed) {
    if (onPressed != null) {
      HapticFeedback.lightImpact();
      onPressed();
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Previous Exercise Button
          Expanded(
            child: GestureDetector(
              onTap: canGoPrevious
                  ? () => _handleButtonPress(onPreviousExercise)
                  : null,
              child: Container(
                height: 14.h,
                decoration: BoxDecoration(
                  color: canGoPrevious
                      ? AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: canGoPrevious
                        ? AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2)
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'skip_previous',
                      color: canGoPrevious
                          ? AppTheme.lightTheme.colorScheme.onSurface
                          : AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.4),
                      size: 32,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Previous',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: canGoPrevious
                            ? AppTheme.lightTheme.colorScheme.onSurface
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(width: 4.w),

          // Play/Pause Button
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => _handleButtonPress(onPlayPause),
              child: Container(
                height: 14.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.lightTheme.primaryColor,
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.3),
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: isPlaying ? 'pause' : 'play_arrow',
                      color: Colors.white,
                      size: 40,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      isPlaying ? 'Pause' : 'Play',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(width: 4.w),

          // Next Exercise Button
          Expanded(
            child: GestureDetector(
              onTap:
                  canGoNext ? () => _handleButtonPress(onNextExercise) : null,
              child: Container(
                height: 14.h,
                decoration: BoxDecoration(
                  color: canGoNext
                      ? AppTheme.lightTheme.colorScheme.secondary
                          .withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: canGoNext
                        ? AppTheme.lightTheme.colorScheme.secondary
                            .withValues(alpha: 0.3)
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'skip_next',
                      color: canGoNext
                          ? AppTheme.lightTheme.colorScheme.secondary
                          : AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.4),
                      size: 32,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Next',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: canGoNext
                            ? AppTheme.lightTheme.colorScheme.secondary
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
