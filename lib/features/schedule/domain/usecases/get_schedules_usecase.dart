import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/schedule.dart';
import '../repositories/schedule_repository.dart';

class GetSchedulesUseCase
    implements UseCase<List<Schedule>, GetSchedulesParams> {
  final ScheduleRepository repository;

  GetSchedulesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Schedule>>> call(
      GetSchedulesParams params) async {
    return await repository.getSchedules(
      authToken: params.authToken,
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class GetSchedulesParams extends Equatable {
  final String? authToken;
  final int? limit;
  final int? offset;

  const GetSchedulesParams({
    this.authToken,
    this.limit,
    this.offset,
  });

  @override
  List<Object?> get props => [authToken, limit, offset];
}
