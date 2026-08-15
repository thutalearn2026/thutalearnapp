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
  final String? message;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.message,
  });

  bool get isLoading => status == ProfileStatus.loading;
}