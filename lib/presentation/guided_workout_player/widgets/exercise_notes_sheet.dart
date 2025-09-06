import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExerciseNotesSheet extends StatelessWidget {
  final String exerciseName;
  final String instructions;
  final List<String> tips;
  final List<String> modifications;
  final String targetMuscles;
  final String equipment;

  const ExerciseNotesSheet({
    super.key,
    required this.exerciseName,
    required this.instructions,
    required this.tips,
    required this.modifications,
    required this.targetMuscles,
    required this.equipment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: 80.h,
      ),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle Bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    exerciseName,
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exercise Details
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          'Target Muscles',
                          targetMuscles,
                          CustomIconWidget(
                            iconName: 'fitness_center',
                            color: AppTheme.lightTheme.primaryColor,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: _buildInfoCard(
                          'Equipment',
                          equipment,
                          CustomIconWidget(
                            iconName: 'sports_gymnastics',
                            color: AppTheme.lightTheme.colorScheme.secondary,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Instructions
                  _buildSection(
                    'Instructions',
                    CustomIconWidget(
                      iconName: 'list_alt',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 20,
                    ),
                    [
                      Text(
                        instructions,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Tips
                  if (tips.isNotEmpty)
                    _buildSection(
                      'Pro Tips',
                      CustomIconWidget(
                        iconName: 'lightbulb',
                        color: const Color(0xFFF59E0B),
                        size: 20,
                      ),
                      tips.map((tip) => _buildBulletPoint(tip)).toList(),
                    ),

                  if (tips.isNotEmpty) SizedBox(height: 3.h),

                  // Modifications
                  if (modifications.isNotEmpty)
                    _buildSection(
                      'Modifications',
                      CustomIconWidget(
                        iconName: 'tune',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 20,
                      ),
                      modifications
                          .map((mod) => _buildBulletPoint(mod))
                          .toList(),
                    ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, Widget icon) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              icon,
              SizedBox(width: 2.w),
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            icon,
            SizedBox(width: 2.w),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        ...children,
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 1.h, right: 3.w),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
