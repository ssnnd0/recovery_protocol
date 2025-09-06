import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class SleepQualityWidget extends StatelessWidget {
  final double sleepDuration;
  final int sleepQuality;
  final bool isHealthKitConnected;
  final VoidCallback onManualOverride;

  const SleepQualityWidget({
    super.key,
    required this.sleepDuration,
    required this.sleepQuality,
    required this.isHealthKitConnected,
    required this.onManualOverride,
  });

  String _formatSleepDuration(double hours) {
    final totalMinutes = (hours * 60).round();
    final displayHours = totalMinutes ~/ 60;
    final displayMinutes = totalMinutes % 60;
    return '${displayHours}h ${displayMinutes}m';
  }

  String _getSleepQualityLabel(int quality) {
    switch (quality) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return 'Unknown';
    }
  }

  Color _getSleepQualityColor(int quality) {
    switch (quality) {
      case 1:
      case 2:
        return AppTheme.lightTheme.colorScheme.error;
      case 3:
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 4:
      case 5:
        return AppTheme.lightTheme.colorScheme.secondary;
      default:
        return AppTheme.lightTheme.colorScheme.outline;
    }
  }

  IconData _getSleepIcon(int quality) {
    switch (quality) {
      case 1:
      case 2:
        return Icons.bedtime_off;
      case 3:
        return Icons.bedtime;
      case 4:
      case 5:
        return Icons.nights_stay;
      default:
        return Icons.bedtime;
    }
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
                    iconName: 'nights_stay',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Sleep Quality',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (isHealthKitConnected)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'health_and_safety',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 12,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'HealthKit',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Duration',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _formatSleepDuration(sleepDuration),
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: sleepDuration >= 7
                            ? AppTheme.lightTheme.colorScheme.secondary
                            : AppTheme.lightTheme.colorScheme.tertiary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      sleepDuration >= 8
                          ? 'Optimal'
                          : sleepDuration >= 7
                              ? 'Good'
                              : 'Below recommended',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: sleepDuration >= 7
                            ? AppTheme.lightTheme.colorScheme.secondary
                            : AppTheme.lightTheme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quality Score',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: _getSleepIcon(sleepQuality)
                              .toString()
                              .split('.')
                              .last,
                          color: _getSleepQualityColor(sleepQuality),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '$sleepQuality/5',
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: _getSleepQualityColor(sleepQuality),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      _getSleepQualityLabel(sleepQuality),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: _getSleepQualityColor(sleepQuality),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // Sleep quality visual indicator
          Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
            ),
            child: FractionallySizedBox(
              widthFactor: sleepQuality / 5,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _getSleepQualityColor(sleepQuality),
                ),
              ),
            ),
          ),

          if (!isHealthKitConnected) ...[
            SizedBox(height: 16),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'info_outline',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 16,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Connect HealthKit for automatic sleep tracking',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],

          SizedBox(height: 16),

          TextButton(
            onPressed: onManualOverride,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'edit',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  'Manual Override',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
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
