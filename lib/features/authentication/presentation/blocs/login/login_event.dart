part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class OnLogin extends LoginEvent {
  final String email;
  final String password;

  OnLogin({
    required this.email,
    required this.password,
  });
}