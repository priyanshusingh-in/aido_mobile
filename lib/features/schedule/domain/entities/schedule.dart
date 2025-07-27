import 'package:equatable/equatable.dart';

enum ScheduleType { meeting, reminder, task, appointment }

enum Priority { low, medium, high }

class Schedule extends Equatable {
  final String? id;
  final ScheduleType type;
  final String title;
  final String? description;
  final String date; // YYYY-MM-DD
  final String time; // HH:MM
  final int? duration; // minutes
  final List<String>? participants;
  final String? location;
  final Priority priority;
  final String? category;
  final Map<String, dynamic>? metadata;
  final String? userId;
  final String aiPrompt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Schedule({
    this.id,
    required this.type,
    required this.title,
    this.description,
    required this.date,
    required this.time,
    this.duration,
    this.participants,
    this.location,
    required this.priority,
    this.category,
    this.metadata,
    this.userId,
    required this.aiPrompt,
    required this.createdAt,
    required this.updatedAt,
  });

  DateTime get dateTime {
    return DateTime.parse('$date $time:00');
  }

  bool get isPastDue {
    return dateTime.isBefore(DateTime.now());
  }

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        description,
        date,
        time,
        duration,
        participants,
        location,
        priority,
        category,
        metadata,
        userId,
        aiPrompt,
        createdAt,
        updatedAt,
      ];
}