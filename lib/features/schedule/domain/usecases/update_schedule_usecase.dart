import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/schedule.dart';
import '../repositories/schedule_repository.dart';

class UpdateScheduleUseCase implements UseCase<Schedule, UpdateScheduleParams> {
  final ScheduleRepository repository;

  UpdateScheduleUseCase(this.repository);

  @override
  Future<Either<Failure, Schedule>> call(UpdateScheduleParams params) async {
    return await repository.updateSchedule(
      id: params.id,
      schedule: params.schedule,
      authToken: params.authToken,
    );
  }
}

class UpdateScheduleParams extends Equatable {
  final String id;
  final Schedule schedule;
  final String authToken;

  const UpdateScheduleParams({
    required this.id,
    required this.schedule,
    required this.authToken,
  });

  @override
  List<Object> get props => [id, schedule, authToken];
}