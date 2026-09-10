part of 'edit_profile_bloc.dart';

enum EditProfileStatus {
  initial,
  loading,
  success,
  failure,
}

class EditProfileState {
  final EditProfileStatus status;
  final ProfileModel? updatedProfile;
  final String? message;

  const EditProfileState({
    this.status = EditProfileStatus.initial,
    this.updatedProfile,
    this.message,
  });

  bool get isLoading => status == EditProfileStatus.loading;
}