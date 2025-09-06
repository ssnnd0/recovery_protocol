import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BodyMapHeatmapWidget extends StatefulWidget {
  final String selectedPeriod;

  const BodyMapHeatmapWidget({
    super.key,
    required this.selectedPeriod,
  });

  @override
  State<BodyMapHeatmapWidget> createState() => _BodyMapHeatmapWidgetState();
}

class _BodyMapHeatmapWidgetState extends State<BodyMapHeatmapWidget> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  String selectedBodyPart = '';

  final Map<String, Map<String, dynamic>> bodyPartData = {
    'shoulders': {'intensity': 0.8, 'frequency': 12, 'trend': 'improving'},
    'back': {'intensity': 0.6, 'frequency': 8, 'trend': 'stable'},
    'legs': {'intensity': 0.9, 'frequency': 15, 'trend': 'worsening'},
    'knees': {'intensity': 0.4, 'frequency': 5, 'trend': 'improving'},
    'ankles': {'intensity': 0.3, 'frequency': 3, 'trend': 'stable'},
    'arms': {'intensity': 0.5, 'frequency': 7, 'trend': 'improving'},
    'core': {'intensity': 0.7, 'frequency': 10, 'trend': 'stable'},
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getIntensityColor(double intensity) {
    if (intensity >= 0.8) {
      return AppTheme.lightTheme.colorScheme.error;
    } else if (intensity >= 0.6) {
      return AppTheme.lightTheme.colorScheme.tertiary;
    } else if (intensity >= 0.4) {
      return const Color(0xFFF59E0B);
    } else {
      return AppTheme.lightTheme.colorScheme.secondary;
    }
  }

  IconData _getTrendIcon(String trend) {
    switch (trend) {
      case 'improving':
        return Icons.trending_down;
      case 'worsening':
        return Icons.trending_up;
      default:
        return Icons.trending_flat;
    }
  }

  Color _getTrendColor(String trend) {
    switch (trend) {
      case 'improving':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'worsening':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
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
                  'Body Map Heat Map',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                CustomIconWidget(
                  iconName: 'accessibility_new',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              'Pain pattern evolution over ${widget.selectedPeriod.toLowerCase()}',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 3.h),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Center(
                  child: Container(
                    width: 70.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Body outline
                        Center(
                          child: CustomImageWidget(
                            imageUrl: "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
                            width: 60.w,
                            height: 45.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                        // Interactive body parts
                        ..._buildBodyPartIndicators(),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 3.h),
            if (selectedBodyPart.isNotEmpty) _buildBodyPartDetails(),
            SizedBox(height: 2.h),
            _buildIntensityLegend(),
            SizedBox(height: 2.h),
            _buildBodyPartsList(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBodyPartIndicators() {
    return bodyPartData.entries.map<Widget>((entry) {
      final bodyPart = entry.key;
      final data = entry.value;
      final intensity = (data['intensity'] as double) * _animation.value;
      
      final position = _getBodyPartPosition(bodyPart);
      return Positioned(
        top: position['top']!,
        left: position['left']!,
        child: GestureDetector(
          onTap: () {
            setState(() {
              selectedBodyPart = selectedBodyPart == bodyPart ? '' : bodyPart;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: selectedBodyPart == bodyPart ? 20 : 16,
            height: selectedBodyPart == bodyPart ? 20 : 16,
            decoration: BoxDecoration(
              color: _getIntensityColor(intensity),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.surface,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: _getIntensityColor(intensity).withValues(alpha: 0.4),
                  blurRadius: selectedBodyPart == bodyPart ? 8 : 4,
                  spreadRadius: selectedBodyPart == bodyPart ? 2 : 1,
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Map<String, double> _getBodyPartPosition(String bodyPart) {
    switch (bodyPart) {
      case 'shoulders':
        return {'top': 8.h, 'left': 25.w};
      case 'back':
        return {'top': 15.h, 'left': 30.w};
      case 'arms':
        return {'top': 12.h, 'left': 15.w};
      case 'core':
        return {'top': 20.h, 'left': 30.w};
      case 'legs':
        return {'top': 30.h, 'left': 28.w};
      case 'knees':
        return {'top': 35.h, 'left': 28.w};
      case 'ankles':
        return {'top': 42.h, 'left': 28.w};
      default:
        return {'top': 0.0, 'left': 0.0};
    }
  }

  Widget _buildBodyPartDetails() {
    final data = bodyPartData[selectedBodyPart]!;
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedBodyPart.toUpperCase(),
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                ),
              ),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: _getTrendIcon(data['trend']).codePoint.toString(),
                    color: _getTrendColor(data['trend']),
                    size: 20,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    data['trend'],
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: _getTrendColor(data['trend']),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Intensity',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    '${((data['intensity'] as double) * 10).toStringAsFixed(1)}/10',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Frequency',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    '${data['frequency']} times',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
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

  Widget _buildIntensityLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Intensity Scale',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLegendItem('Low', AppTheme.lightTheme.colorScheme.secondary),
            _buildLegendItem('Moderate', const Color(0xFFF59E0B)),
            _buildLegendItem('High', AppTheme.lightTheme.colorScheme.tertiary),
            _buildLegendItem('Severe', AppTheme.lightTheme.colorScheme.error),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBodyPartsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Body Parts Summary',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        ...bodyPartData.entries.map((entry) {
          final bodyPart = entry.key;
          final data = entry.value;
          return Container(
            margin: EdgeInsets.only(bottom: 1.h),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _getIntensityColor(data['intensity']),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      bodyPart.toUpperCase(),
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: _getTrendIcon(data['trend']).codePoint.toString(),
                      color: _getTrendColor(data['trend']),
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '${data['frequency']}x',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}