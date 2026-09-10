part of 'logout_bloc.dart';

enum LogoutStatus {
  initial,
  loading,
  success,
  failure,
}

class LogoutState {
  final LogoutStatus status;
  final String? message;

  const LogoutState({
    this.status = LogoutStatus.initial,
    this.message,
  });

  bool get isLoading {
    return status == LogoutStatus.loading;
  }
}