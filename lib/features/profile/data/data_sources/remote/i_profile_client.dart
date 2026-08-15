import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/profile/profile.dart';

@Injectable(as: ProfileClient)
class IProfileClient implements ProfileClient {
  final RestClient client;

  IProfileClient({
    required Dio dio,
    required IConfig config,
  }) : client = RestClient(
         dio,
         baseUrl: config.baseUrl,
       );

  @override
  Future<ProfileResponse> getProfile() {
    return client.getProfile();
  }

  @override
  Future<UpdateProfileResponse> updateProfile({
    required String name,
    required String email,
    String? photoPath,
  }) async {
    MultipartFile? photo;

    if (photoPath != null && photoPath.isNotEmpty) {
      photo = await MultipartFile.fromFile(photoPath);
    }

    return client.updateProfile(
      name,
      email,
      photo,
    );
  }

  @override
  Future<ChangePasswordResponse> changePassword(
    ChangePasswordRequest request,
  ) {
    return client.changePassword(request);
  }
}
