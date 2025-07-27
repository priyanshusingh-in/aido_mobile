import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required super.message,
    this.statusCode,
  });

  @override
  List<Object> get props => [message, statusCode ?? 0];
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class ValidationFailure extends Failure {
  final Map<String, String>? errors;

  const ValidationFailure({
    required super.message,
    this.errors,
  });

  @override
  List<Object> get props => [message, errors ?? {}];
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({required super.message});
}

class AuthorizationFailure extends Failure {
  const AuthorizationFailure({required super.message});
}
