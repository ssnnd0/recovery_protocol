import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WellnessTrendChartWidget extends StatefulWidget {
  final String selectedPeriod;
  final Function(FlTouchEvent, LineTouchResponse?)? onChartTouch;

  const WellnessTrendChartWidget({
    super.key,
    required this.selectedPeriod,
    this.onChartTouch,
  });

  @override
  State<WellnessTrendChartWidget> createState() =>
      _WellnessTrendChartWidgetState();
}

class _WellnessTrendChartWidgetState extends State<WellnessTrendChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int? touchedIndex;

  final List<Map<String, dynamic>> wellnessData = [
    {"date": "Sep 1", "soreness": 3.2, "fatigue": 2.8, "stress": 3.5},
    {"date": "Sep 2", "soreness": 2.8, "fatigue": 3.1, "stress": 3.2},
    {"date": "Sep 3", "soreness": 2.5, "fatigue": 2.9, "stress": 2.8},
    {"date": "Sep 4", "soreness": 3.8, "fatigue": 4.2, "stress": 4.1},
    {"date": "Sep 5", "soreness": 3.5, "fatigue": 3.8, "stress": 3.9},
    {"date": "Sep 6", "soreness": 2.9, "fatigue": 3.2, "stress": 3.1},
    {"date": "Today", "soreness": 2.2, "fatigue": 2.5, "stress": 2.4},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
                  'Wellness Trends',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                CustomIconWidget(
                  iconName: 'trending_up',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              'Track your recovery metrics over time',
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
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 1,
                        getDrawingHorizontalLine: (value) {
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
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: 1,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              if (value.toInt() < wellnessData.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    wellnessData[value.toInt()]["date"],
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
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      minX: 0,
                      maxX: (wellnessData.length - 1).toDouble(),
                      minY: 0,
                      maxY: 5,
                      lineBarsData: [
                        // Soreness line
                        LineChartBarData(
                          spots: wellnessData.asMap().entries.map((entry) {
                            return FlSpot(
                              entry.key.toDouble(),
                              (entry.value["soreness"] as double) *
                                  _animation.value,
                            );
                          }).toList(),
                          isCurved: true,
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.lightTheme.colorScheme.primary,
                              AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.7),
                            ],
                          ),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: AppTheme.lightTheme.colorScheme.primary,
                                strokeWidth: 2,
                                strokeColor:
                                    AppTheme.lightTheme.colorScheme.surface,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.3),
                                AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.1),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        // Fatigue line
                        LineChartBarData(
                          spots: wellnessData.asMap().entries.map((entry) {
                            return FlSpot(
                              entry.key.toDouble(),
                              (entry.value["fatigue"] as double) *
                                  _animation.value,
                            );
                          }).toList(),
                          isCurved: true,
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.lightTheme.colorScheme.secondary,
                              AppTheme.lightTheme.colorScheme.secondary
                                  .withValues(alpha: 0.7),
                            ],
                          ),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color:
                                    AppTheme.lightTheme.colorScheme.secondary,
                                strokeWidth: 2,
                                strokeColor:
                                    AppTheme.lightTheme.colorScheme.surface,
                              );
                            },
                          ),
                        ),
                        // Stress line
                        LineChartBarData(
                          spots: wellnessData.asMap().entries.map((entry) {
                            return FlSpot(
                              entry.key.toDouble(),
                              (entry.value["stress"] as double) *
                                  _animation.value,
                            );
                          }).toList(),
                          isCurved: true,
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.lightTheme.colorScheme.tertiary,
                              AppTheme.lightTheme.colorScheme.tertiary
                                  .withValues(alpha: 0.7),
                            ],
                          ),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: AppTheme.lightTheme.colorScheme.tertiary,
                                strokeWidth: 2,
                                strokeColor:
                                    AppTheme.lightTheme.colorScheme.surface,
                              );
                            },
                          ),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        enabled: true,
                        touchCallback: widget.onChartTouch,
                        touchTooltipData: LineTouchTooltipData(
                          tooltipBgColor: AppTheme.lightTheme.colorScheme.surface,
                          tooltipRoundedRadius: 8,
                          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                            return touchedBarSpots.map((barSpot) {
                              final flSpot = barSpot;
                              String label = '';
                              Color color =
                                  AppTheme.lightTheme.colorScheme.primary;

                              switch (barSpot.barIndex) {
                                case 0:
                                  label = 'Soreness';
                                  color =
                                      AppTheme.lightTheme.colorScheme.primary;
                                  break;
                                case 1:
                                  label = 'Fatigue';
                                  color =
                                      AppTheme.lightTheme.colorScheme.secondary;
                                  break;
                                case 2:
                                  label = 'Stress';
                                  color =
                                      AppTheme.lightTheme.colorScheme.tertiary;
                                  break;
                              }

                              return LineTooltipItem(
                                '$label: ${flSpot.y.toStringAsFixed(1)}',
                                TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              );
                            }).toList();
                          },
                        ),
                        handleBuiltInTouches: true,
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
                _buildLegendItem(
                    'Soreness', AppTheme.lightTheme.colorScheme.primary),
                _buildLegendItem(
                    'Fatigue', AppTheme.lightTheme.colorScheme.secondary),
                _buildLegendItem(
                    'Stress', AppTheme.lightTheme.colorScheme.tertiary),
              ],
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
            shape: BoxShape.circle,
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