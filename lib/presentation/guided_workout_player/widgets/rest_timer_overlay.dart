
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RestTimerOverlay extends StatefulWidget {
  final Duration restDuration;
  final VoidCallback? onRestComplete;
  final VoidCallback? onSkipRest;
  final bool showBreathingGuide;

  const RestTimerOverlay({
    super.key,
    required this.restDuration,
    this.onRestComplete,
    this.onSkipRest,
    this.showBreathingGuide = true,
  });

  @override
  State<RestTimerOverlay> createState() => _RestTimerOverlayState();
}

class _RestTimerOverlayState extends State<RestTimerOverlay>
    with TickerProviderStateMixin {
  late AnimationController _timerController;
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;
  Duration _remainingTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.restDuration;

    _timerController = AnimationController(
      duration: widget.restDuration,
      vsync: this,
    );

    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _breathingAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));

    _startTimer();
    if (widget.showBreathingGuide) {
      _startBreathingAnimation();
    }
  }

  void _startTimer() {
    _timerController.addListener(() {
      setState(() {
        _remainingTime = widget.restDuration * (1 - _timerController.value);
      });
    });

    _timerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onRestComplete?.call();
      }
    });

    _timerController.forward();
  }

  void _startBreathingAnimation() {
    _breathingController.repeat(reverse: true);
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timerController.dispose();
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.lightTheme.primaryColor.withValues(alpha: 0.9),
            AppTheme.lightTheme.primaryColor.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Rest Title
            Text(
              'Rest Time',
              style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: 2.h),

            Text(
              'Take a deep breath and prepare for the next exercise',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 6.h),

            // Breathing Animation Circle
            if (widget.showBreathingGuide)
              AnimatedBuilder(
                animation: _breathingAnimation,
                builder: (context, child) {
                  return Container(
                    width: 60.w * _breathingAnimation.value,
                    height: 60.w * _breathingAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.2),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.4),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        child: Center(
                          child: Text(
                            _formatTime(_remainingTime),
                            style: AppTheme.lightTheme.textTheme.displaySmall
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

            // Timer without breathing guide
            if (!widget.showBreathingGuide)
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.2),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Text(
                    _formatTime(_remainingTime),
                    style: AppTheme.lightTheme.textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

            SizedBox(height: 6.h),

            // Progress Ring
            SizedBox(
              width: 80.w,
              height: 80.w,
              child: Stack(
                children: [
                  // Background Ring
                  Container(
                    width: 80.w,
                    height: 80.w,
                    child: CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 8,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  // Progress Ring
                  AnimatedBuilder(
                    animation: _timerController,
                    builder: (context, child) {
                      return Container(
                        width: 80.w,
                        height: 80.w,
                        child: CircularProgressIndicator(
                          value: _timerController.value,
                          strokeWidth: 8,
                          backgroundColor: Colors.transparent,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 6.h),

            // Breathing Instructions
            if (widget.showBreathingGuide)
              AnimatedBuilder(
                animation: _breathingController,
                builder: (context, child) {
                  final isInhaling = _breathingController.value < 0.5;
                  return Text(
                    isInhaling ? 'Breathe In' : 'Breathe Out',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),

            SizedBox(height: 4.h),

            // Skip Rest Button
            GestureDetector(
              onTap: widget.onSkipRest,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'skip_next',
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Skip Rest',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
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
    );
  }
}
