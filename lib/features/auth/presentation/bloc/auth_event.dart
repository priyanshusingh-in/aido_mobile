part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStatusChecked extends AuthEvent {}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  const LoginSubmitted({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class RegisterSubmitted extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  const RegisterSubmitted({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object> get props => [email, password, firstName, lastName];
}

class LogoutRequested extends AuthEvent {}

class UserProfileRequested extends AuthEvent {}