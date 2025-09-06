import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';

class WellnessMetricsWidget extends StatefulWidget {
  final double fatigueLevel;
  final double stressLevel;
  final Function(double) onFatigueChanged;
  final Function(double) onStressChanged;

  const WellnessMetricsWidget({
    super.key,
    required this.fatigueLevel,
    required this.stressLevel,
    required this.onFatigueChanged,
    required this.onStressChanged,
  });

  @override
  State<WellnessMetricsWidget> createState() => _WellnessMetricsWidgetState();
}

class _WellnessMetricsWidgetState extends State<WellnessMetricsWidget> {
  String _getFatigueLabel(double value) {
    if (value <= 2) return 'Energized';
    if (value <= 4) return 'Fresh';
    if (value <= 6) return 'Moderate';
    if (value <= 8) return 'Tired';
    return 'Exhausted';
  }

  String _getStressLabel(double value) {
    if (value <= 2) return 'Calm';
    if (value <= 4) return 'Relaxed';
    if (value <= 6) return 'Moderate';
    if (value <= 8) return 'Stressed';
    return 'Overwhelmed';
  }

  Color _getFatigueColor(double value) {
    if (value <= 3) return AppTheme.lightTheme.colorScheme.secondary;
    if (value <= 6) return AppTheme.lightTheme.colorScheme.tertiary;
    return AppTheme.lightTheme.colorScheme.error;
  }

  Color _getStressColor(double value) {
    if (value <= 3) return AppTheme.lightTheme.colorScheme.secondary;
    if (value <= 6) return AppTheme.lightTheme.colorScheme.tertiary;
    return AppTheme.lightTheme.colorScheme.error;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'battery_charging_full',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Wellness Metrics',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          // Fatigue Level
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fatigue Level',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getFatigueColor(widget.fatigueLevel)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${widget.fatigueLevel.round()}/10 - ${_getFatigueLabel(widget.fatigueLevel)}',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: _getFatigueColor(widget.fatigueLevel),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: _getFatigueColor(widget.fatigueLevel),
                  inactiveTrackColor: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  thumbColor: _getFatigueColor(widget.fatigueLevel),
                  overlayColor: _getFatigueColor(widget.fatigueLevel)
                      .withValues(alpha: 0.2),
                  trackHeight: 6,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
                ),
                child: Slider(
                  value: widget.fatigueLevel,
                  min: 1,
                  max: 10,
                  divisions: 9,
                  onChanged: (value) {
                    HapticFeedback.selectionClick();
                    widget.onFatigueChanged(value);
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Energized',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                    ),
                  ),
                  Text(
                    'Exhausted',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 32),

          // Stress Level
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Stress Level',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStressColor(widget.stressLevel)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${widget.stressLevel.round()}/10 - ${_getStressLabel(widget.stressLevel)}',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: _getStressColor(widget.stressLevel),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: _getStressColor(widget.stressLevel),
                  inactiveTrackColor: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  thumbColor: _getStressColor(widget.stressLevel),
                  overlayColor: _getStressColor(widget.stressLevel)
                      .withValues(alpha: 0.2),
                  trackHeight: 6,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
                ),
                child: Slider(
                  value: widget.stressLevel,
                  min: 1,
                  max: 10,
                  divisions: 9,
                  onChanged: (value) {
                    HapticFeedback.selectionClick();
                    widget.onStressChanged(value);
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Calm',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                    ),
                  ),
                  Text(
                    'Overwhelmed',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
