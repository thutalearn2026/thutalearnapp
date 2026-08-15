part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

class OnInitiateRegistration extends RegisterEvent {
  final String name;
  final String email;

  OnInitiateRegistration({
    required this.name,
    required this.email,
  });
}

class OnVerifyRegistrationCode extends RegisterEvent {
  final String email;
  final String code;

  OnVerifyRegistrationCode({
    required this.email,
    required this.code,
  });
}

class OnCompleteRegistration extends RegisterEvent {
  final String email;
  final String code;
  final String password;
  final String passwordConfirmation;

  OnCompleteRegistration({
    required this.email,
    required this.code,
    required this.password,
    required this.passwordConfirmation,
  });
}