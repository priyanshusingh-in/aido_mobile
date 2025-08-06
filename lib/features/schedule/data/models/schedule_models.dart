import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/schedule.dart';

part 'schedule_models.g.dart';

// Helper functions for enum decoding
T $enumDecode<T extends Enum>(Map<T, String> enumMap, dynamic source) {
  if (source == null) {
    throw ArgumentError('source is null');
  }

  if (source is String) {
    final entry = enumMap.entries.firstWhere(
      (entry) => entry.value == source,
      orElse: () => throw ArgumentError('Unknown enum value: $source'),
    );
    return entry.key;
  }

  throw ArgumentError('source is not a string: $source');
}

T? $enumDecodeNullable<T extends Enum>(Map<T, String> enumMap, dynamic source) {
  if (source == null) {
    return null;
  }

  if (source is String) {
    final entry = enumMap.entries.firstWhere(
      (entry) => entry.value == source,
      orElse: () => throw ArgumentError('Unknown enum value: $source'),
    );
    return entry.key;
  }

  throw ArgumentError('source is not a string: $source');
}

@JsonSerializable()
class ScheduleModel extends Schedule {
  const ScheduleModel({
    super.id,
    required super.type,
    required super.title,
    super.description,
    required super.date,
    required super.time,
    super.duration,
    super.participants,
    super.location,
    required super.priority,
    super.category,
    super.metadata,
    super.userId,
    required super.aiPrompt,
    required super.aiResponse,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    // Handle nullable fields from API response with default values
    final title = json['title'] as String? ?? 'Untitled Schedule';
    final date = json['date'] as String? ??
        DateTime.now().toIso8601String().split('T')[0];
    final time = json['time'] as String? ?? '00:00';
    final aiPrompt = json['aiPrompt'] as String? ?? '';
    final aiResponse = json['aiResponse'] as String? ?? '';

    return ScheduleModel(
      id: json['id'] as String?,
      type: $enumDecode(_$ScheduleTypeEnumMap, json['type']),
      title: title,
      description: json['description'] as String?,
      date: date,
      time: time,
      duration: (json['duration'] as num?)?.toInt(),
      participants: (json['participants'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      location: json['location'] as String?,
      priority: $enumDecode(_$PriorityEnumMap, json['priority']),
      category: json['category'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      userId: json['userId'] as String?,
      aiPrompt: aiPrompt,
      aiResponse: aiResponse,
      createdAt: DateTime.parse(
          json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updatedAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => _$ScheduleModelToJson(this);

  factory ScheduleModel.fromEntity(Schedule schedule) {
    return ScheduleModel(
      id: schedule.id,
      type: schedule.type,
      title: schedule.title,
      description: schedule.description,
      date: schedule.date,
      time: schedule.time,
      duration: schedule.duration,
      participants: schedule.participants,
      location: schedule.location,
      priority: schedule.priority,
      category: schedule.category,
      metadata: schedule.metadata,
      userId: schedule.userId,
      aiPrompt: schedule.aiPrompt,
      aiResponse: schedule.aiResponse,
      createdAt: schedule.createdAt,
      updatedAt: schedule.updatedAt,
    );
  }
}

@JsonSerializable()
class CreateScheduleRequest {
  final String prompt;

  const CreateScheduleRequest({
    required this.prompt,
  });

  factory CreateScheduleRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateScheduleRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateScheduleRequestToJson(this);
}

@JsonSerializable()
class UpdateScheduleRequest {
  final ScheduleType? type;
  final String? title;
  final String? description;
  final String? date;
  final String? time;
  final int? duration;
  final List<String>? participants;
  final String? location;
  final Priority? priority;
  final String? category;

  const UpdateScheduleRequest({
    this.type,
    this.title,
    this.description,
    this.date,
    this.time,
    this.duration,
    this.participants,
    this.location,
    this.priority,
    this.category,
  });

  factory UpdateScheduleRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateScheduleRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateScheduleRequestToJson(this);

  factory UpdateScheduleRequest.fromSchedule(Schedule schedule) {
    return UpdateScheduleRequest(
      type: schedule.type,
      title: schedule.title,
      description: schedule.description,
      date: schedule.date,
      time: schedule.time,
      duration: schedule.duration,
      participants: schedule.participants,
      location: schedule.location,
      priority: schedule.priority,
      category: schedule.category,
    );
  }
}

@JsonSerializable()
class ScheduleResponse {
  final bool success;
  final String? message;
  final String? error;
  final ScheduleModel? data;

  const ScheduleResponse({
    required this.success,
    this.message,
    this.error,
    this.data,
  });

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) =>
      _$ScheduleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleResponseToJson(this);
}

@JsonSerializable()
class ScheduleListResponse {
  final bool success;
  final String? message;
  final String? error;
  final List<ScheduleModel>? data;
  final int? total;
  final int? page;
  final int? limit;

  const ScheduleListResponse({
    required this.success,
    this.message,
    this.error,
    this.data,
    this.total,
    this.page,
    this.limit,
  });

  factory ScheduleListResponse.fromJson(Map<String, dynamic> json) =>
      _$ScheduleListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleListResponseToJson(this);
}
