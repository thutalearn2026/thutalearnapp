import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/profile/profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@Injectable()
class ProfileBloc
    extends Bloc<ProfileEvent, ProfileState> {
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
    if (state.isRefreshing) {
      return;
    }

    final cachedProfile =
    await profileUseCase.getCachedProfile();

    final visibleProfile =
        cachedProfile ?? state.profile;

    emit(
      state.copyWith(
        status: visibleProfile != null
            ? ProfileStatus.success
            : ProfileStatus.loading,
        profile: visibleProfile,
        isRefreshing: true,
        clearMessage: true,
      ),
    );

    final result = await profileUseCase.getProfile();

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            status: visibleProfile != null
                ? ProfileStatus.success
                : ProfileStatus.failure,
            profile: visibleProfile,
            isRefreshing: false,
            message: _failureMessage(failure),
          ),
        );
      },
          (response) {
        // IProfileRepo has already synchronized this
        // response with Hive.
        emit(
          state.copyWith(
            status: ProfileStatus.success,
            profile: response.data,
            isRefreshing: false,
            clearMessage: true,
          ),
        );
      },
    );
  }

  String _failureMessage(Failure failure) {
    if (failure is ConnectionFailure) {
      return state.profile != null
          ? 'You are offline. Showing your saved profile.'
          : 'Please check your internet connection and try again.';
    }

    final message = failure.e?.toString();

    if (message == null || message.trim().isEmpty) {
      return state.profile != null
          ? 'Unable to refresh your profile. Showing saved data.'
          : 'Unable to load your profile.';
    }

    return message;
  }
}