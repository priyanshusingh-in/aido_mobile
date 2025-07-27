import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/schedule.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../datasources/schedule_remote_data_source.dart';
import '../datasources/schedule_local_data_source.dart';
import '../models/schedule_models.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;
  final ScheduleLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ScheduleRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Schedule>> createSchedule({
    required String aiPrompt,
    String? authToken,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final request = CreateScheduleRequest(aiPrompt: aiPrompt);
        final response =
            await remoteDataSource.createSchedule(request, authToken);

        if (response.success && response.schedule != null) {
          // Cache the created schedule
          await localDataSource.cacheSchedule(response.schedule!);
          return Right(response.schedule!);
        } else {
          return Left(ServerFailure(message: response.message));
        }
      } on ServerException catch (e) {
        return Left(
            ServerFailure(message: e.message, statusCode: e.statusCode));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(message: e.message, errors: e.errors));
      } catch (e) {
        return const Left(ServerFailure(message: 'Unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Schedule>>> getSchedules({
    String? authToken,
    int? page,
    int? limit,
    String? type,
    String? priority,
    String? date,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getSchedules(
          authToken: authToken,
          page: page,
          limit: limit,
          type: type,
          priority: priority,
          date: date,
        );

        if (response.success && response.schedules != null) {
          // Cache the schedules
          await localDataSource.cacheSchedules(response.schedules!);
          return Right(response.schedules!);
        } else {
          return Left(ServerFailure(message: response.message));
        }
      } on ServerException catch (e) {
        // If server fails, try to get cached schedules
        try {
          final cachedSchedules = await localDataSource.getCachedSchedules();
          if (cachedSchedules.isNotEmpty) {
            return Right(cachedSchedules);
          }
        } catch (_) {}

        return Left(
            ServerFailure(message: e.message, statusCode: e.statusCode));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error occurred'));
      }
    } else {
      // No internet, get cached schedules
      try {
        final cachedSchedules = await localDataSource.getCachedSchedules();
        return Right(cachedSchedules);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, Schedule>> getSchedule({
    required String id,
    required String authToken,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getSchedule(id, authToken);

        if (response.success && response.schedule != null) {
          await localDataSource.cacheSchedule(response.schedule!);
          return Right(response.schedule!);
        } else {
          return Left(ServerFailure(message: response.message));
        }
      } on ServerException catch (e) {
        // Try to get cached schedule
        final cachedSchedule = await localDataSource.getCachedSchedule(id);
        if (cachedSchedule != null) {
          return Right(cachedSchedule);
        }

        return Left(
            ServerFailure(message: e.message, statusCode: e.statusCode));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error occurred'));
      }
    } else {
      // No internet, get cached schedule
      try {
        final cachedSchedule = await localDataSource.getCachedSchedule(id);
        if (cachedSchedule != null) {
          return Right(cachedSchedule);
        } else {
          return const Left(
              CacheFailure(message: 'Schedule not found in cache'));
        }
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, Schedule>> updateSchedule({
    required String id,
    required Schedule schedule,
    required String authToken,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final request = UpdateScheduleRequest.fromSchedule(schedule);
        final response =
            await remoteDataSource.updateSchedule(id, request, authToken);

        if (response.success && response.schedule != null) {
          await localDataSource.cacheSchedule(response.schedule!);
          return Right(response.schedule!);
        } else {
          return Left(ServerFailure(message: response.message));
        }
      } on ServerException catch (e) {
        return Left(
            ServerFailure(message: e.message, statusCode: e.statusCode));
      } on ValidationException catch (e) {
        return Left(ValidationFailure(message: e.message, errors: e.errors));
      } catch (e) {
        return const Left(ServerFailure(message: 'Unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSchedule({
    required String id,
    required String authToken,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteSchedule(id, authToken);
        await localDataSource.removeCachedSchedule(id);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(
            ServerFailure(message: e.message, statusCode: e.statusCode));
      } catch (e) {
        return const Left(ServerFailure(message: 'Unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
