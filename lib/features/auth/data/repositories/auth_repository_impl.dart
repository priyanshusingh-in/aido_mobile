import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_local_data_source.dart';
import '../models/auth_models.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final request = LoginRequest(email: email, password: password);
        final response = await remoteDataSource.login(request);

        if (response.success &&
            response.data?.token != null &&
            response.data?.user != null) {
          await localDataSource.saveAuthToken(response.data!.token!);
          await localDataSource.saveUser(response.data!.user!);
          return Right(response.data!.user!);
        } else {
          return Left(
              AuthenticationFailure(message: response.error ?? 'Login failed'));
        }
      } on ServerException catch (e) {
        return Left(
            ServerFailure(message: e.message, statusCode: e.statusCode));
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(message: e.message));
      } catch (e) {
        return const Left(ServerFailure(message: 'Unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final request = RegisterRequest(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
        );
        final response = await remoteDataSource.register(request);

        if (response.success &&
            response.data?.token != null &&
            response.data?.user != null) {
          await localDataSource.saveAuthToken(response.data!.token!);
          await localDataSource.saveUser(response.data!.user!);
          return Right(response.data!.user!);
        } else {
          return Left(AuthenticationFailure(
              message: response.error ?? 'Registration failed'));
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
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearAuthData();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, User>> getUserProfile() async {
    try {
      final token = await localDataSource.getAuthToken();
      if (token == null) {
        return const Left(
            AuthenticationFailure(message: 'No auth token found'));
      }

      if (await networkInfo.isConnected) {
        try {
          final response = await remoteDataSource.getUserProfile(token);
          if (response.success && response.data != null) {
            await localDataSource.saveUser(response.data!);
            return Right(response.data!);
          } else {
            return Left(ServerFailure(
                message: response.error ?? 'Failed to get user profile'));
          }
        } on ServerException catch (e) {
          // If server fails, try to get cached user
          final cachedUser = await localDataSource.getUser();
          if (cachedUser != null) {
            return Right(cachedUser);
          }
          return Left(
              ServerFailure(message: e.message, statusCode: e.statusCode));
        }
      } else {
        // No internet, get cached user
        final cachedUser = await localDataSource.getUser();
        if (cachedUser != null) {
          return Right(cachedUser);
        }
        return const Left(NetworkFailure(
            message: 'No internet connection and no cached user'));
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final isLoggedIn = await localDataSource.isLoggedIn();
      return Right(isLoggedIn);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, String?>> getAuthToken() async {
    try {
      final token = await localDataSource.getAuthToken();
      return Right(token);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
