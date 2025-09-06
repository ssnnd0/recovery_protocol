import 'package:flutter/material.dart';
import '../presentation/progress_analytics_dashboard/progress_analytics_dashboard.dart';
import '../presentation/wellness_check_in_dashboard/wellness_check_in_dashboard.dart';
import '../presentation/ai_recovery_plan/ai_recovery_plan.dart';
import '../presentation/exercise_library/exercise_library.dart';
import '../presentation/user_profile_settings/user_profile_settings.dart';
import '../presentation/guided_workout_player/guided_workout_player.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String progressAnalyticsDashboard =
      '/progress-analytics-dashboard';
  static const String wellnessCheckInDashboard = '/wellness-check-in-dashboard';
  static const String aiRecoveryPlan = '/ai-recovery-plan';
  static const String exerciseLibrary = '/exercise-library';
  static const String userProfileSettings = '/user-profile-settings';
  static const String guidedWorkoutPlayer = '/guided-workout-player';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const ProgressAnalyticsDashboard(),
    progressAnalyticsDashboard: (context) => const ProgressAnalyticsDashboard(),
    wellnessCheckInDashboard: (context) => const WellnessCheckInDashboard(),
    aiRecoveryPlan: (context) => const AiRecoveryPlan(),
    exerciseLibrary: (context) => const ExerciseLibrary(),
    userProfileSettings: (context) => const UserProfileSettings(),
    guidedWorkoutPlayer: (context) => const GuidedWorkoutPlayer(),
    // TODO: Add your other routes here
  };
}
