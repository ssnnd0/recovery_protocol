import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class StreakCounterWidget extends StatefulWidget {
  final int currentStreak;
  final int longestStreak;
  final bool hasCheckedInToday;

  const StreakCounterWidget({
    super.key,
    required this.currentStreak,
    required this.longestStreak,
    required this.hasCheckedInToday,
  });

  @override
  State<StreakCounterWidget> createState() => _StreakCounterWidgetState();
}

class _StreakCounterWidgetState extends State<StreakCounterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.hasCheckedInToday && widget.currentStreak > 0) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getStreakMessage() {
    if (widget.currentStreak == 0) {
      return "Start your streak today!";
    } else if (widget.currentStreak == 1) {
      return "Great start! Keep it going!";
    } else if (widget.currentStreak < 7) {
      return "Building momentum!";
    } else if (widget.currentStreak < 30) {
      return "Fantastic consistency!";
    } else {
      return "Incredible dedication!";
    }
  }

  Color _getStreakColor() {
    if (widget.currentStreak == 0) {
      return AppTheme.lightTheme.colorScheme.outline;
    } else if (widget.currentStreak < 7) {
      return AppTheme.lightTheme.colorScheme.tertiary;
    } else if (widget.currentStreak < 30) {
      return AppTheme.lightTheme.colorScheme.secondary;
    } else {
      return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  IconData _getStreakIcon() {
    if (widget.currentStreak == 0) {
      return Icons.radio_button_unchecked;
    } else if (widget.currentStreak < 7) {
      return Icons.local_fire_department;
    } else if (widget.currentStreak < 30) {
      return Icons.whatshot;
    } else {
      return Icons.emoji_events;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getStreakColor().withValues(alpha: 0.1),
            _getStreakColor().withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getStreakColor().withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getStreakColor().withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: _getStreakIcon().toString().split('.').last,
                        color: _getStreakColor(),
                        size: 24,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${widget.currentStreak}',
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: _getStreakColor(),
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'day${widget.currentStreak != 1 ? 's' : ''}',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: _getStreakColor(),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  _getStreakMessage(),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (widget.longestStreak > widget.currentStreak) ...[
                  SizedBox(height: 4),
                  Text(
                    'Personal best: ${widget.longestStreak} days',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (widget.hasCheckedInToday)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    size: 12,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Done',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
