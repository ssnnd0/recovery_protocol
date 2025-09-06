import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/exercise_info_card.dart';
import './widgets/exercise_notes_sheet.dart';
import './widgets/rest_timer_overlay.dart';
import './widgets/workout_control_buttons.dart';
import './widgets/workout_progress_bar.dart';
import './widgets/workout_video_player.dart';

class GuidedWorkoutPlayer extends StatefulWidget {
  const GuidedWorkoutPlayer({super.key});

  @override
  State<GuidedWorkoutPlayer> createState() => _GuidedWorkoutPlayerState();
}

class _GuidedWorkoutPlayerState extends State<GuidedWorkoutPlayer>
    with TickerProviderStateMixin {
  int _currentExerciseIndex = 0;
  bool _isPlaying = false;
  bool _isResting = false;
  Duration _elapsedTime = Duration.zero;
  Duration _sessionStartTime = Duration.zero;

  // Mock workout data
  final List<Map<String, dynamic>> _workoutExercises = [
    {
      "id": 1,
      "name": "Push-ups",
      "videoUrl":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
      "sets": 3,
      "reps": 15,
      "duration": Duration(minutes: 2, seconds: 30),
      "restDuration": Duration(seconds: 60),
      "difficulty": "Intermediate",
      "targetMuscles": "Chest, Shoulders, Triceps",
      "equipment": "Bodyweight",
      "instructions":
          "Start in a plank position with hands slightly wider than shoulders. Lower your body until your chest nearly touches the floor, then push back up to starting position. Keep your core engaged throughout the movement.",
      "tips": [
        "Keep your body in a straight line from head to heels",
        "Don't let your hips sag or pike up",
        "Control the descent - don't just drop down",
        "Breathe out as you push up, breathe in as you lower"
      ],
      "modifications": [
        "Beginner: Perform on knees or against a wall",
        "Advanced: Add a clap at the top or elevate feet",
        "If wrists hurt, use push-up handles or make fists"
      ]
    },
    {
      "id": 2,
      "name": "Squats",
      "videoUrl":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
      "sets": 3,
      "reps": 20,
      "duration": Duration(minutes: 3),
      "restDuration": Duration(seconds: 45),
      "difficulty": "Beginner",
      "targetMuscles": "Quadriceps, Glutes, Hamstrings",
      "equipment": "Bodyweight",
      "instructions":
          "Stand with feet shoulder-width apart, toes slightly turned out. Lower your body by pushing your hips back and bending your knees. Go down until your thighs are parallel to the floor, then drive through your heels to return to standing.",
      "tips": [
        "Keep your chest up and core engaged",
        "Don't let your knees cave inward",
        "Weight should be on your heels, not toes",
        "Think about sitting back into a chair"
      ],
      "modifications": [
        "Beginner: Use a chair for support or don't go as deep",
        "Advanced: Add a jump at the top or hold weights",
        "If knee pain, reduce range of motion"
      ]
    },
    {
      "id": 3,
      "name": "Plank",
      "videoUrl":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
      "sets": 3,
      "reps": 1,
      "duration": Duration(minutes: 2),
      "restDuration": Duration(seconds: 30),
      "difficulty": "Intermediate",
      "targetMuscles": "Core, Shoulders, Back",
      "equipment": "Bodyweight",
      "instructions":
          "Start in a push-up position but rest on your forearms instead of hands. Keep your body in a straight line from head to heels. Hold this position while breathing normally.",
      "tips": [
        "Don't hold your breath - breathe normally",
        "Keep your hips level - don't let them sag or pike",
        "Engage your core by pulling belly button to spine",
        "Look down at the floor to keep neck neutral"
      ],
      "modifications": [
        "Beginner: Perform on knees or against a wall",
        "Advanced: Lift one leg or arm, or add movement",
        "If wrists hurt, stay on forearms"
      ]
    },
    {
      "id": 4,
      "name": "Burpees",
      "videoUrl":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
      "sets": 3,
      "reps": 10,
      "duration": Duration(minutes: 4),
      "restDuration": Duration(seconds: 90),
      "difficulty": "Advanced",
      "targetMuscles": "Full Body",
      "equipment": "Bodyweight",
      "instructions":
          "Start standing, then squat down and place hands on floor. Jump feet back into plank position, do a push-up, jump feet back to squat, then jump up with arms overhead. That's one rep.",
      "tips": [
        "Move at your own pace - form over speed",
        "Land softly when jumping back and forward",
        "Keep core engaged throughout the movement",
        "Breathe rhythmically - don't hold your breath"
      ],
      "modifications": [
        "Beginner: Step back instead of jumping, skip the push-up",
        "Intermediate: Skip the jump at the end",
        "Advanced: Add a tuck jump at the end"
      ]
    },
    {
      "id": 5,
      "name": "Mountain Climbers",
      "videoUrl":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
      "sets": 3,
      "reps": 30,
      "duration": Duration(minutes: 2, seconds: 45),
      "restDuration": Duration(seconds: 60),
      "difficulty": "Intermediate",
      "targetMuscles": "Core, Shoulders, Legs",
      "equipment": "Bodyweight",
      "instructions":
          "Start in a plank position. Bring one knee toward your chest, then quickly switch legs, bringing the other knee forward while extending the first leg back. Continue alternating legs rapidly.",
      "tips": [
        "Keep your core tight and hips level",
        "Don't let your butt pike up in the air",
        "Land lightly on the balls of your feet",
        "Maintain steady breathing rhythm"
      ],
      "modifications": [
        "Beginner: Slow down the pace or step instead of running",
        "Advanced: Increase speed or add cross-body movement",
        "If wrists hurt, use push-up handles"
      ]
    }
  ];

  int _currentSet = 1;
  int _currentRep = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _sessionStartTime =
        Duration(milliseconds: DateTime.now().millisecondsSinceEpoch);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Map<String, dynamic> get _currentExercise =>
      _workoutExercises[_currentExerciseIndex];

  double get _workoutProgress {
    return (_currentExerciseIndex + 1) / _workoutExercises.length;
  }

  Duration get _totalWorkoutTime {
    return _workoutExercises.fold(Duration.zero, (total, exercise) {
      return total +
          (exercise["duration"] as Duration) +
          (exercise["restDuration"] as Duration);
    });
  }

  Duration get _currentElapsedTime {
    final now = Duration(milliseconds: DateTime.now().millisecondsSinceEpoch);
    return now - _sessionStartTime;
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    HapticFeedback.lightImpact();
  }

  void _goToPreviousExercise() {
    if (_currentExerciseIndex > 0) {
      setState(() {
        _currentExerciseIndex--;
        _currentSet = 1;
        _currentRep = 0;
        _isPlaying = false;
      });
      HapticFeedback.lightImpact();
    }
  }

  void _goToNextExercise() {
    if (_currentExerciseIndex < _workoutExercises.length - 1) {
      setState(() {
        _isResting = true;
      });
    } else {
      _completeWorkout();
    }
  }

  void _onRestComplete() {
    setState(() {
      _isResting = false;
      _currentExerciseIndex++;
      _currentSet = 1;
      _currentRep = 0;
      _isPlaying = false;
    });
  }

  void _skipRest() {
    setState(() {
      _isResting = false;
      _currentExerciseIndex++;
      _currentSet = 1;
      _currentRep = 0;
      _isPlaying = false;
    });
    HapticFeedback.lightImpact();
  }

  void _completeWorkout() {
    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'celebration',
              color: AppTheme.lightTheme.colorScheme.secondary,
              size: 28,
            ),
            SizedBox(width: 3.w),
            Text(
              'Workout Complete!',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Congratulations! You\'ve completed your workout session.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Time:',
                          style: AppTheme.lightTheme.textTheme.bodySmall),
                      Text(
                        '${_currentElapsedTime.inMinutes}:${(_currentElapsedTime.inSeconds % 60).toString().padLeft(2, '0')}',
                        style: AppTheme.lightTheme.textTheme.bodySmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Exercises:',
                          style: AppTheme.lightTheme.textTheme.bodySmall),
                      Text(
                        '${_workoutExercises.length}',
                        style: AppTheme.lightTheme.textTheme.bodySmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, '/progress-analytics-dashboard', (route) => false);
            },
            child: Text('View Progress'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, '/ai-recovery-plan', (route) => false);
            },
            child: Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showExerciseNotes() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExerciseNotesSheet(
        exerciseName: _currentExercise["name"] as String,
        instructions: _currentExercise["instructions"] as String,
        tips: (_currentExercise["tips"] as List).cast<String>(),
        modifications:
            (_currentExercise["modifications"] as List).cast<String>(),
        targetMuscles: _currentExercise["targetMuscles"] as String,
        equipment: _currentExercise["equipment"] as String,
      ),
    );
  }

  void _exitWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Exit Workout?',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Your progress will be saved. You can resume this workout later.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Continue'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, '/ai-recovery-plan', (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Exit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Header with Exit Button
                Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _exitWorkout,
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: CustomIconWidget(
                            iconName: 'close',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 24,
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: _showExerciseNotes,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 2.w,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'info_outline',
                                color: AppTheme.lightTheme.primaryColor,
                                size: 20,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Notes',
                                style: AppTheme.lightTheme.textTheme.labelMedium
                                    ?.copyWith(
                                  color: AppTheme.lightTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Video Player
                        WorkoutVideoPlayer(
                          videoUrl: _currentExercise["videoUrl"] as String,
                          onVideoCompleted: () {
                            // Handle video completion
                          },
                        ),

                        SizedBox(height: 3.h),

                        // Exercise Info
                        ExerciseInfoCard(
                          exerciseName: _currentExercise["name"] as String,
                          currentSet: _currentSet,
                          totalSets: _currentExercise["sets"] as int,
                          currentRep: _currentRep,
                          totalReps: _currentExercise["reps"] as int,
                          remainingTime:
                              _currentExercise["duration"] as Duration,
                          difficulty: _currentExercise["difficulty"] as String,
                          targetMuscles:
                              _currentExercise["targetMuscles"] as String,
                        ),

                        SizedBox(height: 3.h),

                        // Progress Bar
                        WorkoutProgressBar(
                          progress: _workoutProgress,
                          currentExercise: _currentExerciseIndex + 1,
                          totalExercises: _workoutExercises.length,
                          elapsedTime: _currentElapsedTime,
                          totalTime: _totalWorkoutTime,
                        ),

                        SizedBox(height: 3.h),

                        // Control Buttons
                        WorkoutControlButtons(
                          onPreviousExercise: _goToPreviousExercise,
                          onPlayPause: _togglePlayPause,
                          onNextExercise: _goToNextExercise,
                          isPlaying: _isPlaying,
                          canGoPrevious: _currentExerciseIndex > 0,
                          canGoNext: _currentExerciseIndex <
                              _workoutExercises.length - 1,
                        ),

                        SizedBox(height: 4.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Rest Timer Overlay
          if (_isResting)
            RestTimerOverlay(
              restDuration: _currentExercise["restDuration"] as Duration,
              onRestComplete: _onRestComplete,
              onSkipRest: _skipRest,
              showBreathingGuide: true,
            ),
        ],
      ),
    );
  }
}
