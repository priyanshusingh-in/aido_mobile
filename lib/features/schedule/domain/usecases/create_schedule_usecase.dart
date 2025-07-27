import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/schedule.dart';
import '../repositories/schedule_repository.dart';

class CreateScheduleUseCase implements UseCase<Schedule, CreateScheduleParams> {
  final ScheduleRepository repository;

  CreateScheduleUseCase(this.repository);

  @override
  Future<Either<Failure, Schedule>> call(CreateScheduleParams params) async {
    return await repository.createSchedule(
      aiPrompt: params.aiPrompt,
      authToken: params.authToken,
    );
  }
}

class CreateScheduleParams extends Equatable {
  final String aiPrompt;
  final String? authToken;

  const CreateScheduleParams({
    required this.aiPrompt,
    this.authToken,
  });

  @override
  List<Object?> get props => [aiPrompt, authToken];
}