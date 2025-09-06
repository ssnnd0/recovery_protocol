import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class TrainingLoadWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recentWorkouts;
  final String aiRecommendation;
  final double trainingLoad;

  const TrainingLoadWidget({
    super.key,
    required this.recentWorkouts,
    required this.aiRecommendation,
    required this.trainingLoad,
  });

  Color _getTrainingLoadColor(double load) {
    if (load <= 3) return AppTheme.lightTheme.colorScheme.secondary;
    if (load <= 6) return AppTheme.lightTheme.colorScheme.tertiary;
    return AppTheme.lightTheme.colorScheme.error;
  }

  String _getTrainingLoadLabel(double load) {
    if (load <= 2) return 'Light';
    if (load <= 4) return 'Moderate';
    if (load <= 6) return 'High';
    if (load <= 8) return 'Very High';
    return 'Extreme';
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0) {
      return '${hours}h ${mins}m';
    }
    return '${mins}m';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'trending_up',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Training Load',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'sports',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 12,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Strava',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Training load indicator
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Load',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${trainingLoad.toStringAsFixed(1)}/10',
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: _getTrainingLoadColor(trainingLoad),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getTrainingLoadColor(trainingLoad)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getTrainingLoadLabel(trainingLoad),
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: _getTrainingLoadColor(trainingLoad),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Training load visual indicator
          Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
            ),
            child: FractionallySizedBox(
              widthFactor: trainingLoad / 10,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _getTrainingLoadColor(trainingLoad),
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          // Recent workouts
          if (recentWorkouts.isNotEmpty) ...[
            Text(
              'Recent Workouts (7 days)',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12),
            ...recentWorkouts
                .take(3)
                .map((workout) => Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _getTrainingLoadColor(
                                  workout['intensity'] as double),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              workout['type'] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                          ),
                          Text(
                            _formatDuration(workout['duration'] as int),
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],

          SizedBox(height: 20),

          // AI Recommendation
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'psychology',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'AI Recommendation',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  aiRecommendation,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
