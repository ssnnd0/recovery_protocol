import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_tab_bar.dart';
import './widgets/body_map_heatmap_widget.dart';
import './widgets/insights_panel_widget.dart';
import './widgets/sleep_impact_chart_widget.dart';
import './widgets/streak_tracking_widget.dart';
import './widgets/training_load_chart_widget.dart';
import './widgets/wellness_trend_chart_widget.dart';

class ProgressAnalyticsDashboard extends StatefulWidget {
  const ProgressAnalyticsDashboard({super.key});

  @override
  State<ProgressAnalyticsDashboard> createState() =>
      _ProgressAnalyticsDashboardState();
}

class _ProgressAnalyticsDashboardState extends State<ProgressAnalyticsDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String selectedPeriod = 'Week';
  bool isLoading = false;
  bool isExporting = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final List<String> timePeriods = ['Week', 'Month', 'Quarter'];
  final List<TabItem> tabs = [
    const TabItem(label: 'Overview', icon: Icons.dashboard),
    const TabItem(label: 'Trends', icon: Icons.trending_up),
    const TabItem(label: 'Body Map', icon: Icons.accessibility_new),
    const TabItem(label: 'Insights', icon: Icons.psychology),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _loadAnalyticsData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAnalyticsData() async {
    setState(() {
      isLoading = true;
    });

    // Simulate data loading
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadAnalyticsData();
  }

  Future<void> _exportData() async {
    setState(() {
      isExporting = true;
    });

    try {
      // Simulate export process
      await Future.delayed(const Duration(milliseconds: 2000));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                const Text('Analytics data exported successfully'),
              ],
            ),
            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                CustomIconWidget(
                  iconName: 'error',
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                const Text('Export failed. Please try again.'),
              ],
            ),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isExporting = false;
        });
      }
    }
  }

  void _onChartTouch(FlTouchEvent event, LineTouchResponse? response) {
    if (response != null && response.lineBarSpots != null) {
      // Handle chart interaction with haptic feedback
      // HapticFeedback.lightImpact(); // Uncomment for haptic feedback
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Progress Analytics',
        actions: [
          IconButton(
            onPressed: isExporting ? null : _exportData,
            icon: isExporting
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                  )
                : CustomIconWidget(
                    iconName: 'share',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
            tooltip: 'Export Data',
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/user-profile-settings');
            },
            icon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'Profile Settings',
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: Column(
          children: [
            _buildTimePeriodSelector(),
            CustomTabBar(
              tabs: tabs,
              controller: _tabController,
              isScrollable: true,
              dividerHeight: 1,
            ),
            Expanded(
              child: isLoading
                  ? _buildLoadingState()
                  : CustomTabBarView(
                      controller: _tabController,
                      children: [
                        _buildOverviewTab(),
                        _buildTrendsTab(),
                        _buildBodyMapTab(),
                        _buildInsightsTab(),
                      ],
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(
        currentIndex: 4, // Progress tab
      ),
    );
  }

  Widget _buildTimePeriodSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Time Period:',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: timePeriods.map((period) {
                  final isSelected = selectedPeriod == period;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPeriod = period;
                      });
                      _loadAnalyticsData();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.only(right: 2.w),
                      padding: EdgeInsets.symmetric(
                          horizontal: 4.w, vertical: 1.5.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        period,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 15.w,
            height: 15.w,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Loading Analytics Data...',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Analyzing your recovery patterns',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 1.h),
          WellnessTrendChartWidget(
            selectedPeriod: selectedPeriod,
            onChartTouch: _onChartTouch,
          ),
          TrainingLoadChartWidget(
            selectedPeriod: selectedPeriod,
          ),
          const StreakTrackingWidget(),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildTrendsTab() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 1.h),
          WellnessTrendChartWidget(
            selectedPeriod: selectedPeriod,
            onChartTouch: _onChartTouch,
          ),
          SleepImpactChartWidget(
            selectedPeriod: selectedPeriod,
          ),
          TrainingLoadChartWidget(
            selectedPeriod: selectedPeriod,
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildBodyMapTab() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 1.h),
          BodyMapHeatmapWidget(
            selectedPeriod: selectedPeriod,
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildInsightsTab() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 1.h),
          InsightsPanelWidget(
            selectedPeriod: selectedPeriod,
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
