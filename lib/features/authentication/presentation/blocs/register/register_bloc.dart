import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';

part 'register_event.dart';
part 'register_state.dart';

@Injectable()
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthenticationUseCase authenticationUseCase;

  RegisterBloc({
    required this.authenticationUseCase,
  }) : super(const RegisterState()) {
    on<OnInitiateRegistration>(_onInitiateRegistration);
    on<OnVerifyRegistrationCode>(_onVerifyRegistrationCode);
    on<OnCompleteRegistration>(_onCompleteRegistration);
  }

  Future<void> _onInitiateRegistration(
      OnInitiateRegistration event,
      Emitter<RegisterState> emit,
      ) async {
    emit(
      const RegisterState(
        status: RegisterStatus.loading,
        step: RegisterStep.initiate,
      ),
    );

    final result = await authenticationUseCase.initiateRegistration(
      name: event.name,
      email: event.email,
    );

    result.fold(
          (failure) {
        emit(
          RegisterState(
            status: RegisterStatus.failure,
            step: RegisterStep.initiate,
            message: _failureMessage(failure),
          ),
        );
      },
          (response) {
        emit(
          RegisterState(
            status: RegisterStatus.success,
            step: RegisterStep.initiate,
            message: response.message,
          ),
        );
      },
    );
  }

  Future<void> _onVerifyRegistrationCode(
      OnVerifyRegistrationCode event,
      Emitter<RegisterState> emit,
      ) async {
    emit(
      const RegisterState(
        status: RegisterStatus.loading,
        step: RegisterStep.verify,
      ),
    );

    final result = await authenticationUseCase.verifyRegistrationCode(
      email: event.email,
      code: event.code,
    );

    result.fold(
          (failure) {
        emit(
          RegisterState(
            status: RegisterStatus.failure,
            step: RegisterStep.verify,
            message: _failureMessage(failure),
          ),
        );
      },
          (response) {
        emit(
          RegisterState(
            status: RegisterStatus.success,
            step: RegisterStep.verify,
            message: response.message,
          ),
        );
      },
    );
  }

  Future<void> _onCompleteRegistration(
      OnCompleteRegistration event,
      Emitter<RegisterState> emit,
      ) async {
    emit(
      const RegisterState(
        status: RegisterStatus.loading,
        step: RegisterStep.complete,
      ),
    );

    final result = await authenticationUseCase.completeRegistration(
      email: event.email,
      code: event.code,
      password: event.password,
      passwordConfirmation: event.passwordConfirmation,
    );

    await result.fold<Future<void>>(
          (failure) async {
        emit(
          RegisterState(
            status: RegisterStatus.failure,
            step: RegisterStep.complete,
            message: _failureMessage(failure),
          ),
        );
      },
          (response) async {
        await AuthSessionBox.saveSession(response);

        emit(
          RegisterState(
            status: RegisterStatus.success,
            step: RegisterStep.complete,
            message: response.message,
          ),
        );
      },
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