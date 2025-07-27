import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

import '../constants/app_constants.dart';
import '../../features/schedule/domain/entities/schedule.dart' hide Priority;

class NotificationUtils {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _createNotificationChannel();
    await _requestPermissions();
  }

  static Future<void> _createNotificationChannel() async {
    const androidChannel = AndroidNotificationChannel(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      description: AppConstants.notificationChannelDescription,
      importance: Importance.high,
      playSound: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  static Future<void> _requestPermissions() async {
    await Permission.notification.request();

    // For iOS
    await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    debugPrint('Notification tapped: ${response.payload}');
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    if (scheduledTime.isBefore(DateTime.now())) {
      return; // Don't schedule past notifications
    }

    const androidDetails = AndroidNotificationDetails(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      channelDescription: AppConstants.notificationChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> scheduleScheduleNotifications(Schedule schedule) async {
    final scheduleDateTime =
        DateTime.parse('${schedule.date} ${schedule.time}:00');

    // Default reminder times (in minutes before the event)
    const defaultReminders = [5, 15, 60]; // 5 min, 15 min, 1 hour

    for (int i = 0; i < defaultReminders.length; i++) {
      final reminderTime = scheduleDateTime.subtract(
        Duration(minutes: defaultReminders[i]),
      );

      if (reminderTime.isAfter(DateTime.now())) {
        await scheduleNotification(
          id: schedule.id.hashCode + i,
          title: _getNotificationTitle(schedule, defaultReminders[i]),
          body: _getNotificationBody(schedule, defaultReminders[i]),
          scheduledTime: reminderTime,
          payload: schedule.id,
        );
      }
    }
  }

  static String _getNotificationTitle(Schedule schedule, int minutesBefore) {
    if (minutesBefore < 60) {
      return '${schedule.title} in $minutesBefore minutes';
    } else {
      final hours = minutesBefore ~/ 60;
      return '${schedule.title} in $hours hour${hours > 1 ? 's' : ''}';
    }
  }

  static String _getNotificationBody(Schedule schedule, int minutesBefore) {
    final scheduleTime = DateTime.parse('${schedule.date} ${schedule.time}:00');
    final timeString = _formatTime(scheduleTime);

    String body = 'Scheduled for $timeString';
    if (schedule.location?.isNotEmpty == true) {
      body += ' at ${schedule.location}';
    }
    return body;
  }

  static String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  static Future<void> cancelScheduleNotifications(String scheduleId) async {
    // Cancel all notifications for this schedule
    for (int i = 0; i < 3; i++) {
      await _notifications.cancel(scheduleId.hashCode + i);
    }
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  static Future<List<PendingNotificationRequest>>
      getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}
