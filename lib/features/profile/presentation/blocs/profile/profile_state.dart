part of 'profile_bloc.dart';

enum ProfileStatus {
  initial,
  loading,
  success,
  failure,
}

class ProfileState {
  final ProfileStatus status;
  final ProfileModel? profile;
  final bool isRefreshing;
  final String? message;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.isRefreshing = false,
    this.message,
  });

  bool get isLoading {
    return (status == ProfileStatus.initial ||
        status == ProfileStatus.loading) &&
        profile == null;
  }

  bool get isShowingCachedProfile {
    return profile != null && isRefreshing;
  }

  ProfileState copyWith({
    ProfileStatus? status,
    ProfileModel? profile,
    bool? isRefreshing,
    String? message,
    bool clearMessage = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      isRefreshing:
      isRefreshing ?? this.isRefreshing,
      message:
      clearMessage ? null : message ?? this.message,
    );
  }
}