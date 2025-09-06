import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/subscription_card_widget.dart';
import './widgets/toggle_settings_item_widget.dart';
import './widgets/user_header_widget.dart';

class UserProfileSettings extends StatefulWidget {
  const UserProfileSettings({super.key});

  @override
  State<UserProfileSettings> createState() => _UserProfileSettingsState();
}

class _UserProfileSettingsState extends State<UserProfileSettings> {
  int _currentBottomNavIndex = 0;

  // Mock user data
  final Map<String, dynamic> userData = {
    "id": 1,
    "name": "Sarah Johnson",
    "email": "sarah.johnson@email.com",
    "profilePhoto":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    "currentStreak": 12,
    "sport": "Swimming",
    "fitnessLevel": "Advanced",
    "units": "Metric",
    "joinDate": "January 2024",
  };

  // Mock subscription data
  final Map<String, dynamic> subscriptionData = {
    "isPremium": true,
    "planName": "Recovery Pro",
    "price": "\$9.99/month",
    "nextBilling": "January 15, 2025",
  };

  // Settings state
  bool _healthKitEnabled = true;
  bool _dailyCheckInReminders = true;
  bool _recoveryPlanAlerts = true;
  bool _achievementNotifications = false;
  bool _dataExportEnabled = true;
  String _selectedUnits = "Metric";
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: "Profile Settings",
        showBackButton: false,
        actions: [
          IconButton(
            onPressed: _showHelpDialog,
            icon: CustomIconWidget(
              iconName: 'help_outline',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),

              // User Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: UserHeaderWidget(
                  userData: userData,
                  onEditTap: _editProfile,
                ),
              ),

              SizedBox(height: 3.h),

