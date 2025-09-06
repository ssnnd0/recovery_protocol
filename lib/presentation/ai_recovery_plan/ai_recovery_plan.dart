import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/ai_insights_card.dart';
import './widgets/customization_modal.dart';
import './widgets/exercise_card.dart';
import './widgets/plan_header.dart';
import './widgets/substitution_bottom_sheet.dart';

class AiRecoveryPlan extends StatefulWidget {
  const AiRecoveryPlan({super.key});

  @override
  State<AiRecoveryPlan> createState() => _AiRecoveryPlanState();
}

class _AiRecoveryPlanState extends State<AiRecoveryPlan> {
  int _currentBottomNavIndex = 1;
  bool _isLoading = false;
  
  // Mock data for the recovery plan
  final Map<String, dynamic> _recoveryPlan = {
    "id": "plan_001",
    "title": "Post-Training Recovery Protocol",
    "duration": "25 mins",
    "difficulty": "Medium",
    "personalizationRationale": "Based on your recent high-intensity swim training and reported shoulder tension, this plan focuses on upper body recovery with gentle mobility work. Your sleep quality (7.2/10) and energy levels suggest moderate intensity exercises.",
    "learnMoreContent": "This AI-generated plan analyzes your training load from the past 7 days, wellness check-in data, and recovery patterns. The exercises target your primary stress areas while promoting blood flow and reducing muscle tension. Research shows that structured recovery protocols can improve performance by 15-20% and reduce injury risk by up to 40%.",
    "completionStatus": 0.0,
  };

  final List<Map<String, dynamic>> _exercises = [
{ "id": "ex_001",
"name": "Shoulder Blade Squeezes",
"duration": "3 mins",
"thumbnail": "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=400&fit=crop",
"targetAreas": ["Shoulders", "Upper Back"],
"difficulty": "Easy",
"equipment": ["None"],
"description": "Gentle activation for shoulder stabilizers",
},
{ "id": "ex_002",
"name": "Cat-Cow Stretches",
"duration": "4 mins",
"thumbnail": "https://images.unsplash.com/photo-1506629905607-d9c297d3d2f5?w=400&h=400&fit=crop",
"targetAreas": ["Spine", "Core"],
"difficulty": "Easy",
"equipment": ["None"],
"description": "Spinal mobility and core activation",
},
{ "id": "ex_003",
"name": "Foam Roll - IT Band",
"duration": "5 mins",
"thumbnail": "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=400&fit=crop",
"targetAreas": ["IT Band", "Legs"],
"difficulty": "Medium",
"equipment": ["Foam Roller"],
"description": "Myofascial release for leg recovery",
},
{ "id": "ex_004",
"name": "Hip Flexor Stretches",
"duration": "6 mins",
"thumbnail": "https://images.unsplash.com/photo-1506629905607-d9c297d3d2f5?w=400&h=400&fit=crop",
"targetAreas": ["Hip Flexors", "Legs"],
"difficulty": "Easy",
"equipment": ["None"],
"description": "Deep hip mobility work",
},
{ "id": "ex_005",
"name": "Thoracic Spine Rotation",
"duration": "4 mins",
"thumbnail": "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=400&fit=crop",
"targetAreas": ["Thoracic Spine", "Core"],
"difficulty": "Medium",
"equipment": ["None"],
"description": "Rotational mobility for swimmers",
},
{ "id": "ex_006",
"name": "Breathing Meditation",
"duration": "3 mins",
"thumbnail": "https://images.unsplash.com/photo-1506629905607-d9c297d3d2f5?w=400&h=400&fit=crop",
"targetAreas": ["Mind", "Recovery"],
"difficulty": "Easy",
"equipment": ["None"],
"description": "Parasympathetic nervous system activation",
},
];

  final List<Map<String, dynamic>> _alternativeExercises = [
{ "id": "alt_001",
"name": "Wall Angels",
"duration": "3 mins",
"thumbnail": "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=400&fit=crop",
"targetAreas": ["Shoulders", "Upper Back"],
"difficulty": "Easy",
"equipment": ["None"],
},
{ "id": "alt_002",
"name": "Doorway Chest Stretch",
"duration": "4 mins",
"thumbnail": "https://images.unsplash.com/photo-1506629905607-d9c297d3d2f5?w=400&h=400&fit=crop",
"targetAreas": ["Chest", "Shoulders"],
"difficulty": "Easy",
"equipment": ["None"],
},
{ "id": "alt_003",
"name": "Resistance Band Pull-Aparts",
"duration": "5 mins",
"thumbnail": "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=400&fit=crop",
"targetAreas": ["Upper Back", "Shoulders"],
"difficulty": "Medium",
"equipment": ["Resistance Band"],
},
];

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