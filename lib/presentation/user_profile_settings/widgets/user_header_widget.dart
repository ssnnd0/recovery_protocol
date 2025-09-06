import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UserHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onEditTap;

  const UserHeaderWidget({
    super.key,
    required this.userData,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          // Profile Photo
          GestureDetector(
            onTap: onEditTap,
            child: Container(
              width: 16.w,
              height: 16.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: CustomImageWidget(
                  imageUrl: userData["profilePhoto"] as String? ?? "",
                  width: 16.w,
                  height: 16.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(width: 4.w),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        userData["name"] as String? ?? "User Name",
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: onEditTap,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: CustomIconWidget(
                          iconName: 'edit',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 4.w,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),

                Text(
                  userData["email"] as String? ?? "user@email.com",
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.h),

                // Current Streak
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'local_fire_department',
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        "${userData["currentStreak"] ?? 0} day streak",
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
