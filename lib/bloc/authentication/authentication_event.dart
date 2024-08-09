part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LoginEvent extends AuthenticationEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class RegisterEvent extends AuthenticationEvent {
  final String name;
  final String email;
  final String password;

  const RegisterEvent({required this.name, required this.email, required this.password});

  @override
  List<Object> get props => [name, email, password];
}

class LogoutEvent extends AuthenticationEvent {}
