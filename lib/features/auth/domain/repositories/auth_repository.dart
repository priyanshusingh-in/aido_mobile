import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, User>> getUserProfile();

  Future<Either<Failure, bool>> isLoggedIn();

  Future<Either<Failure, String?>> getAuthToken();
}