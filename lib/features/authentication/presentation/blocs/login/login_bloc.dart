import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';

part 'login_event.dart';
part 'login_state.dart';

@Injectable()
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationUseCase authenticationUseCase;

  LoginBloc({
    required this.authenticationUseCase,
  }) : super(const LoginState()) {
    on<OnLogin>(_onLogin);
  }

  Future<void> _onLogin(
      OnLogin event,
      Emitter<LoginState> emit,
      ) async {
    emit(
      const LoginState(
        status: LoginStatus.loading,
      ),
    );

    final result = await authenticationUseCase.login(
      email: event.email,
      password: event.password,
    );

    await result.fold<Future<void>>(
          (failure) async {
        emit(
          LoginState(
            status: LoginStatus.failure,
            message: _failureMessage(failure),
          ),
        );
      },
          (response) async {
        await AuthSessionBox.save(
          token: response.token,
          user: response.user,
        );

        emit(
          LoginState(
            status: LoginStatus.success,
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
      return 'Login failed. Please try again.';
    }

    return message;
  }
}