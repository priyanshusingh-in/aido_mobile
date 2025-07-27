part of 'schedule_bloc.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleCreating extends ScheduleState {}

class ScheduleUpdating extends ScheduleState {}

class ScheduleDeleting extends ScheduleState {}

class SchedulesLoaded extends ScheduleState {
  final List<Schedule> schedules;

  const SchedulesLoaded({required this.schedules});

  @override
  List<Object> get props => [schedules];
}

class ScheduleCreated extends ScheduleState {
  final Schedule schedule;

  const ScheduleCreated({required this.schedule});

  @override
  List<Object> get props => [schedule];
}

class ScheduleUpdated extends ScheduleState {
  final Schedule schedule;

  const ScheduleUpdated({required this.schedule});

  @override
  List<Object> get props => [schedule];
}

class ScheduleDeleted extends ScheduleState {}

class ScheduleError extends ScheduleState {
  final String message;

  const ScheduleError({required this.message});

  @override
  List<Object> get props => [message];
}