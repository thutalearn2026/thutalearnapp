import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/profile/profile.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

@Injectable()
class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ProfileUseCase profileUseCase;

  ChangePasswordBloc({
    required this.profileUseCase,
  }) : super(const ChangePasswordState()) {
    on<OnChangePassword>(_onChangePassword);
  }

  Future<void> _onChangePassword(
      OnChangePassword event,
      Emitter<ChangePasswordState> emit,
      ) async {
    if (state.isLoading) return;

    emit(
      const ChangePasswordState(
        status: ChangePasswordStatus.loading,
      ),
    );

    final result = await profileUseCase.changePassword(
      currentPassword: event.currentPassword,
      password: event.password,
      passwordConfirmation:
      event.passwordConfirmation,
    );

    result.fold(
          (failure) {
        emit(
          ChangePasswordState(
            status: ChangePasswordStatus.failure,
            message: _failureMessage(failure),
          ),
        );
      },
          (response) {
        emit(
          ChangePasswordState(
            status: ChangePasswordStatus.success,
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
      return 'Unable to change your password.';
    }

    return message;
  }
}