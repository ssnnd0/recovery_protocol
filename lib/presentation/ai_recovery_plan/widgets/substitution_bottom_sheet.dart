import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SubstitutionBottomSheet extends StatefulWidget {
  final Map<String, dynamic> originalExercise;
  final List<Map<String, dynamic>> alternatives;
  final Function(Map<String, dynamic>) onSubstitute;

  const SubstitutionBottomSheet({
    super.key,
    required this.originalExercise,
    required this.alternatives,
    required this.onSubstitute,
  });

  @override
  State<SubstitutionBottomSheet> createState() =>
      _SubstitutionBottomSheetState();
}

class _SubstitutionBottomSheetState extends State<SubstitutionBottomSheet> {
  String _selectedDifficulty = 'All';
  String _selectedEquipment = 'All';

  List<Map<String, dynamic>> get _filteredAlternatives {
    return widget.alternatives.where((exercise) {
      final difficultyMatch = _selectedDifficulty == 'All' ||
          exercise["difficulty"] == _selectedDifficulty;
      final equipmentMatch = _selectedEquipment == 'All' ||
          (exercise["equipment"] as List).contains(_selectedEquipment);
      return difficultyMatch && equipmentMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 80.h,
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
                        'Exercise Alternatives',
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
                SizedBox(height: 1.h),
                Text(
                  'Replacing: ${widget.originalExercise["name"]}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 2.h),
                _buildFilters(theme),
                SizedBox(height: 2.h),
              ],
            ),
          ),
          Expanded(
            child: _filteredAlternatives.isEmpty
                ? _buildEmptyState(theme)
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    itemCount: _filteredAlternatives.length,
                    itemBuilder: (context, index) {
                      final exercise = _filteredAlternatives[index];
                      return _buildAlternativeCard(theme, exercise);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildFilterDropdown(
            theme,
            'Difficulty',
            _selectedDifficulty,
            ['All', 'Easy', 'Medium', 'Hard'],
            (value) => setState(() => _selectedDifficulty = value!),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: _buildFilterDropdown(
            theme,
            'Equipment',
            _selectedEquipment,
            ['All', 'None', 'Resistance Band', 'Foam Roller', 'Yoga Block'],
            (value) => setState(() => _selectedEquipment = value!),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterDropdown(
    ThemeData theme,
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(label),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          items: options.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildAlternativeCard(ThemeData theme, Map<String, dynamic> exercise) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: InkWell(
        onTap: () {
          widget.onSubstitute(exercise);
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CustomImageWidget(
                  imageUrl: exercise["thumbnail"] as String,
                  width: 18.w,
                  height: 18.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise["name"] as String,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'schedule',
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 14,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          exercise["duration"] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(
                                    exercise["difficulty"] as String)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            exercise["difficulty"] as String,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: _getDifficultyColor(
                                  exercise["difficulty"] as String),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              CustomIconWidget(
                iconName: 'swap_horiz',
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search_off',
            color: theme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No alternatives found',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Try adjusting your filters',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }
}
