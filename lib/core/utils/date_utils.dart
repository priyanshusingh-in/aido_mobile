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
    return date.year == now.year && date.month == now.month && date.day == now.day;
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

  static List<DateTime> getReminderTimes(DateTime scheduleTime, List<int> reminderMinutes) {
    return reminderMinutes
        .map((minutes) => scheduleTime.subtract(Duration(minutes: minutes)))
        .where((reminderTime) => reminderTime.isAfter(DateTime.now()))
        .toList();
  }
}