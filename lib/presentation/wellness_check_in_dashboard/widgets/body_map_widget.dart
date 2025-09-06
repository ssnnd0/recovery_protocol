import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class BodyMapWidget extends StatefulWidget {
  final Function(String bodyPart, int intensity) onBodyPartTap;
  final Map<String, int> selectedBodyParts;

  const BodyMapWidget({
    super.key,
    required this.onBodyPartTap,
    required this.selectedBodyParts,
  });

  @override
  State<BodyMapWidget> createState() => _BodyMapWidgetState();
}

class _BodyMapWidgetState extends State<BodyMapWidget> {
  String? hoveredBodyPart;

  final Map<String, Offset> bodyPartPositions = {
    'head': Offset(0.5, 0.12),
    'neck': Offset(0.5, 0.18),
    'left_shoulder': Offset(0.35, 0.25),
    'right_shoulder': Offset(0.65, 0.25),
    'left_arm': Offset(0.25, 0.35),
    'right_arm': Offset(0.75, 0.35),
    'chest': Offset(0.5, 0.32),
    'left_elbow': Offset(0.2, 0.45),
    'right_elbow': Offset(0.8, 0.45),
    'core': Offset(0.5, 0.45),
    'left_forearm': Offset(0.15, 0.55),
    'right_forearm': Offset(0.85, 0.55),
    'lower_back': Offset(0.5, 0.52),
    'left_hip': Offset(0.42, 0.58),
    'right_hip': Offset(0.58, 0.58),
    'left_thigh': Offset(0.42, 0.68),
    'right_thigh': Offset(0.58, 0.68),
    'left_knee': Offset(0.42, 0.78),
    'right_knee': Offset(0.58, 0.78),
    'left_calf': Offset(0.42, 0.88),
    'right_calf': Offset(0.58, 0.88),
    'left_ankle': Offset(0.42, 0.95),
    'right_ankle': Offset(0.58, 0.95),
  };

  Color _getIntensityColor(int intensity) {
    switch (intensity) {
      case 1:
        return AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.3);
      case 2:
        return AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.5);
      case 3:
        return AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.6);
      case 4:
        return AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.8);
      case 5:
        return AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.8);
      default:
        return Colors.transparent;
    }
  }

  String _formatBodyPartName(String bodyPart) {
    return bodyPart
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  void _showIntensityDialog(String bodyPart) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Pain Level - ${_formatBodyPartName(bodyPart)}',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select your pain intensity level:',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 16),
              ...List.generate(5, (index) {
                final intensity = index + 1;
                return ListTile(
                  leading: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _getIntensityColor(intensity),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                        width: 1,
                      ),
                    ),
                  ),
                  title: Text(
                    '$intensity - ${_getIntensityLabel(intensity)}',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    widget.onBodyPartTap(bodyPart, intensity);
                    Navigator.of(context).pop();
                  },
                );
              }),
              SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  widget.onBodyPartTap(bodyPart, 0);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Remove Pain Marker',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  String _getIntensityLabel(int intensity) {
    switch (intensity) {
      case 1:
        return 'Mild';
      case 2:
        return 'Moderate';
      case 3:
        return 'Noticeable';
      case 4:
        return 'Severe';
      case 5:
        return 'Extreme';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Stack(
        children: [
          // Body silhouette background
          Positioned.fill(
            child: CustomPaint(
              painter: BodySilhouettePainter(),
            ),
          ),
          // Interactive body parts
          ...bodyPartPositions.entries.map((entry) {
            final bodyPart = entry.key;
            final position = entry.value;
            final intensity = widget.selectedBodyParts[bodyPart] ?? 0;
            final isHovered = hoveredBodyPart == bodyPart;

            return Positioned(
              left: position.dx * 300 - 15,
              top: position.dy * 380 - 15,
              child: GestureDetector(
                onTap: () => _showIntensityDialog(bodyPart),
                child: MouseRegion(
                  onEnter: (_) => setState(() => hoveredBodyPart = bodyPart),
                  onExit: (_) => setState(() => hoveredBodyPart = null),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: isHovered ? 35 : 30,
                    height: isHovered ? 35 : 30,
                    decoration: BoxDecoration(
                      color: intensity > 0
                          ? _getIntensityColor(intensity)
                          : (isHovered
                              ? AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.3)
                              : Colors.transparent),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: intensity > 0
                            ? _getIntensityColor(intensity)
                                .withValues(alpha: 0.8)
                            : (isHovered
                                ? AppTheme.lightTheme.colorScheme.primary
                                : Colors.transparent),
                        width: 2,
                      ),
                    ),
                    child: intensity > 0
                        ? Center(
                            child: Text(
                              intensity.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            );
          }).toList(),
          // Legend
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface
                    .withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pain Scale',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  ...List.generate(5, (index) {
                    final intensity = index + 1;
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _getIntensityColor(intensity),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.lightTheme.colorScheme.outline,
                                width: 0.5,
                              ),
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            '$intensity',
                            style: AppTheme.lightTheme.textTheme.labelSmall,
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BodySilhouettePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final path = Path();

    // Simple body silhouette
    final centerX = size.width * 0.5;

    // Head
    canvas.drawCircle(
      Offset(centerX, size.height * 0.12),
      size.width * 0.06,
      paint,
    );

    // Torso
    path.moveTo(centerX - size.width * 0.08, size.height * 0.2);
    path.lineTo(centerX - size.width * 0.12, size.height * 0.35);
    path.lineTo(centerX - size.width * 0.1, size.height * 0.55);
    path.lineTo(centerX + size.width * 0.1, size.height * 0.55);
    path.lineTo(centerX + size.width * 0.12, size.height * 0.35);
    path.lineTo(centerX + size.width * 0.08, size.height * 0.2);
    path.close();

    // Legs
    path.moveTo(centerX - size.width * 0.08, size.height * 0.55);
    path.lineTo(centerX - size.width * 0.06, size.height * 0.95);
    path.lineTo(centerX - size.width * 0.02, size.height * 0.95);
    path.lineTo(centerX - size.width * 0.04, size.height * 0.55);

    path.moveTo(centerX + size.width * 0.08, size.height * 0.55);
    path.lineTo(centerX + size.width * 0.06, size.height * 0.95);
    path.lineTo(centerX + size.width * 0.02, size.height * 0.95);
    path.lineTo(centerX + size.width * 0.04, size.height * 0.55);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
