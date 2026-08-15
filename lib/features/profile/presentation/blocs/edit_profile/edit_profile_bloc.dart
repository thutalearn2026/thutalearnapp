import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/profile/profile.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

@Injectable()
class EditProfileBloc
    extends Bloc<EditProfileEvent, EditProfileState> {
  final ProfileUseCase profileUseCase;

  EditProfileBloc({
    required this.profileUseCase,
  }) : super(const EditProfileState()) {
    on<OnUpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onUpdateProfile(
      OnUpdateProfile event,
      Emitter<EditProfileState> emit,
      ) async {
    emit(
      const EditProfileState(
        status: EditProfileStatus.loading,
      ),
    );

    final result = await profileUseCase.updateProfile(
      name: event.name,
      email: event.email,
      photoPath: event.photoPath,
    );

    result.fold(
          (failure) {
        emit(
          EditProfileState(
            status: EditProfileStatus.failure,
            message: _failureMessage(failure),
          ),
        );
      },
          (response) {
        emit(
          EditProfileState(
            status: EditProfileStatus.success,
            updatedProfile: response.data,
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
      return 'Unable to update your profile.';
    }

    return message;
  }
}