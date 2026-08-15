import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

@Injectable()
class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthenticationUseCase authenticationUseCase;

  ForgotPasswordBloc({
    required this.authenticationUseCase,
  }) : super(const ForgotPasswordState()) {
    on<OnSendResetCode>(_onSendResetCode);
    on<OnVerifyResetCode>(_onVerifyResetCode);
    on<OnResetPassword>(_onResetPassword);
  }

  Future<void> _onSendResetCode(
      OnSendResetCode event,
      Emitter<ForgotPasswordState> emit,
      ) async {
    emit(
      const ForgotPasswordState(
        status: ForgotPasswordStatus.loading,
        step: ForgotPasswordStep.sendCode,
      ),
    );

    final result = await authenticationUseCase.forgotPassword(
      email: event.email,
    );

    result.fold(
          (failure) => emit(
        ForgotPasswordState(
          status: ForgotPasswordStatus.failure,
          step: ForgotPasswordStep.sendCode,
          message: _failureMessage(failure),
        ),
      ),
          (response) => emit(
        ForgotPasswordState(
          status: ForgotPasswordStatus.success,
          step: ForgotPasswordStep.sendCode,
          message: response.message,
        ),
      ),
    );
  }

  Future<void> _onVerifyResetCode(
      OnVerifyResetCode event,
      Emitter<ForgotPasswordState> emit,
      ) async {
    emit(
      const ForgotPasswordState(
        status: ForgotPasswordStatus.loading,
        step: ForgotPasswordStep.verifyCode,
      ),
    );

    final result =
    await authenticationUseCase.verifyForgotPasswordCode(
      email: event.email,
      code: event.code,
    );

    result.fold(
          (failure) => emit(
        ForgotPasswordState(
          status: ForgotPasswordStatus.failure,
          step: ForgotPasswordStep.verifyCode,
          message: _failureMessage(failure),
        ),
      ),
          (response) => emit(
        ForgotPasswordState(
          status: ForgotPasswordStatus.success,
          step: ForgotPasswordStep.verifyCode,
          message: response.message,
        ),
      ),
    );
  }

  Future<void> _onResetPassword(
      OnResetPassword event,
      Emitter<ForgotPasswordState> emit,
      ) async {
    emit(
      const ForgotPasswordState(
        status: ForgotPasswordStatus.loading,
        step: ForgotPasswordStep.resetPassword,
      ),
    );

    final result = await authenticationUseCase.resetPassword(
      email: event.email,
      code: event.code,
      password: event.password,
      passwordConfirmation: event.passwordConfirmation,
    );

    result.fold(
          (failure) => emit(
        ForgotPasswordState(
          status: ForgotPasswordStatus.failure,
          step: ForgotPasswordStep.resetPassword,
          message: _failureMessage(failure),
        ),
      ),
          (response) => emit(
        ForgotPasswordState(
          status: ForgotPasswordStatus.success,
          step: ForgotPasswordStep.resetPassword,
          message: response.message,
        ),
      ),
    );
  }

  String _failureMessage(Failure failure) {
    if (failure is ConnectionFailure) {
      return 'Please check your internet connection and try again.';
    }

    final message = failure.e?.toString();

    if (message == null || message.isEmpty) {
      return 'Something went wrong. Please try again.';
    }

    return message;
  }
}