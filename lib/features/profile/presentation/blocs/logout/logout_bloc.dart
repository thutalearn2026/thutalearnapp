import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';

part 'logout_event.dart';
part 'logout_state.dart';

@Injectable()
class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AuthenticationUseCase authenticationUseCase;

  LogoutBloc({
    required this.authenticationUseCase,
  }) : super(const LogoutState()) {
    on<OnLogout>(_onLogout);
  }

  Future<void> _onLogout(
      OnLogout event,
      Emitter<LogoutState> emit,
      ) async {
    if (state.isLoading) return;

    emit(
      const LogoutState(
        status: LogoutStatus.loading,
      ),
    );

    final result = await authenticationUseCase.logout();

    await result.fold<Future<void>>(
          (failure) async {
        emit(
          LogoutState(
            status: LogoutStatus.failure,
            message: _failureMessage(failure),
          ),
        );
      },
          (response) async {
        // Clear local authentication only after the
        // server successfully revokes the token.
        await AuthSessionBox.clearSession();

        emit(
          LogoutState(
            status: LogoutStatus.success,
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
      return 'Unable to logout. Please try again.';
    }

    return message;
  }
}