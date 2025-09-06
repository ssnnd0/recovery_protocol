import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ToggleSettingsItemWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String iconName;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? iconColor;

  const ToggleSettingsItemWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.iconName,
    required this.value,
    required this.onChanged,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          // Icon
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: (iconColor ?? AppTheme.lightTheme.colorScheme.primary)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: iconColor ?? AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
            ),
          ),
          SizedBox(width: 4.w),

          // Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle!,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Toggle Switch
          SizedBox(width: 2.w),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.lightTheme.colorScheme.primary,
            inactiveThumbColor: AppTheme.lightTheme.colorScheme.outline,
            inactiveTrackColor:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}
