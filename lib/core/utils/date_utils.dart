import 'package:intl/intl.dart';

import '../constants/app_constants.dart';

class DateUtils {
  static String formatDate(DateTime date) {
    return DateFormat(AppConstants.dateFormat).format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat(AppConstants.timeFormat).format(time);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat(AppConstants.dateTimeFormat).format(dateTime);
  }

  static String formatDisplayDate(DateTime date) {
    return DateFormat(AppConstants.displayDateFormat).format(date);
  }

  static String formatDisplayTime(DateTime time) {
    return DateFormat(AppConstants.displayTimeFormat).format(time);
  }

  static DateTime parseDate(String dateString) {
    return DateFormat(AppConstants.dateFormat).parse(dateString);
  }

  static DateTime parseTime(String timeString) {
    return DateFormat(AppConstants.timeFormat).parse(timeString);
  }

  static DateTime parseDateTime(String dateTimeString) {
    return DateFormat(AppConstants.dateTimeFormat).parse(dateTimeString);
  }

  static DateTime combineDateTime(String date, String time) {
    final dateTime = DateTime.parse('$date $time:00');
    return dateTime;
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  static String getRelativeDateString(DateTime date) {
    if (isToday(date)) {
      return 'Today';
    } else if (isTomorrow(date)) {
      return 'Tomorrow';
    } else if (isThisWeek(date)) {
      return DateFormat('EEEE').format(date);
    } else {
      return formatDisplayDate(date);
    }
  }

  static Duration getTimeDifference(DateTime from, DateTime to) {
    return to.difference(from);
  }

  static bool isPastDue(DateTime dateTime) {
    return dateTime.isBefore(DateTime.now());
  }

  static List<DateTime> getReminderTimes(
      DateTime scheduleTime, List<int> reminderMinutes) {
    return reminderMinutes
        .map((minutes) => scheduleTime.subtract(Duration(minutes: minutes)))
        .where((reminderTime) => reminderTime.isAfter(DateTime.now()))
        .toList();
  }

  /// Validates if a string contains relative time expressions
  /// Examples: "in 2 minutes", "in 1 hour", "in 3 days", "in 1 week"
  static bool containsRelativeTime(String text) {
    final relativeTimePattern = RegExp(
      r'\b(?:in\s+)?(\d+)\s+(?:minute|hour|day|week|month|year)s?\b',
      caseSensitive: false,
    );
    return relativeTimePattern.hasMatch(text);
  }

  /// Extracts relative time information from text
  /// Returns a map with 'value' and 'unit' keys, or null if not found
  static Map<String, dynamic>? extractRelativeTime(String text) {
    final pattern = RegExp(
      r'\b(?:in\s+)?(\d+)\s+(minute|hour|day|week|month|year)s?\b',
      caseSensitive: false,
    );

    final match = pattern.firstMatch(text);
    if (match != null) {
      return {
        'value': int.parse(match.group(1)!),
        'unit': match.group(2)!.toLowerCase(),
      };
    }
    return null;
  }

  /// Formats relative time for display
  /// Example: "in 2 minutes" -> "2 minutes from now"
  static String formatRelativeTime(String text) {
    final relativeTime = extractRelativeTime(text);
    if (relativeTime != null) {
      final value = relativeTime['value'];
      final unit = relativeTime['unit'];
      return '$value $unit${value > 1 ? 's' : ''} from now';
    }
    return text;
  }

  /// Gets example relative time expressions for UI
  static List<String> getRelativeTimeExamples() {
    return [
      'in 2 minutes',
      'in 1 hour',
      'in 3 days',
      'in 1 week',
      'in 30 minutes',
      'in 2 hours',
      'in 1 month',
    ];
  }
}
