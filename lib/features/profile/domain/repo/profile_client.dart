import 'package:thuta_learn/features/profile/data/models/change_password_model.dart';
import 'package:thuta_learn/features/profile/data/models/profile_model.dart';

abstract class ProfileClient {
  Future<ProfileResponse> getProfile();

  Future<UpdateProfileResponse> updateProfile({
    required String name,
    required String email,
    String? photoPath,
  });

  Future<ChangePasswordResponse> changePassword(
    ChangePasswordRequest request,
  );
}
