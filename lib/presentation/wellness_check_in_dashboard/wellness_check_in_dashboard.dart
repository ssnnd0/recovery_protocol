import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_tab_bar.dart';
import './widgets/body_map_widget.dart';
import './widgets/sleep_quality_widget.dart';
import './widgets/streak_counter_widget.dart';
import './widgets/training_load_widget.dart';
import './widgets/wellness_metrics_widget.dart';

class WellnessCheckInDashboard extends StatefulWidget {
  const WellnessCheckInDashboard({super.key});

  @override
  State<WellnessCheckInDashboard> createState() =>
      _WellnessCheckInDashboardState();
}

class _WellnessCheckInDashboardState extends State<WellnessCheckInDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  int _currentBottomNavIndex = 0;
  Map<String, int> _selectedBodyParts = {};
  double _fatigueLevel = 5.0;
  double _stressLevel = 4.0;
  bool _isHealthKitConnected = true;
  bool _isCheckInComplete = false;

  // Mock data
  final List<Map<String, dynamic>> _recentWorkouts = [
    {
      'type': 'Swimming - Freestyle',
      'duration': 75,
      'intensity': 7.5,
      'date': DateTime.now().subtract(Duration(days: 1)),
    },
    {
      'type': 'Running - Easy Pace',
      'duration': 45,
      'intensity': 4.2,
      'date': DateTime.now().subtract(Duration(days: 2)),
    },
    {
      'type': 'Strength Training',
      'duration': 60,
      'intensity': 6.8,
      'date': DateTime.now().subtract(Duration(days: 3)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _checkCompletionStatus();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _checkCompletionStatus() {
    final hasBodyParts = _selectedBodyParts.isNotEmpty;
    final hasMetrics = _fatigueLevel > 0 && _stressLevel > 0;

    setState(() {
      _isCheckInComplete = hasBodyParts || hasMetrics;
    });

    if (_isCheckInComplete) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
    }
  }

  void _onBodyPartTap(String bodyPart, int intensity) {
    setState(() {
      if (intensity == 0) {
        _selectedBodyParts.remove(bodyPart);
      } else {
        _selectedBodyParts[bodyPart] = intensity;
      }
    });
    _checkCompletionStatus();
    HapticFeedback.lightImpact();
  }

  void _onFatigueChanged(double value) {
    setState(() {
      _fatigueLevel = value;
    });
    _checkCompletionStatus();
  }

  void _onStressChanged(double value) {
    setState(() {
      _stressLevel = value;
    });
    _checkCompletionStatus();
  }

  void _onManualSleepOverride() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double tempDuration = 7.5;
        int tempQuality = 3;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                'Manual Sleep Override',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Adjust your sleep data manually:',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Sleep Duration: ${tempDuration.toStringAsFixed(1)} hours',
                    style: AppTheme.lightTheme.textTheme.labelMedium,
                  ),
                  Slider(
                    value: tempDuration,
                    min: 4.0,
                    max: 12.0,
                    divisions: 32,
                    onChanged: (value) {
                      setDialogState(() {
                        tempDuration = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Sleep Quality: $tempQuality/5',
                    style: AppTheme.lightTheme.textTheme.labelMedium,
                  ),
                  Slider(
                    value: tempQuality.toDouble(),
                    min: 1,
                    max: 5,
                    divisions: 4,
                    onChanged: (value) {
                      setDialogState(() {
                        tempQuality = value.round();
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Here you would update the sleep data
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sleep data updated manually'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _generateRecoveryPlan() {
    HapticFeedback.mediumImpact();
    Navigator.pushNamed(context, '/ai-recovery-plan');
  }

  Future<void> _refreshData() async {
    HapticFeedback.lightImpact();
    // Simulate data refresh
    await Future.delayed(Duration(milliseconds: 1500));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Health data synced successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();
    final formattedDate =
        '${_getWeekday(currentDate.weekday)}, ${_getMonth(currentDate.month)} ${currentDate.day}';

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Recovery Protocol',
        showBackButton: false,
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/user-profile-settings'),
            icon: CustomIconWidget(
              iconName: 'account_circle',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          CustomTabBar(
            controller: _tabController,
            tabs: [
              TabItem(label: 'Check-in', icon: Icons.health_and_safety),
              TabItem(label: 'Plans', icon: Icons.psychology),
              TabItem(label: 'Progress', icon: Icons.analytics),
              TabItem(label: 'Profile', icon: Icons.person),
            ],
            onTap: (index) {
              if (index == 1) {
                Navigator.pushNamed(context, '/ai-recovery-plan');
              } else if (index == 2) {
                Navigator.pushNamed(context, '/progress-analytics-dashboard');
              } else if (index == 3) {
                Navigator.pushNamed(context, '/user-profile-settings');
              }
            },
          ),

          // Main Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              color: AppTheme.lightTheme.colorScheme.primary,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting Header
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            AppTheme.lightTheme.colorScheme.secondary
                                .withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_getGreeting()}, Athlete!',
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            formattedDate,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 16),
                          StreakCounterWidget(
                            currentStreak: 12,
                            longestStreak: 28,
                            hasCheckedInToday: _isCheckInComplete,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // Body Map Section
                    Text(
                      'Body Assessment',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12),
                    BodyMapWidget(
                      onBodyPartTap: _onBodyPartTap,
                      selectedBodyParts: _selectedBodyParts,
                    ),

                    SizedBox(height: 24),

                    // Wellness Metrics
                    WellnessMetricsWidget(
                      fatigueLevel: _fatigueLevel,
                      stressLevel: _stressLevel,
                      onFatigueChanged: _onFatigueChanged,
                      onStressChanged: _onStressChanged,
                    ),

                    SizedBox(height: 24),

                    // Sleep Quality
                    SleepQualityWidget(
                      sleepDuration: 7.5,
                      sleepQuality: 4,
                      isHealthKitConnected: _isHealthKitConnected,
                      onManualOverride: _onManualSleepOverride,
                    ),

                    SizedBox(height: 24),

                    // Training Load
                    TrainingLoadWidget(
                      recentWorkouts: _recentWorkouts,
                      trainingLoad: 6.2,
                      aiRecommendation:
                          'Based on your current training load and fatigue levels, consider incorporating more active recovery sessions. Focus on mobility work and light aerobic activities to optimize your recovery.',
                    ),

                    SizedBox(height: 32),

                    // Generate Recovery Plan Button
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale:
                              _isCheckInComplete ? _pulseAnimation.value : 1.0,
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isCheckInComplete
                                  ? _generateRecoveryPlan
                                  : null,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: _isCheckInComplete
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.colorScheme.outline,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomIconWidget(
                                    iconName: 'psychology',
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    _isCheckInComplete
                                        ? 'Generate Recovery Plan'
                                        : 'Complete Check-in First',
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
        },
      ),
    );
  }

  String _getWeekday(int weekday) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return weekdays[weekday - 1];
  }

  String _getMonth(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
