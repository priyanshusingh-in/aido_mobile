import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/schedule.dart';

part 'schedule_models.g.dart';

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
    required super.createdAt,
    required super.updatedAt,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleModelFromJson(json);

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
