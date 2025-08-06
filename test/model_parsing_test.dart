import 'package:flutter_test/flutter_test.dart';
import 'package:aido/features/schedule/data/models/schedule_models.dart';
import 'package:aido/features/auth/data/models/auth_models.dart';
import 'package:aido/features/schedule/domain/entities/schedule.dart';
import 'package:aido/features/auth/domain/entities/user.dart';
import 'package:aido/core/utils/date_utils.dart' as app_date_utils;

void main() {
  group('Model Parsing Tests', () {
    test('ScheduleModel.fromJson handles null values correctly', () {
      // Test with null values that could cause type casting errors
      final jsonWithNulls = {
        'id': null,
        'type': 'meeting',
        'title': null, // This was causing the error
        'description': null,
        'date': null, // This was causing the error
        'time': null, // This was causing the error
        'duration': null,
        'participants': null,
        'location': null,
        'priority': 'medium',
        'category': null,
        'metadata': null,
        'userId': null,
        'aiPrompt': null, // This was causing the error
        'createdAt': null, // This was causing the error
        'updatedAt': null, // This was causing the error
      };

      // This should not throw a type casting error
      expect(() {
        final schedule = ScheduleModel.fromJson(jsonWithNulls);
        expect(schedule.title, 'Untitled Schedule');
        expect(schedule.date, isNotEmpty);
        expect(schedule.time, '00:00');
        expect(schedule.aiPrompt, '');
        expect(schedule.createdAt, isA<DateTime>());
        expect(schedule.updatedAt, isA<DateTime>());
      }, returnsNormally);
    });

    test('ScheduleModel.fromJson handles valid data correctly', () {
      final validJson = {
        'id': '123',
        'type': 'meeting',
        'title': 'Test Meeting',
        'description': 'Test Description',
        'date': '2024-01-15',
        'time': '14:30',
        'duration': 60,
        'participants': ['user1', 'user2'],
        'location': 'Conference Room',
        'priority': 'high',
        'category': 'work',
        'metadata': {'key': 'value'},
        'userId': 'user123',
        'aiPrompt': 'Create a meeting',
        'createdAt': '2024-01-15T10:00:00Z',
        'updatedAt': '2024-01-15T10:00:00Z',
      };

      final schedule = ScheduleModel.fromJson(validJson);

      expect(schedule.id, '123');
      expect(schedule.type, ScheduleType.meeting);
      expect(schedule.title, 'Test Meeting');
      expect(schedule.description, 'Test Description');
      expect(schedule.date, '2024-01-15');
      expect(schedule.time, '14:30');
      expect(schedule.duration, 60);
      expect(schedule.participants, ['user1', 'user2']);
      expect(schedule.location, 'Conference Room');
      expect(schedule.priority, Priority.high);
      expect(schedule.category, 'work');
      expect(schedule.userId, 'user123');
      expect(schedule.aiPrompt, 'Create a meeting');
    });

    test('UserModel.fromJson handles null values correctly', () {
      final jsonWithNulls = {
        'id': null,
        'email': null,
        'firstName': null,
        'lastName': null,
        'isActive': null,
        'createdAt': null,
        'updatedAt': null,
      };

      expect(() {
        final user = UserModel.fromJson(jsonWithNulls);
        expect(user.id, '');
        expect(user.email, '');
        expect(user.firstName, '');
        expect(user.lastName, '');
        expect(user.isActive, true);
        expect(user.createdAt, isA<DateTime>());
        expect(user.updatedAt, isA<DateTime>());
      }, returnsNormally);
    });

    test('UserModel.fromJson handles valid data correctly', () {
      final validJson = {
        'id': 'user123',
        'email': 'test@example.com',
        'firstName': 'John',
        'lastName': 'Doe',
        'isActive': true,
        'createdAt': '2024-01-15T10:00:00Z',
        'updatedAt': '2024-01-15T10:00:00Z',
      };

      final user = UserModel.fromJson(validJson);

      expect(user.id, 'user123');
      expect(user.email, 'test@example.com');
      expect(user.firstName, 'John');
      expect(user.lastName, 'Doe');
      expect(user.isActive, true);
      expect(user.fullName, 'John Doe');
    });
  });

  group('DateUtils Tests', () {
    test('should detect relative time expressions', () {
      expect(
          app_date_utils.DateUtils.containsRelativeTime(
              'remind me to call mom in 2 minutes'),
          true);
      expect(
          app_date_utils.DateUtils.containsRelativeTime(
              'schedule a meeting in 1 hour'),
          true);
      expect(
          app_date_utils.DateUtils.containsRelativeTime(
              'create a task in 3 days'),
          true);
      expect(
          app_date_utils.DateUtils.containsRelativeTime(
              'remind me to buy groceries in 1 week'),
          true);
      expect(
          app_date_utils.DateUtils.containsRelativeTime(
              'meeting with John tomorrow at 3 PM'),
          false);
      expect(
          app_date_utils.DateUtils.containsRelativeTime(
              'just a regular reminder'),
          false);
    });

    test('should extract relative time information', () {
      final result1 = app_date_utils.DateUtils.extractRelativeTime(
          'remind me to call mom in 2 minutes');
      expect(result1?['value'], 2);
      expect(result1?['unit'], 'minute');

      final result2 = app_date_utils.DateUtils.extractRelativeTime(
          'schedule a meeting in 1 hour');
      expect(result2?['value'], 1);
      expect(result2?['unit'], 'hour');

      final result3 = app_date_utils.DateUtils.extractRelativeTime(
          'create a task in 3 days');
      expect(result3?['value'], 3);
      expect(result3?['unit'], 'day');
    });

    test('should format relative time for display', () {
      expect(
          app_date_utils.DateUtils.formatRelativeTime(
              'remind me to call mom in 2 minutes'),
          '2 minutes from now');
      expect(
          app_date_utils.DateUtils.formatRelativeTime(
              'schedule a meeting in 1 hour'),
          '1 hour from now');
      expect(
          app_date_utils.DateUtils.formatRelativeTime(
              'create a task in 3 days'),
          '3 days from now');
      expect(app_date_utils.DateUtils.formatRelativeTime('regular text'),
          'regular text');
    });

    test('should provide relative time examples', () {
      final examples = app_date_utils.DateUtils.getRelativeTimeExamples();
      expect(examples.length, greaterThan(0));
      expect(examples.contains('in 2 minutes'), true);
      expect(examples.contains('in 1 hour'), true);
      expect(examples.contains('in 3 days'), true);
      expect(examples.contains('in 1 week'), true);
    });
  });
}
