import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../core/mock/recovery_plan_mock.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/ai_insights_card.dart';
import './widgets/customization_modal.dart';
import './widgets/exercise_card.dart';
import './widgets/plan_header.dart';
import './widgets/substitution_bottom_sheet.dart';

/// A screen that displays an AI-generated recovery plan with customizable exercises
/// and real-time adjustments based on user feedback and wellness data.
class AiRecoveryPlan extends StatefulWidget {
  const AiRecoveryPlan({super.key});

  @override
  State<AiRecoveryPlan> createState() => _AiRecoveryPlanState();
}

class _AiRecoveryPlanState extends State<AiRecoveryPlan> {
  int _currentBottomNavIndex = 1;
  bool _isLoading = false;
  
  // Initialize recovery plan from mock data
  final Map<String, dynamic> _recoveryPlan = RecoveryPlanMock.recoveryPlan;
  final List<Map<String, dynamic>> _exercises = RecoveryPlanMock.exercises;
  final List<Map<String, dynamic>> _alternativeExercises = RecoveryPlanMock.alternativeExercises;

  Map<String, bool> _exercisePreferences = {
    'Include Stretching': true,
    'Focus on Core': false,
    'Upper Body Priority': true,
    'Lower Body Priority': false,
    'Balance Training': false,
    'Foam Rolling': true,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          PlanHeader(
            title: _recoveryPlan["title"] as String,
            duration: _recoveryPlan["duration"] as String,
            difficulty: _recoveryPlan["difficulty"] as String,
            onCustomize: _showCustomizationModal,
          ),
          Expanded(
            child: _isLoading
                ? _buildLoadingState(theme)
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: 1.h),
                        AiInsightsCard(
                          personalizationRationale: _recoveryPlan["personalizationRationale"] as String,
                          learnMoreContent: _recoveryPlan["learnMoreContent"] as String,
                        ),
                        SizedBox(height: 2.h),
                        _buildProgressIndicator(theme),
                        SizedBox(height: 2.h),
                        _buildExerciseList(),
                        SizedBox(height: 10.h), // Space for FAB
                      ],
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: _buildStartWorkoutFAB(theme),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          Text(
            'Generating your personalized plan...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.light
                ? const Color(0x14000000)
                : const Color(0x14FFFFFF),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'track_changes',
                color: theme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Progress',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Text(
                '${((_recoveryPlan["completionStatus"] as double) * 100).toInt()}%',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          LinearProgressIndicator(
            value: _recoveryPlan["completionStatus"] as double,
            backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            minHeight: 1.h,
          ),
          SizedBox(height: 1.h),
          Text(
            _recoveryPlan["completionStatus"] == 0.0
                ? 'Ready to start your recovery session'
                : 'Keep going! You\'re making great progress',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _exercises.length,
      itemBuilder: (context, index) {
        final exercise = _exercises[index];
        return ExerciseCard(
          exercise: exercise,
          onTap: () => _navigateToExerciseDetail(exercise),
          onPreview: () => _showExercisePreview(exercise),
          onSubstitution: () => _showSubstitutionBottomSheet(exercise),
        );
      },
    );
  }

  Widget _buildStartWorkoutFAB(ThemeData theme) {
    return Container(
      width: 80.w,
      height: 7.h,
      child: FloatingActionButton.extended(
        onPressed: _startGuidedWorkout,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        icon: CustomIconWidget(
          iconName: 'play_arrow',
          color: theme.colorScheme.onPrimary,
          size: 24,
        ),
        label: Text(
          'Start Recovery Session',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _navigateToExerciseDetail(Map<String, dynamic> exercise) {
    // Navigate to exercise detail screen
    Navigator.pushNamed(context, '/exercise-library');
  }

  void _showExercisePreview(Map<String, dynamic> exercise) {
    HapticFeedback.lightImpact();
    
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return Dialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CustomImageWidget(
                    imageUrl: exercise["thumbnail"] as String,
                    width: double.infinity,
                    height: 30.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  exercise["name"] as String,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 1.h),
                Text(
                  exercise["description"] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _navigateToExerciseDetail(exercise);
                      },
                      child: Text('View Details'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSubstitutionBottomSheet(Map<String, dynamic> exercise) {
    HapticFeedback.lightImpact();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SubstitutionBottomSheet(
        originalExercise: exercise,
        alternatives: _alternativeExercises,
        onSubstitute: (newExercise) {
          setState(() {
            final index = _exercises.indexWhere((ex) => ex["id"] == exercise["id"]);
            if (index != -1) {
              _exercises[index] = newExercise;
            }
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Exercise substituted successfully'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCustomizationModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomizationModal(
        currentDifficulty: _recoveryPlan["difficulty"] as String,
        exercisePreferences: _exercisePreferences,
        onSave: (difficulty, preferences) {
          setState(() {
            _recoveryPlan["difficulty"] = difficulty;
            _exercisePreferences = preferences;
            _isLoading = true;
          });
          
          // Simulate AI plan regeneration
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _isLoading = false;
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Plan updated based on your preferences'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  void _startGuidedWorkout() {
    HapticFeedback.mediumImpact();
    
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'play_circle',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Start Session',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          content: Text(
            'Ready to begin your 25-minute recovery session? The guided workout will take you through each exercise with timers and form tips.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Not Now'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/guided-workout-player');
              },
              child: Text('Start Now'),
            ),
          ],
        );
      },
    );
  }
}