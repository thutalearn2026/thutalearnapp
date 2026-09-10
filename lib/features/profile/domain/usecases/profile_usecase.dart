import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/profile/profile.dart';

@Injectable()
class ProfileUseCase {
  final ProfileRepo profileRepo;

  ProfileUseCase({
    required this.profileRepo,
  });

  Future<Either<Failure, ProfileResponse>> getProfile() {
    return profileRepo.getProfile();
  }

  Future<Either<Failure, UpdateProfileResponse>> updateProfile({
    required String name,
    required String email,
    String? photoPath,
  }) {
    return profileRepo.updateProfile(
      name: name,
      email: email,
      photoPath: photoPath,
    );
  }

  Future<Either<Failure, ChangePasswordResponse>> changePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) {
    return profileRepo.changePassword(
      ChangePasswordRequest(
        currentPassword: currentPassword,
        password: password,
        passwordConfirmation: passwordConfirmation,
      ),
    );
  }

  Future<ProfileModel?> getCachedProfile() {
    return profileRepo.getCachedProfile();
  }
}
