import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/schedule.dart';

abstract class ScheduleRepository {
  Future<Either<Failure, Schedule>> createSchedule({
    required String aiPrompt,
    String? authToken,
  });

  Future<Either<Failure, List<Schedule>>> getSchedules({
    String? authToken,
    int? limit,
    int? offset,
  });

  Future<Either<Failure, Schedule>> getSchedule({
    required String id,
    required String authToken,
  });

  Future<Either<Failure, Schedule>> updateSchedule({
    required String id,
    required Schedule schedule,
    required String authToken,
  });

  Future<Either<Failure, void>> deleteSchedule({
    required String id,
    required String authToken,
  });
}
