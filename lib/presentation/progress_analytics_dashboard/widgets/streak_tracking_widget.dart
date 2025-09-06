import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StreakTrackingWidget extends StatefulWidget {
  const StreakTrackingWidget({super.key});

  @override
  State<StreakTrackingWidget> createState() => _StreakTrackingWidgetState();
}

class _StreakTrackingWidgetState extends State<StreakTrackingWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _badgeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _badgeAnimation;

  final Map<String, dynamic> streakData = {
    'currentStreak': 12,
    'longestStreak': 28,
    'weeklyGoal': 5,
    'weeklyCompleted': 4,
    'totalSessions': 156,
    'milestones': [
      {'days': 7, 'achieved': true, 'badge': 'Week Warrior'},
      {'days': 14, 'achieved': true, 'badge': 'Fortnight Fighter'},
      {'days': 30, 'achieved': false, 'badge': 'Monthly Master'},
      {'days': 60, 'achieved': false, 'badge': 'Consistency Champion'},
      {'days': 100, 'achieved': false, 'badge': 'Century Crusher'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _badgeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _badgeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _badgeController,
      curve: Curves.elasticOut,
    ));

    _pulseController.repeat(reverse: true);
    _badgeController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _badgeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Streak Tracking',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                CustomIconWidget(
                  iconName: 'local_fire_department',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 24,
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              'Consistency celebrations and milestone achievements',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 3.h),
            _buildCurrentStreakSection(),
            SizedBox(height: 3.h),
            _buildWeeklyProgressSection(),
            SizedBox(height: 3.h),
            _buildMilestonesSection(),
            SizedBox(height: 2.h),
            _buildStatsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStreakSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1),
            AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.lightTheme.colorScheme.tertiary,
                        AppTheme.lightTheme.colorScheme.tertiary
                            .withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.tertiary
                            .withValues(alpha: 0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'local_fire_department',
                          color: Colors.white,
                          size: 24,
                        ),
                        Text(
                          '${streakData['currentStreak']}',
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 2.h),
          Text(
            'Current Streak',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.tertiary,
            ),
          ),
          Text(
            'Days in a row',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Personal best: ${streakData['longestStreak']} days',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyProgressSection() {
    final completed = streakData['weeklyCompleted'] as int;
    final goal = streakData['weeklyGoal'] as int;
    final progress = completed / goal;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Goal',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                ),
              ),
              Text(
                '$completed/$goal',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.colorScheme.primary,
            ),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress * 100).toInt()}% complete',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                ),
              ),
              Text(
                '${goal - completed} sessions to go',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMilestonesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Milestone Badges',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: (streakData['milestones'] as List).map((milestone) {
            final achieved = milestone['achieved'] as bool;
            return AnimatedBuilder(
              animation: _badgeAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: achieved ? _badgeAnimation.value : 0.9,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
                    decoration: BoxDecoration(
                      color: achieved
                          ? AppTheme.lightTheme.colorScheme.secondaryContainer
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: achieved
                            ? AppTheme.lightTheme.colorScheme.secondary
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                        width: achieved ? 2 : 1,
                      ),
                      boxShadow: achieved
                          ? [
                              BoxShadow(
                                color: AppTheme.lightTheme.colorScheme.secondary
                                    .withValues(alpha: 0.2),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: achieved ? 'emoji_events' : 'lock',
                          color: achieved
                              ? AppTheme.lightTheme.colorScheme.secondary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${milestone['days']} Days',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: achieved
                                    ? AppTheme.lightTheme.colorScheme
                                        .onSecondaryContainer
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                              ),
                            ),
                            Text(
                              milestone['badge'],
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                fontSize: 9.sp,
                                color: achieved
                                    ? AppTheme.lightTheme.colorScheme
                                        .onSecondaryContainer
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            'Total Sessions',
            '${streakData['totalSessions']}',
            Icons.fitness_center,
          ),
          Container(
            width: 1,
            height: 6.h,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          _buildStatItem(
            'Best Streak',
            '${streakData['longestStreak']} days',
            Icons.trending_up,
          ),
          Container(
            width: 1,
            height: 6.h,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          _buildStatItem(
            'This Week',
            '${streakData['weeklyCompleted']}/${streakData['weeklyGoal']}',
            Icons.calendar_today,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: icon.codePoint.toString(),
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 20,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
