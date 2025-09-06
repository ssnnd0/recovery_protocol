import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptySearchState extends StatelessWidget {
  final String searchQuery;
  final VoidCallback onClearSearch;
  final Function(String) onSuggestionTap;

  const EmptySearchState({
    super.key,
    required this.searchQuery,
    required this.onClearSearch,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    final suggestions = [
      'Shoulder stretches',
      'Core strengthening',
      'Foam rolling',
      'Hip mobility',
      'Back exercises',
      'Leg recovery',
    ];

    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty state icon
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: CustomIconWidget(
                iconName: 'search_off',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 48,
              ),
            ),
            SizedBox(height: 3.h),
            // Title
            Text(
              searchQuery.isEmpty ? 'Start Your Search' : 'No Results Found',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            // Description
            Text(
              searchQuery.isEmpty
                  ? 'Search for exercises by name, body part, or equipment to get started.'
                  : 'We couldn\'t find any exercises matching "${searchQuery}". Try adjusting your search or browse our suggestions below.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            // Clear search button (only show if there's a search query)
            if (searchQuery.isNotEmpty) ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onClearSearch,
                  child: Text('Clear Search'),
                ),
              ),
              SizedBox(height: 3.h),
            ],
            // Suggestions
            Text(
              'Popular Searches',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              alignment: WrapAlignment.center,
              children: suggestions.map((suggestion) {
                return GestureDetector(
                  onTap: () => onSuggestionTap(suggestion),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'search',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          suggestion,
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
