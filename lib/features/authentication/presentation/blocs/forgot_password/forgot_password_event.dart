part of 'forgot_password_bloc.dart';

@immutable
sealed class ForgotPasswordEvent {}

class OnSendResetCode extends ForgotPasswordEvent {
  final String email;

  OnSendResetCode({
    required this.email,
  });
}

class OnVerifyResetCode extends ForgotPasswordEvent {
  final String email;
  final String code;

  OnVerifyResetCode({
    required this.email,
    required this.code,
  });
}

class OnResetPassword extends ForgotPasswordEvent {
  final String email;
  final String code;
  final String password;
  final String passwordConfirmation;

  OnResetPassword({
    required this.email,
    required this.code,
    required this.password,
    required this.passwordConfirmation,
  });
}