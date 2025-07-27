class AppConstants {
  static const String appName = 'AIdo';
  static const String appVersion = '1.0.0';
  
  // Storage keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String settingsKey = 'app_settings';
  
  // Notification settings
  static const String notificationChannelId = 'aido_schedules';
  static const String notificationChannelName = 'Schedule Notifications';
  static const String notificationChannelDescription = 'Notifications for scheduled events';
  
  // Date formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayTimeFormat = 'h:mm a';
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 500;
  
  // UI
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;
}