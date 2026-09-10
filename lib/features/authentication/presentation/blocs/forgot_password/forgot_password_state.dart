part of 'forgot_password_bloc.dart';

enum ForgotPasswordStatus {
  initial,
  loading,
  success,
  failure,
}

enum ForgotPasswordStep {
  sendCode,
  verifyCode,
  resetPassword,
}

class ForgotPasswordState {
  final ForgotPasswordStatus status;
  final ForgotPasswordStep? step;
  final String? message;

  const ForgotPasswordState({
    this.status = ForgotPasswordStatus.initial,
    this.step,
    this.message,
  });

  bool get isLoading => status == ForgotPasswordStatus.loading;
}