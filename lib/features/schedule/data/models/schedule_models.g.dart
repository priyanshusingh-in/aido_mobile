// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleModel _$ScheduleModelFromJson(Map<String, dynamic> json) =>
    ScheduleModel(
      id: json['id'] as String?,
      type: $enumDecode(_$ScheduleTypeEnumMap, json['type']),
      title: json['title'] as String,
      description: json['description'] as String?,
      date: json['date'] as String,
      time: json['time'] as String,
      duration: (json['duration'] as num?)?.toInt(),
      participants: (json['participants'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      location: json['location'] as String?,
      priority: $enumDecode(_$PriorityEnumMap, json['priority']),
      category: json['category'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      userId: json['userId'] as String?,
      aiPrompt: json['aiPrompt'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ScheduleModelToJson(ScheduleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$ScheduleTypeEnumMap[instance.type]!,
      'title': instance.title,
      'description': instance.description,
      'date': instance.date,
      'time': instance.time,
      'duration': instance.duration,
      'participants': instance.participants,
      'location': instance.location,
      'priority': _$PriorityEnumMap[instance.priority]!,
      'category': instance.category,
      'metadata': instance.metadata,
      'userId': instance.userId,
      'aiPrompt': instance.aiPrompt,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ScheduleTypeEnumMap = {
  ScheduleType.meeting: 'meeting',
  ScheduleType.reminder: 'reminder',
  ScheduleType.task: 'task',
  ScheduleType.appointment: 'appointment',
};

const _$PriorityEnumMap = {
  Priority.low: 'low',
  Priority.medium: 'medium',
  Priority.high: 'high',
};

CreateScheduleRequest _$CreateScheduleRequestFromJson(
        Map<String, dynamic> json) =>
    CreateScheduleRequest(
      aiPrompt: json['aiPrompt'] as String,
    );

Map<String, dynamic> _$CreateScheduleRequestToJson(
        CreateScheduleRequest instance) =>
    <String, dynamic>{
      'aiPrompt': instance.aiPrompt,
    };

UpdateScheduleRequest _$UpdateScheduleRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateScheduleRequest(
      type: $enumDecodeNullable(_$ScheduleTypeEnumMap, json['type']),
      title: json['title'] as String?,
      description: json['description'] as String?,
      date: json['date'] as String?,
      time: json['time'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
      participants: (json['participants'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      location: json['location'] as String?,
      priority: $enumDecodeNullable(_$PriorityEnumMap, json['priority']),
      category: json['category'] as String?,
    );

Map<String, dynamic> _$UpdateScheduleRequestToJson(
        UpdateScheduleRequest instance) =>
    <String, dynamic>{
      'type': _$ScheduleTypeEnumMap[instance.type],
      'title': instance.title,
      'description': instance.description,
      'date': instance.date,
      'time': instance.time,
      'duration': instance.duration,
      'participants': instance.participants,
      'location': instance.location,
      'priority': _$PriorityEnumMap[instance.priority],
      'category': instance.category,
    };

ScheduleResponse _$ScheduleResponseFromJson(Map<String, dynamic> json) =>
    ScheduleResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      schedule: json['schedule'] == null
          ? null
          : ScheduleModel.fromJson(json['schedule'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ScheduleResponseToJson(ScheduleResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'schedule': instance.schedule,
    };

ScheduleListResponse _$ScheduleListResponseFromJson(
        Map<String, dynamic> json) =>
    ScheduleListResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      schedules: (json['schedules'] as List<dynamic>?)
          ?.map((e) => ScheduleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ScheduleListResponseToJson(
        ScheduleListResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'schedules': instance.schedules,
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
    };
