part of 'register_bloc.dart';

enum RegisterStatus {
  initial,
  loading,
  success,
  failure,
}

enum RegisterStep {
  initiate,
  verify,
  complete,
}

class RegisterState {
  final RegisterStatus status;
  final RegisterStep? step;
  final String? message;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.step,
    this.message,
  });

  bool get isLoading => status == RegisterStatus.loading;
}