part of 'schedule_bloc.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object?> get props => [];
}

class CreateScheduleRequested extends ScheduleEvent {
  final String aiPrompt;
  final String? authToken;

  const CreateScheduleRequested({
    required this.aiPrompt,
    this.authToken,
  });

  @override
  List<Object?> get props => [aiPrompt, authToken];
}

class GetSchedulesRequested extends ScheduleEvent {
  final String? authToken;
  final int? page;
  final int? limit;
  final String? type;
  final String? priority;
  final String? date;

  const GetSchedulesRequested({
    this.authToken,
    this.page,
    this.limit,
    this.type,
    this.priority,
    this.date,
  });

  @override
  List<Object?> get props => [authToken, page, limit, type, priority, date];
}

class UpdateScheduleRequested extends ScheduleEvent {
  final String id;
  final Schedule schedule;
  final String authToken;

  const UpdateScheduleRequested({
    required this.id,
    required this.schedule,
    required this.authToken,
  });

  @override
  List<Object> get props => [id, schedule, authToken];
}

class DeleteScheduleRequested extends ScheduleEvent {
  final String id;
  final String authToken;

  const DeleteScheduleRequested({
    required this.id,
    required this.authToken,
  });

  @override
  List<Object> get props => [id, authToken];
}

class RefreshSchedulesRequested extends ScheduleEvent {
  final String? authToken;

  const RefreshSchedulesRequested({this.authToken});

  @override
  List<Object?> get props => [authToken];
}