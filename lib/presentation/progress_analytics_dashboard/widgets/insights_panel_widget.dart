import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InsightsPanelWidget extends StatefulWidget {
  final String selectedPeriod;

  const InsightsPanelWidget({
    super.key,
    required this.selectedPeriod,
  });

  @override
  State<InsightsPanelWidget> createState() => _InsightsPanelWidgetState();
}

class _InsightsPanelWidgetState extends State<InsightsPanelWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  int selectedInsightIndex = 0;

  final List<Map<String, dynamic>> aiInsights = [
    {
      'type': 'pattern',
      'title': 'Recovery Pattern Detected',
      'description':
          'Your soreness levels consistently decrease after rest days. Consider scheduling recovery sessions every 3-4 training days.',
      'confidence': 0.89,
      'actionable': true,
      'recommendation': 'Add a recovery session on Thursday',
      'icon': 'psychology',
      'priority': 'high',
    },
    {
      'type': 'correlation',
      'title': 'Sleep-Performance Link',
      'description':
          'Strong correlation (0.82) between sleep duration and next-day performance. Prioritizing 7.5+ hours shows significant benefits.',
      'confidence': 0.92,
      'actionable': true,
      'recommendation': 'Set a consistent bedtime routine',
      'icon': 'bedtime',
      'priority': 'high',
    },
    {
      'type': 'trend',
      'title': 'Stress Level Trending Up',
      'description':
          'Stress levels have increased 15% over the past week. This may impact recovery effectiveness and injury risk.',
      'confidence': 0.76,
      'actionable': true,
      'recommendation': 'Incorporate mindfulness exercises',
      'icon': 'trending_up',
      'priority': 'medium',
    },
    {
      'type': 'achievement',
      'title': 'Consistency Milestone',
      'description':
          'You\'ve maintained a 12-day streak! This consistency is building strong recovery habits and improving baseline wellness.',
      'confidence': 1.0,
      'actionable': false,
      'recommendation': 'Keep up the excellent work',
      'icon': 'emoji_events',
      'priority': 'low',
    },
    {
      'type': 'warning',
      'title': 'Leg Soreness Spike',
      'description':
          'Leg soreness intensity has increased 40% this week. Consider reducing training load or adding targeted recovery protocols.',
      'confidence': 0.84,
      'actionable': true,
      'recommendation': 'Focus on lower body recovery exercises',
      'icon': 'warning',
      'priority': 'high',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return AppTheme.lightTheme.colorScheme.error;
      case 'medium':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'low':
        return AppTheme.lightTheme.colorScheme.secondary;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'pattern':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'correlation':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'trend':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'achievement':
        return const Color(0xFF10B981);
      case 'warning':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
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
                  'AI Insights & Recommendations',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'auto_awesome',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'AI',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme
                              .lightTheme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              'Personalized observations and actionable recommendations',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 3.h),
            _buildInsightTabs(),
            SizedBox(height: 2.h),
            AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - _slideAnimation.value)),
                  child: Opacity(
                    opacity: _slideAnimation.value,
                    child: _buildSelectedInsight(),
                  ),
                );
              },
            ),
            SizedBox(height: 3.h),
            _buildInsightsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightTabs() {
    final categories = ['All', 'High Priority', 'Actionable', 'Patterns'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.asMap().entries.map((entry) {
          final index = entry.key;
          final category = entry.value;
          final isSelected = selectedInsightIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedInsightIndex = index;
              });
              _animationController.reset();
              _animationController.forward();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.only(right: 2.w),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
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
                category,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
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
    );
  }

  Widget _buildSelectedInsight() {
    final insight = aiInsights.first;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getTypeColor(insight['type']).withValues(alpha: 0.1),
            _getTypeColor(insight['type']).withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getTypeColor(insight['type']).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: _getTypeColor(insight['type']),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: insight['icon'],
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          insight['title'],
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.w),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(insight['priority']),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            insight['priority'].toUpperCase(),
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'verified',
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          size: 14,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${(insight['confidence'] * 100).toInt()}% confidence',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            insight['description'],
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.4,
            ),
          ),
          if (insight['actionable'] as bool) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'lightbulb',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recommended Action',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme
                                .lightTheme.colorScheme.onSecondaryContainer,
                          ),
                        ),
                        Text(
                          insight['recommendation'],
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInsightsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'All Insights',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        ...aiInsights.skip(1).map((insight) {
          return Container(
            margin: EdgeInsets.only(bottom: 1.h),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(1.5.w),
                  decoration: BoxDecoration(
                    color:
                        _getTypeColor(insight['type']).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: CustomIconWidget(
                    iconName: insight['icon'],
                    color: _getTypeColor(insight['type']),
                    size: 16,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              insight['title'],
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 1.5.w, vertical: 0.5.w),
                            decoration: BoxDecoration(
                              color: _getPriorityColor(insight['priority'])
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              insight['priority'].toUpperCase(),
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w600,
                                color: _getPriorityColor(insight['priority']),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        insight['description'],
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
