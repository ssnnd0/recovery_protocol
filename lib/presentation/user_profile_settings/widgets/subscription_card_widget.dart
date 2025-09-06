import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SubscriptionCardWidget extends StatelessWidget {
  final Map<String, dynamic> subscriptionData;
  final VoidCallback onManageTap;

  const SubscriptionCardWidget({
    super.key,
    required this.subscriptionData,
    required this.onManageTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPremium = subscriptionData["isPremium"] as bool? ?? false;
    final String planName =
        subscriptionData["planName"] as String? ?? "Free Plan";
    final String nextBilling = subscriptionData["nextBilling"] as String? ?? "";
    final String price = subscriptionData["price"] as String? ?? "";

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: isPremium
            ? LinearGradient(
                colors: [
                  AppTheme.lightTheme.colorScheme.primary,
                  AppTheme.lightTheme.colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isPremium ? null : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: isPremium
            ? null
            : Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: isPremium ? 'workspace_premium' : 'account_circle',
                color: isPremium
                    ? Colors.white
                    : AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      planName,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isPremium
                            ? Colors.white
                            : AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    if (price.isNotEmpty) ...[
                      SizedBox(height: 0.5.h),
                      Text(
                        price,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: isPremium
                              ? Colors.white.withValues(alpha: 0.9)
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isPremium)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Text(
                    "PREMIUM",
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          if (nextBilling.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Text(
              "Next billing: $nextBilling",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isPremium
                    ? Colors.white.withValues(alpha: 0.8)
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          SizedBox(height: 3.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onManageTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: isPremium
                    ? Colors.white
                    : AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: isPremium
                    ? AppTheme.lightTheme.colorScheme.primary
                    : Colors.white,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
              child: Text(
                isPremium ? "Manage Subscription" : "Upgrade to Premium",
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
