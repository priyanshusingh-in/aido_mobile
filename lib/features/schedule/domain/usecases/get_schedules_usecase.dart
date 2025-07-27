import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/schedule.dart';
import '../repositories/schedule_repository.dart';

class GetSchedulesUseCase implements UseCase<List<Schedule>, GetSchedulesParams> {
  final ScheduleRepository repository;

  GetSchedulesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Schedule>>> call(GetSchedulesParams params) async {
    return await repository.getSchedules(
      authToken: params.authToken,
      page: params.page,
      limit: params.limit,
      type: params.type,
      priority: params.priority,
      date: params.date,
    );
  }
}

class GetSchedulesParams extends Equatable {
  final String? authToken;
  final int? page;
  final int? limit;
  final String? type;
  final String? priority;
  final String? date;

  const GetSchedulesParams({
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