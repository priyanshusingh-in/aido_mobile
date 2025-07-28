import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/schedule.dart';
import '../../domain/usecases/create_schedule_usecase.dart';
import '../../domain/usecases/get_schedules_usecase.dart';
import '../../domain/usecases/update_schedule_usecase.dart';
import '../../domain/usecases/delete_schedule_usecase.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final CreateScheduleUseCase createScheduleUseCase;
  final GetSchedulesUseCase getSchedulesUseCase;
  final UpdateScheduleUseCase updateScheduleUseCase;
  final DeleteScheduleUseCase deleteScheduleUseCase;

  ScheduleBloc({
    required this.createScheduleUseCase,
    required this.getSchedulesUseCase,
    required this.updateScheduleUseCase,
    required this.deleteScheduleUseCase,
  }) : super(ScheduleInitial()) {
    on<CreateScheduleRequested>(_onCreateScheduleRequested);
    on<GetSchedulesRequested>(_onGetSchedulesRequested);
    on<UpdateScheduleRequested>(_onUpdateScheduleRequested);
    on<DeleteScheduleRequested>(_onDeleteScheduleRequested);
    on<RefreshSchedulesRequested>(_onRefreshSchedulesRequested);
  }

  Future<void> _onCreateScheduleRequested(
    CreateScheduleRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleCreating());

    final result = await createScheduleUseCase(
      CreateScheduleParams(
        aiPrompt: event.aiPrompt,
        authToken: event.authToken,
      ),
    );

    result.fold(
      (failure) => emit(ScheduleError(message: failure.message)),
      (schedule) {
        emit(ScheduleCreated(schedule: schedule));
        // Refresh schedules after creating
        add(GetSchedulesRequested(authToken: event.authToken));
      },
    );
  }

  Future<void> _onGetSchedulesRequested(
    GetSchedulesRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    if (state is! SchedulesLoaded) {
      emit(ScheduleLoading());
    }

    final result = await getSchedulesUseCase(
      GetSchedulesParams(
        authToken: event.authToken,
        limit: event.limit,
        offset: event.offset,
      ),
    );

    result.fold(
      (failure) => emit(ScheduleError(message: failure.message)),
      (schedules) => emit(SchedulesLoaded(schedules: schedules)),
    );
  }

  Future<void> _onUpdateScheduleRequested(
    UpdateScheduleRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleUpdating());

    final result = await updateScheduleUseCase(
      UpdateScheduleParams(
        id: event.id,
        schedule: event.schedule,
        authToken: event.authToken,
      ),
    );

    result.fold(
      (failure) => emit(ScheduleError(message: failure.message)),
      (schedule) {
        emit(ScheduleUpdated(schedule: schedule));
        // Refresh schedules after updating
        add(GetSchedulesRequested(authToken: event.authToken));
      },
    );
  }

  Future<void> _onDeleteScheduleRequested(
    DeleteScheduleRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleDeleting());

    final result = await deleteScheduleUseCase(
      DeleteScheduleParams(
        id: event.id,
        authToken: event.authToken,
      ),
    );

    result.fold(
      (failure) => emit(ScheduleError(message: failure.message)),
      (_) {
        emit(ScheduleDeleted());
        // Refresh schedules after deleting
        add(GetSchedulesRequested(authToken: event.authToken));
      },
    );
  }

  Future<void> _onRefreshSchedulesRequested(
    RefreshSchedulesRequested event,
    Emitter<ScheduleState> emit,
  ) async {
    add(GetSchedulesRequested(authToken: event.authToken));
  }
}
