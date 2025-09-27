import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class CustomizationModal extends StatefulWidget {
  final String currentDifficulty;
  final Map<String, bool> exercisePreferences;
  final Function(String difficulty, Map<String, bool> preferences) onSave;

  const CustomizationModal({
    super.key,
    required this.currentDifficulty,
    required this.exercisePreferences,
    required this.onSave,
  });

  @override
  State<CustomizationModal> createState() => _CustomizationModalState();
}

class _CustomizationModalState extends State<CustomizationModal> {
  late String _selectedDifficulty;
  late Map<String, bool> _preferences;

  @override
  void initState() {
    super.initState();
    _selectedDifficulty = widget.currentDifficulty;
    _preferences = Map.from(widget.exercisePreferences);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Customize Plan',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  'Difficulty Level',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 1.h),
                _buildDifficultySelector(theme),
                SizedBox(height: 3.h),
                Text(
                  'Exercise Preferences',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 1.h),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              children: _preferences.keys.map((preference) {
                return _buildPreferenceItem(theme, preference);
              }).toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onSave(_selectedDifficulty, _preferences);
                      Navigator.pop(context);
                    },
                    child: Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultySelector(ThemeData theme) {
    final difficulties = ['Easy', 'Medium', 'Hard'];

    return Row(
      children: difficulties.map((difficulty) {
        final isSelected = _selectedDifficulty == difficulty;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedDifficulty = difficulty;
              });
            },
            child: Container(
              margin: EdgeInsets.only(
                  right: difficulty != difficulties.last ? 2.w : 0),
              padding: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: _getDifficultyIcon(difficulty),
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                    size: 24,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    difficulty,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPreferenceItem(ThemeData theme, String preference) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: SwitchListTile(
        title: Text(
          preference,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          _getPreferenceDescription(preference),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        value: _preferences[preference] ?? false,
        onChanged: (value) {
          setState(() {
            _preferences[preference] = value;
          });
        },
        activeThumbColor: theme.colorScheme.primary,
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      ),
    );
  }

  String _getDifficultyIcon(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return 'trending_down';
      case 'medium':
        return 'trending_flat';
      case 'hard':
        return 'trending_up';
      default:
        return 'trending_flat';
    }
  }

  String _getPreferenceDescription(String preference) {
    switch (preference) {
      case 'Include Stretching':
        return 'Add flexibility and mobility exercises';
      case 'Focus on Core':
        return 'Emphasize core strengthening exercises';
      case 'Upper Body Priority':
        return 'Include more upper body recovery work';
      case 'Lower Body Priority':
        return 'Focus on lower body recovery exercises';
      case 'Balance Training':
        return 'Include stability and balance exercises';
      case 'Foam Rolling':
        return 'Add myofascial release exercises';
      default:
        return 'Customize your recovery plan';
    }
  }
}
