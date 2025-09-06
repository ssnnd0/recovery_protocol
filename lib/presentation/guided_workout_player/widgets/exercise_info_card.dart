import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExerciseInfoCard extends StatelessWidget {
  final String exerciseName;
  final int currentSet;
  final int totalSets;
  final int currentRep;
  final int totalReps;
  final Duration remainingTime;
  final String difficulty;
  final String targetMuscles;

  const ExerciseInfoCard({
    super.key,
    required this.exerciseName,
    required this.currentSet,
    required this.totalSets,
    required this.currentRep,
    required this.totalReps,
    required this.remainingTime,
    required this.difficulty,
    required this.targetMuscles,
  });

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Color _getDifficultyColor() {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'intermediate':
        return const Color(0xFFF59E0B);
      case 'advanced':
        return AppTheme.lightTheme.colorScheme.error;
      default:
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise Name and Difficulty
          Row(
            children: [
              Expanded(
                child: Text(
                  exerciseName,
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 3.w),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                  vertical: 1.h,
                ),
                decoration: BoxDecoration(
                  color: _getDifficultyColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getDifficultyColor(),
                    width: 1,
                  ),
                ),
                child: Text(
                  difficulty.toUpperCase(),
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: _getDifficultyColor(),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Target Muscles
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 3.w,
              vertical: 1.h,
            ),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'fitness_center',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  targetMuscles,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Progress Information
          Row(
            children: [
              // Sets Progress
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primaryContainer
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'SET',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$currentSet',
                              style: AppTheme
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: ' / $totalSets',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(width: 3.w),

              // Reps Progress
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'REPS',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$currentRep',
                              style: AppTheme
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.secondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: ' / $totalReps',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(width: 3.w),

              // Time Remaining
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE67E22).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'TIME',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        _formatTime(remainingTime),
                        style: AppTheme.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          color: const Color(0xFFE67E22),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
