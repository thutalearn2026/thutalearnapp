import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/profile/profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@Injectable()
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileUseCase profileUseCase;

  ProfileBloc({
    required this.profileUseCase,
  }) : super(const ProfileState()) {
    on<OnGetProfile>(_onGetProfile);
  }

  Future<void> _onGetProfile(
      OnGetProfile event,
      Emitter<ProfileState> emit,
      ) async {
    emit(
      ProfileState(
        status: ProfileStatus.loading,
        profile: state.profile,
      ),
    );

    final result = await profileUseCase.getProfile();

    result.fold(
          (failure) {
        emit(
          ProfileState(
            status: ProfileStatus.failure,
            profile: state.profile,
            message: _failureMessage(failure),
          ),
        );
      },
          (response) {
        emit(
          ProfileState(
            status: ProfileStatus.success,
            profile: response.data,
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
      return 'Unable to load your profile.';
    }

    return message;
  }
}