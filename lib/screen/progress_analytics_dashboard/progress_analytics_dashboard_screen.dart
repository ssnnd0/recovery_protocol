import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';

class ProgressAnalyticsDashboardScreen extends StatefulWidget {
  const ProgressAnalyticsDashboardScreen({super.key});

  @override
  State<ProgressAnalyticsDashboardScreen> createState() => _ProgressAnalyticsDashboardScreenState();
}

class _ProgressAnalyticsDashboardScreenState extends State<ProgressAnalyticsDashboardScreen> {
  // State variables for analytics data
  final List<FlSpot> _sorenessData = [
    const FlSpot(0, 3), // Monday
    const FlSpot(1, 2), // Tuesday
    const FlSpot(2, 4), // Wednesday
    const FlSpot(3, 2), // Thursday
    const FlSpot(4, 3), // Friday
    const FlSpot(5, 1), // Saturday
    const FlSpot(6, 2), // Sunday
  ];

  final List<BarChartGroupData> _fatigueData = [
    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 6, width: 15)]),  // Monday
    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 7, width: 15)]),  // Tuesday
    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 8, width: 15)]),  // Wednesday
    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 5, width: 15)]),  // Thursday
    BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 6, width: 15)]),  // Friday
    BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 4, width: 15)]),  // Saturday
    BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 5, width: 15)]),  // Sunday
  ];

  final List<PieChartSectionData> _consistencyData = [
    PieChartSectionData(
      value: 85,
      title: '85%\nCompleted',
      color: AppTheme.successLight,
      radius: 50,
      titleStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    PieChartSectionData(
      value: 15,
      title: '15%\nMissed',
      color: AppTheme.errorLight,
      radius: 50,
      titleStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  ];

  String _getWeekday(int value) {
    switch (value) {
      case 0:
        return 'Mon';
      case 1:
        return 'Tue';
      case 2:
        return 'Wed';
      case 3:
        return 'Thu';
      case 4:
        return 'Fri';
      case 5:
        return 'Sat';
      case 6:
        return 'Sun';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Analytics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Soreness Trends',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8.0),
            AspectRatio(
              aspectRatio: 1.7,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: _sorenessData,
                      isCurved: true,
                      barWidth: 4,
                      color: Theme.of(context).colorScheme.primary,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).colorScheme.primary.withAlpha(26),
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(_getWeekday(value.toInt()));
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  gridData: const FlGridData(show: true),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Text(
              'Fatigue Levels',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8.0),
            AspectRatio(
              aspectRatio: 1.7,
              child: BarChart(
                BarChartData(
                  barGroups: _fatigueData,
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 2,
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(_getWeekday(value.toInt()));
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  gridData: const FlGridData(show: true),
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 10,
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Text(
              'Routine Consistency',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8.0),
            AspectRatio(
              aspectRatio: 1.7,
              child: PieChart(
                PieChartData(
                  sections: _consistencyData,
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            // Additional analytics cards
            _buildAnalyticsCard(
              title: 'Weekly Progress',
              content: '85% of goals achieved',
              icon: Icons.trending_up,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16.0),
            _buildAnalyticsCard(
              title: 'Recovery Quality',
              content: 'Good - Keep it up!',
              icon: Icons.star,
              color: AppTheme.successLight,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
