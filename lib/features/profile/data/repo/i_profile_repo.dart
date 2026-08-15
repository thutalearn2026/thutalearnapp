import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/profile/profile.dart';

@Injectable(as: ProfileRepo)
class IProfileRepo implements ProfileRepo {
  final ProfileClient client;

  IProfileRepo({
    required this.client,
  });

  @override
  Future<Either<Failure, ProfileResponse>> getProfile() async {
    try {
      final response = await client.getProfile();
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
    String? photoPath,
  }) async {
    try {
      final response = await client.updateProfile(
        name: name,
        email: email,
        photoPath: photoPath,
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
