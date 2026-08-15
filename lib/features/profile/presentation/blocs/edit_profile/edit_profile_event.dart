part of 'edit_profile_bloc.dart';

@immutable
sealed class EditProfileEvent {}

class OnUpdateProfile extends EditProfileEvent {
  final String name;
  final String email;
  final String? photoPath;

  OnUpdateProfile({
    required this.name,
    required this.email,
    this.photoPath,
  });
}