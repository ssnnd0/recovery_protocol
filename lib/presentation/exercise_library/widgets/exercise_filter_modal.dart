import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExerciseFilterModal extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const ExerciseFilterModal({
    super.key,
    required this.currentFilters,
    required this.onFiltersApplied,
  });

  @override
  State<ExerciseFilterModal> createState() => _ExerciseFilterModalState();
}

class _ExerciseFilterModalState extends State<ExerciseFilterModal> {
  late Map<String, dynamic> _filters;

  final List<String> _equipmentOptions = [
    'None',
    'Dumbbells',
    'Resistance Band',
    'Foam Roller',
    'Yoga Mat',
    'Exercise Ball',
    'Kettlebell',
  ];

  final List<String> _bodyAreaOptions = [
    'Upper Body',
    'Lower Body',
    'Core',
    'Back',
    'Shoulders',
    'Arms',
    'Legs',
    'Glutes',
  ];

  final List<String> _difficultyOptions = [
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  final List<String> _durationOptions = [
    '0-5 min',
    '5-10 min',
    '10-15 min',
    '15-30 min',
    '30+ min',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Filter Exercises',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text(
                    'Clear All',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          // Filter content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterSection(
                    'Equipment Available',
                    _equipmentOptions,
                    'equipment',
                    true,
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    'Body Focus Areas',
                    _bodyAreaOptions,
                    'bodyAreas',
                    true,
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    'Difficulty Level',
                    _difficultyOptions,
                    'difficulty',
                    false,
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    'Duration',
                    _durationOptions,
                    'duration',
                    false,
                  ),
                ],
              ),
            ),
          ),
          // Apply button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
                child: Text(
                  'Apply Filters',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> options,
    String filterKey,
    bool allowMultiple,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: options.map((option) {
            final isSelected = allowMultiple
                ? (_filters[filterKey] as List<String>?)?.contains(option) ??
                    false
                : _filters[filterKey] == option;

            return GestureDetector(
              onTap: () => _toggleFilter(filterKey, option, allowMultiple),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  option,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _toggleFilter(String filterKey, String option, bool allowMultiple) {
    setState(() {
      if (allowMultiple) {
        final currentList =
            (_filters[filterKey] as List<String>?) ?? <String>[];
        if (currentList.contains(option)) {
          currentList.remove(option);
        } else {
          currentList.add(option);
        }
        _filters[filterKey] = currentList;
      } else {
        if (_filters[filterKey] == option) {
          _filters[filterKey] = null;
        } else {
          _filters[filterKey] = option;
        }
      }
    });
  }

  void _clearAllFilters() {
    setState(() {
      _filters = {
        'equipment': <String>[],
        'bodyAreas': <String>[],
        'difficulty': null,
        'duration': null,
      };
    });
  }

  void _applyFilters() {
    widget.onFiltersApplied(_filters);
    Navigator.pop(context);
  }
}
