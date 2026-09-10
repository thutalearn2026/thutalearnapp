part of 'change_password_bloc.dart';

@immutable
sealed class ChangePasswordEvent {}

class OnChangePassword extends ChangePasswordEvent {
  final String currentPassword;
  final String password;
  final String passwordConfirmation;

  OnChangePassword({
    required this.currentPassword,
    required this.password,
    required this.passwordConfirmation,
  });
}