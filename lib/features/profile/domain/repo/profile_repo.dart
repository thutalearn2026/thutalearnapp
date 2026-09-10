import 'package:dartz/dartz.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/profile/data/models/change_password_model.dart';
import 'package:thuta_learn/features/profile/data/models/profile_model.dart';

abstract class ProfileRepo {
  Future<ProfileModel?> getCachedProfile();

  Future<Either<Failure, ProfileResponse>> getProfile();

  Future<Either<Failure, UpdateProfileResponse>>
  updateProfile({
    required String name,
    required String email,
    String? photoPath,
  });

  Future<Either<Failure, ChangePasswordResponse>>
  changePassword(
      ChangePasswordRequest request,
      );
}