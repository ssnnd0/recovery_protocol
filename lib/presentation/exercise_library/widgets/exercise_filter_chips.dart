import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ExerciseFilterChips extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final Function(String?) onCategorySelected;
  final Map<String, int> categoryCounts;

  const ExerciseFilterChips({
    super.key,
    required this.categories,
    this.selectedCategory,
    required this.onCategorySelected,
    this.categoryCounts = const {},
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6.h,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: categories.length + 1, // +1 for "All" chip
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildFilterChip(
              context,
              'All',
              selectedCategory == null,
              () => onCategorySelected(null),
              null,
            );
          }

          final category = categories[index - 1];
          final isSelected = selectedCategory == category;
          final count = categoryCounts[category];

          return _buildFilterChip(
            context,
            category,
            isSelected,
            () => onCategorySelected(category),
            count,
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
    int? count,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatCategoryName(label),
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            if (count != null && count > 0) ...[
              SizedBox(width: 1.w),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.3.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.onPrimary
                          .withValues(alpha: 0.2)
                      : AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatCategoryName(String category) {
    switch (category.toLowerCase()) {
      case 'mobility':
        return 'Mobility';
      case 'strength':
        return 'Strength';
      case 'stretching':
        return 'Stretching';
      case 'foam rolling':
        return 'Foam Rolling';
      case 'all':
        return 'All';
      default:
        return category
            .split(' ')
            .map((word) => word.isNotEmpty
                ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                : word)
            .join(' ');
    }
  }
}
