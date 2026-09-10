part of 'change_password_bloc.dart';

enum ChangePasswordStatus {
  initial,
  loading,
  success,
  failure,
}

class ChangePasswordState {
  final ChangePasswordStatus status;
  final String? message;

  const ChangePasswordState({
    this.status = ChangePasswordStatus.initial,
    this.message,
  });

  bool get isLoading {
    return status == ChangePasswordStatus.loading;
  }
}