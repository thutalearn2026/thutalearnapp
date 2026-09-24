import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/data/data_sources/box/auth_session_box.dart';
import 'package:thuta_learn/features/profile/profile.dart';

@Injectable(as: ProfileRepo)
class IProfileRepo implements ProfileRepo {
  final ProfileClient client;

  IProfileRepo({
    required this.client,
  });

  @override
  Future<ProfileModel?> getCachedProfile() {
    return ProfileCacheBox.read();
  }

  @override
  Future<Either<Failure, ProfileResponse>> getProfile() async {
    try {
      final response = await client.getProfile();

      await ProfileCacheBox.save(
        response.data,
      );

      return Right(response);
    } on DioException catch (error) {
      if (checkConnectionFailure(error)) {
        return Left(ConnectionFailure());
      }

      return Left(
        ServerFailure(
          e: getApiErrorMessage(error),
        ),
      );
    } catch (error) {
      return Left(
        ServerFailure(
          e: error.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, UpdateProfileResponse>> updateProfile({
    required String name,
    required String email,
    required String phoneNumber,
    String? photoPath,
  }) async {
    try {
      final response = await client.updateProfile(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        photoPath: photoPath,
      );

      // Keep the offline Profile cache synchronized.
      await ProfileCacheBox.save(
        response.data,
      );

      // Keep authenticated user data synchronized.
      // This ensures the updated name is also reflected
      // in "Sawatdee, [user name]" on the Home page.
      await AuthSessionBox.updateUserData(
        response.data.toJson(),
      );

      return Right(response);
    } on DioException catch (error) {
      if (checkConnectionFailure(error)) {
        return Left(ConnectionFailure());
      }

      return Left(
        ServerFailure(
          e: getApiErrorMessage(error),
        ),
      );
    } catch (error) {
      return Left(
        ServerFailure(
          e: error.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ChangePasswordResponse>> changePassword(
    ChangePasswordRequest request,
  ) async {
    try {
      final response = await client.changePassword(
        request,
      );

      return Right(response);
    } on DioException catch (error) {
      if (checkConnectionFailure(error)) {
        return Left(ConnectionFailure());
      }

      return Left(
        ServerFailure(
          e: getApiErrorMessage(error),
        ),
      );
    } catch (error) {
      return Left(
        ServerFailure(
          e: error.toString(),
        ),
      );
    }
  }
}