              // Account Section
              SettingsSectionWidget(
                title: "Account",
                children: [
                  SettingsItemWidget(
                    title: "Personal Information",
                    subtitle: "Name, email, profile photo",
                    iconName: 'person',
                    onTap: _editProfile,
                  ),
                  SettingsItemWidget(
                    title: "Sport Preferences",
                    subtitle: userData["sport"] as String? ?? "Not set",
                    iconName: 'sports',
                    onTap: _editSportPreferences,
                  ),
                  SettingsItemWidget(
                    title: "Fitness Level",
                    subtitle: userData["fitnessLevel"] as String? ?? "Not set",
                    iconName: 'fitness_center',
                    onTap: _editFitnessLevel,
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Health Integration Section
              SettingsSectionWidget(
                title: "Health Integration",
                children: [
                  ToggleSettingsItemWidget(
                    title: "HealthKit Sync",
                    subtitle: _healthKitEnabled
                        ? "Connected and syncing"
                        : "Disconnected",
                    iconName: 'health_and_safety',
                    value: _healthKitEnabled,
                    onChanged: (value) {
                      setState(() {
                        _healthKitEnabled = value;
                      });
                      _showHealthKitDialog(value);
                    },
                    iconColor: AppTheme.lightTheme.colorScheme.secondary,
                  ),
                  SettingsItemWidget(
                    title: "Data Sources",
                    subtitle: "Manage connected apps and devices",
                    iconName: 'devices',
                    onTap: _manageDataSources,
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Notifications Section
              SettingsSectionWidget(
                title: "Notifications",
                children: [
                  ToggleSettingsItemWidget(
                    title: "Daily Check-in Reminders",
                    subtitle: _dailyCheckInReminders
                        ? "Enabled at ${_reminderTime.format(context)}"
                        : "Disabled",
                    iconName: 'notifications',
                    value: _dailyCheckInReminders,
                    onChanged: (value) {
                      setState(() {
                        _dailyCheckInReminders = value;
                      });
                    },
                  ),
                  ToggleSettingsItemWidget(
                    title: "Recovery Plan Alerts",
                    subtitle: "Get notified about new recovery plans",
                    iconName: 'psychology',
                    value: _recoveryPlanAlerts,
                    onChanged: (value) {
                      setState(() {
                        _recoveryPlanAlerts = value;
                      });
                    },
                  ),
                  ToggleSettingsItemWidget(
                    title: "Achievement Notifications",
                    subtitle: "Celebrate your progress milestones",
                    iconName: 'emoji_events',
                    value: _achievementNotifications,
                    onChanged: (value) {
                      setState(() {
                        _achievementNotifications = value;
                      });
                    },
                    iconColor: AppTheme.lightTheme.colorScheme.tertiary,
                  ),
                  SettingsItemWidget(
                    title: "Reminder Time",
                    subtitle: "Set your preferred reminder time",
                    iconName: 'schedule',
                    onTap: _selectReminderTime,
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Subscription Section
              SettingsSectionWidget(
                title: "Subscription",
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    child: SubscriptionCardWidget(
                      subscriptionData: subscriptionData,
                      onManageTap: _manageSubscription,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Data & Privacy Section
              SettingsSectionWidget(
                title: "Data & Privacy",
                children: [
                  ToggleSettingsItemWidget(
                    title: "Data Export",
                    subtitle: "Allow exporting your wellness data",
                    iconName: 'file_download',
                    value: _dataExportEnabled,
                    onChanged: (value) {
                      setState(() {
                        _dataExportEnabled = value;
                      });
                    },
                  ),
                  SettingsItemWidget(
                    title: "Export Data",
                    subtitle: "Download your wellness data",
                    iconName: 'download',
                    onTap: _dataExportEnabled ? _exportData : null,
                  ),
                  SettingsItemWidget(
                    title: "Privacy Policy",
                    subtitle: "View our privacy policy",
                    iconName: 'privacy_tip',
                    onTap: _viewPrivacyPolicy,
                  ),
                  SettingsItemWidget(
                    title: "Delete Account",
                    subtitle: "Permanently delete your account",
                    iconName: 'delete_forever',
                    iconColor: AppTheme.lightTheme.colorScheme.error,
                    onTap: _deleteAccount,
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // App Preferences Section
              SettingsSectionWidget(
                title: "App Preferences",
                children: [
                  SettingsItemWidget(
                    title: "Units",
                    subtitle: _selectedUnits,
                    iconName: 'straighten',
                    onTap: _selectUnits,
                  ),
                  SettingsItemWidget(
                    title: "Accessibility",
                    subtitle: "Adjust app accessibility settings",
                    iconName: 'accessibility',
                    onTap: _accessibilitySettings,
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Support Section
              SettingsSectionWidget(
                title: "Support",
                children: [
                  SettingsItemWidget(
                    title: "Help Center",
                    subtitle: "Get help and support",
                    iconName: 'help_center',
                    onTap: _openHelpCenter,
                  ),
                  SettingsItemWidget(
                    title: "Contact Support",
                    subtitle: "Get in touch with our team",
                    iconName: 'support_agent',
                    onTap: _contactSupport,
                  ),
                  SettingsItemWidget(
                    title: "App Version",
                    subtitle: "Recovery Protocol v2.1.0",
                    iconName: 'info',
                    showArrow: false,
                    onTap: null,
                  ),
                ],
              ),

              SizedBox(height: 10.h), // Bottom padding for navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
        },
      ),
    );
  }

  void _editProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Edit Profile",
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          "Profile editing functionality would be implemented here with form fields for name, email, and profile photo upload.",
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  void _editSportPreferences() {
    final List<String> sports = [
      "Swimming",
      "Running",
      "Cycling",
      "Triathlon",
      "CrossFit",
      "Basketball",
      "Soccer",
      "Tennis",
      "Weightlifting",
      "Other"
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Select Sport",
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: sports.length,
            itemBuilder: (context, index) {
              final sport = sports[index];
              final isSelected = userData["sport"] == sport;
              return ListTile(
                title: Text(sport),
                leading: Radio<String>(
                  value: sport,
                  groupValue: userData["sport"] as String?,
                  onChanged: (value) {
                    setState(() {
                      userData["sport"] = value;
                    });
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _editFitnessLevel() {
    final List<String> levels = [
      "Beginner",
      "Intermediate",
      "Advanced",
      "Elite"
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Select Fitness Level",
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: levels.map((level) {
            return ListTile(
              title: Text(level),
              leading: Radio<String>(
                value: level,
                groupValue: userData["fitnessLevel"] as String?,
                onChanged: (value) {
                  setState(() {
                    userData["fitnessLevel"] = value;
                  });
                  Navigator.pop(context);
                },
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _showHealthKitDialog(bool enabled) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          enabled ? "HealthKit Connected" : "HealthKit Disconnected",
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          enabled
              ? "Your health data will now sync automatically with the Recovery Protocol app."
              : "Health data syncing has been disabled. You can re-enable it anytime.",
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _manageDataSources() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Data Sources",
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'health_and_safety',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 6.w,
              ),
              title: Text("Apple HealthKit"),
              subtitle: Text("Connected"),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'directions_run',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 6.w,
              ),
              title: Text("Strava"),
              subtitle: Text("Not connected"),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  void _selectReminderTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null && picked != _reminderTime) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  void _manageSubscription() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Manage Subscription",
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          "Subscription management would redirect to the App Store or Google Play Store subscription settings.",
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Would open subscription management
            },
            child: Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Export Data",
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          "Your wellness data will be exported as a CSV file. This may take a few moments.",
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Would trigger data export
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      "Data export started. You'll receive an email when ready."),
                  backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                ),
              );
            },
            child: Text("Export"),
          ),
        ],
      ),
    );
  }

  void _viewPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Privacy Policy",
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          "This would open the full privacy policy in a web view or dedicated screen.",
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Delete Account",
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.error,
          ),
        ),
        content: Text(
          "This action cannot be undone. All your data will be permanently deleted.",
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmAccountDeletion();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _confirmAccountDeletion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Final Confirmation",
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.error,
          ),
        ),
        content: Text(
          "Please confirm that you want to permanently delete your account. This action requires biometric authentication.",
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Would trigger biometric authentication
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      "Account deletion requires biometric authentication."),
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text("Confirm Delete"),
          ),
        ],
      ),
    );
  }

  void _selectUnits() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Select Units",
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text("Metric (kg, cm, km)"),
              leading: Radio<String>(
                value: "Metric",
                groupValue: _selectedUnits,
                onChanged: (value) {
                  setState(() {
                    _selectedUnits = value!;
                    userData["units"] = value;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: Text("Imperial (lbs, ft, miles)"),
              leading: Radio<String>(
                value: "Imperial",
                groupValue: _selectedUnits,
                onChanged: (value) {
                  setState(() {
                    _selectedUnits = value!;
                    userData["units"] = value;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _accessibilitySettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Accessibility Settings",
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          "Accessibility settings would include options for text size, contrast, voice over support, and other accessibility features.",
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  void _openHelpCenter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Help Center",
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          "This would open the help center with FAQs, tutorials, and troubleshooting guides.",
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  void _contactSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Contact Support",
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Get in touch with our support team:",
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Text(
              "Email: support@recoveryprotocol.com",
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              "Response time: Within 24 hours",
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Would open email client or in-app messaging
            },
            child: Text("Send Email"),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Profile Settings Help",
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          "Manage your account preferences, health integrations, notifications, and subscription settings. Tap any setting to customize your Recovery Protocol experience.",
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Got it"),
          ),
        ],
      ),
    );
  }
}
