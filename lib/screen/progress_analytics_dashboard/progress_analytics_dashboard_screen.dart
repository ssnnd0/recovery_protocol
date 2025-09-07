import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Already in your pubspec.yaml

class ProgressAnalyticsDashboardScreen extends StatefulWidget {
  const ProgressAnalyticsDashboardScreen({super.key});

  @override
  State<ProgressAnalyticsDashboardScreen> createState() => _ProgressAnalyticsDashboardScreenState();
}

class _ProgressAnalyticsDashboardScreenState extends State<ProgressAnalyticsDashboardScreen> {
  // TODO: Add state variables for soreness, fatigue, and consistency data

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
            // TODO: Implement Soreness Chart
            AspectRatio(
              aspectRatio: 1.7,
              child: LineChart(
                // Replace with actual data later
                LineChartData(
                  // Dummy data for now
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 3),
                        const FlSpot(1, 1),
                        const FlSpot(2, 4),
                        const FlSpot(3, 2),
                        const FlSpot(4, 5),
                      ],
                      isCurved: true,
                      barWidth: 4,
                      // colors: [Theme.of(context).primaryColor], // Use Theme colors
                    ),
                  ],
                  titlesData: const FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
            // TODO: Implement Fatigue Chart (e.g., BarChart or LineChart)
            AspectRatio(
              aspectRatio: 1.7,
              child: BarChart(
                BarChartData(
                  // Dummy data for now
                   barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8, width: 15)]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 10, width: 15)]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 14, width: 15)]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 15, width: 15)]),
                    BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 13, width: 15)]),
                  ],
                  titlesData: const FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  gridData: const FlGridData(show: true),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Text(
              'Routine Consistency',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8.0),
            // TODO: Implement Consistency Chart (e.g., PieChart or a custom widget)
            AspectRatio(
              aspectRatio: 1.7,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(value: 70, title: 'Completed', color: Colors.green, radius: 50),
                    PieChartSectionData(value: 30, title: 'Missed', color: Colors.red, radius: 50),
                  ],
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                )
              ),
            ),
            const SizedBox(height: 24.0),
            // TODO: Add more analytics or data points as needed
          ],
        ),
      ),
    );
  }
}
