import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TrainingLoadChartWidget extends StatefulWidget {
  final String selectedPeriod;

  const TrainingLoadChartWidget({
    super.key,
    required this.selectedPeriod,
  });

  @override
  State<TrainingLoadChartWidget> createState() =>
      _TrainingLoadChartWidgetState();
}

class _TrainingLoadChartWidgetState extends State<TrainingLoadChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<Map<String, dynamic>> trainingData = [
    {"date": "Sep 1", "intensity": 7.2, "recovery": 8.1},
    {"date": "Sep 2", "intensity": 8.5, "recovery": 7.3},
    {"date": "Sep 3", "intensity": 6.8, "recovery": 8.7},
    {"date": "Sep 4", "intensity": 9.2, "recovery": 6.2},
    {"date": "Sep 5", "intensity": 8.8, "recovery": 6.8},
    {"date": "Sep 6", "intensity": 7.5, "recovery": 7.9},
    {"date": "Today", "intensity": 6.2, "recovery": 8.5},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1800),
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
                  'Training Load vs Recovery',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                CustomIconWidget(
                  iconName: 'fitness_center',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              'Correlation between workout intensity and recovery scores',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 3.h),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return SizedBox(
                  height: 28.h,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 10,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor:
                              AppTheme.lightTheme.colorScheme.surface,
                          tooltipRoundedRadius: 8,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            String label =
                                rodIndex == 0 ? 'Intensity' : 'Recovery';
                            return BarTooltipItem(
                              '$label: ${rod.toY.toStringAsFixed(1)}',
                              TextStyle(
                                color: rod.color,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
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
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              if (value.toInt() < trainingData.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    trainingData[value.toInt()]["date"],
                                    style:
                                        AppTheme.lightTheme.textTheme.bodySmall,
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 2,
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
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      barGroups: trainingData.asMap().entries.map((entry) {
                        return BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: (entry.value["intensity"] as double) *
                                  _animation.value,
                              color: AppTheme.lightTheme.colorScheme.primary,
                              width: 12,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.lightTheme.colorScheme.primary,
                                  AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.7),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            BarChartRodData(
                              toY: (entry.value["recovery"] as double) *
                                  _animation.value,
                              color: AppTheme.lightTheme.colorScheme.secondary,
                              width: 12,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.lightTheme.colorScheme.secondary,
                                  AppTheme.lightTheme.colorScheme.secondary
                                      .withValues(alpha: 0.7),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ],
                          barsSpace: 4,
                        );
                      }).toList(),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 2,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                            strokeWidth: 1,
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem('Training Intensity',
                    AppTheme.lightTheme.colorScheme.primary),
                _buildLegendItem('Recovery Score',
                    AppTheme.lightTheme.colorScheme.secondary),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'lightbulb',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Optimal recovery occurs when intensity and recovery scores are inversely correlated',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color:
                            AppTheme.lightTheme.colorScheme.onTertiaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}