part of 'login_bloc.dart';

enum LoginStatus {
  initial,
  loading,
  success,
  failure,
}

class LoginState {
  final LoginStatus status;
  final String? message;

  const LoginState({
    this.status = LoginStatus.initial,
    this.message,
  });

  bool get isLoading => status == LoginStatus.loading;
}