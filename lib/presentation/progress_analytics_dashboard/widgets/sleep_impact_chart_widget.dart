import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SleepImpactChartWidget extends StatefulWidget {
  final String selectedPeriod;

  const SleepImpactChartWidget({
    super.key,
    required this.selectedPeriod,
  });

  @override
  State<SleepImpactChartWidget> createState() => _SleepImpactChartWidgetState();
}

class _SleepImpactChartWidgetState extends State<SleepImpactChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<Map<String, dynamic>> sleepPerformanceData = [
    {"sleepHours": 6.2, "performance": 6.8, "date": "Sep 1"},
    {"sleepHours": 7.8, "performance": 8.5, "date": "Sep 2"},
    {"sleepHours": 8.2, "performance": 9.1, "date": "Sep 3"},
    {"sleepHours": 5.9, "performance": 6.2, "date": "Sep 4"},
    {"sleepHours": 7.5, "performance": 8.2, "date": "Sep 5"},
    {"sleepHours": 8.0, "performance": 8.8, "date": "Sep 6"},
    {"sleepHours": 7.2, "performance": 7.9, "date": "Today"},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getPerformanceColor(double performance) {
    if (performance >= 8.5) {
      return AppTheme.lightTheme.colorScheme.secondary;
    } else if (performance >= 7.0) {
      return AppTheme.lightTheme.colorScheme.primary;
    } else if (performance >= 6.0) {
      return AppTheme.lightTheme.colorScheme.tertiary;
    } else {
      return AppTheme.lightTheme.colorScheme.error;
    }
  }

  double _getCorrelationCoefficient() {
    // Calculate correlation coefficient between sleep and performance
    final n = sleepPerformanceData.length;
    final sleepMean = sleepPerformanceData
            .map((e) => e['sleepHours'] as double)
            .reduce((a, b) => a + b) /
        n;
    final perfMean = sleepPerformanceData
            .map((e) => e['performance'] as double)
            .reduce((a, b) => a + b) /
        n;

    double numerator = 0;
    double denomSleep = 0;
    double denomPerf = 0;

    for (final data in sleepPerformanceData) {
      final sleepDiff = (data['sleepHours'] as double) - sleepMean;
      final perfDiff = (data['performance'] as double) - perfMean;
      numerator += sleepDiff * perfDiff;
      denomSleep += sleepDiff * sleepDiff;
      denomPerf += perfDiff * perfDiff;
    }

    return numerator / (denomSleep * denomPerf).abs();
  }

  @override
  Widget build(BuildContext context) {
    final correlation = _getCorrelationCoefficient();

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
                  'Sleep Impact Analysis',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                CustomIconWidget(
                  iconName: 'bedtime',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              'Sleep quality correlation with next-day performance',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 3.h),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return SizedBox(
                  height: 30.h,
                  child: ScatterChart(
                    ScatterChartData(
                      scatterSpots:
                          sleepPerformanceData.asMap().entries.map((entry) {
                        final data = entry.value;
                        return ScatterSpot(
                          (data['sleepHours'] as double) * _animation.value,
                          (data['performance'] as double) * _animation.value,
                          color: _getPerformanceColor(data['performance']),
                          radius: 8,
                        );
                      }).toList(),
                      minX: 5,
                      maxX: 9,
                      minY: 5,
                      maxY: 10,
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        horizontalInterval: 1,
                        verticalInterval: 0.5,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                            strokeWidth: 1,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          axisNameWidget: Text(
                            'Sleep Hours',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 0.5,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return Text(
                                value.toStringAsFixed(1),
                                style: AppTheme.lightTheme.textTheme.bodySmall,
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          axisNameWidget: RotatedBox(
                            quarterTurns: 3,
                            child: Text(
                              'Performance Score',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return Text(
                                value.toInt().toString(),
                                style: AppTheme.lightTheme.textTheme.bodySmall,
                              );
                            },
                            reservedSize: 32,
                          ),
                        ),
                      ),
                      scatterTouchData: ScatterTouchData(
                        enabled: true,
                        touchTooltipData: ScatterTouchTooltipData(
                          tooltipBgColor: AppTheme.lightTheme.colorScheme.surface,
                          tooltipRoundedRadius: 8,
                          getTooltipItems: (ScatterSpot touchedBarSpot) {
                            final index = sleepPerformanceData.indexWhere(
                                (data) =>
                                    (data['sleepHours'] as double) ==
                                        touchedBarSpot.x &&
                                    (data['performance'] as double) ==
                                        touchedBarSpot.y);

                            if (index != -1) {
                              final data = sleepPerformanceData[index];
                              return ScatterTooltipItem(
                                '${data['date']}\nSleep: ${data['sleepHours']}h\nPerformance: ${data['performance']}/10',
                                textStyle: TextStyle(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              );
                            }
                            return ScatterTooltipItem('');
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: correlation > 0.7
                    ? AppTheme.lightTheme.colorScheme.secondaryContainer
                    : AppTheme.lightTheme.colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'analytics',
                        color: correlation > 0.7
                            ? AppTheme.lightTheme.colorScheme.secondary
                            : AppTheme.lightTheme.colorScheme.tertiary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Correlation Analysis',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: correlation > 0.7
                              ? AppTheme
                                  .lightTheme.colorScheme.onSecondaryContainer
                              : AppTheme
                                  .lightTheme.colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Correlation coefficient: ${correlation.toStringAsFixed(2)}',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: correlation > 0.7
                          ? AppTheme.lightTheme.colorScheme.onSecondaryContainer
                          : AppTheme.lightTheme.colorScheme.onTertiaryContainer,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    correlation > 0.7
                        ? 'Strong positive correlation - prioritize 7.5+ hours of sleep for optimal performance'
                        : 'Moderate correlation - consider sleep quality factors beyond duration',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: correlation > 0.7
                          ? AppTheme.lightTheme.colorScheme.onSecondaryContainer
                          : AppTheme.lightTheme.colorScheme.onTertiaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPerformanceLegendItem(
                    'Excellent', AppTheme.lightTheme.colorScheme.secondary),
                _buildPerformanceLegendItem(
                    'Good', AppTheme.lightTheme.colorScheme.primary),
                _buildPerformanceLegendItem(
                    'Fair', AppTheme.lightTheme.colorScheme.tertiary),
                _buildPerformanceLegendItem(
                    'Poor', AppTheme.lightTheme.colorScheme.error),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }
}