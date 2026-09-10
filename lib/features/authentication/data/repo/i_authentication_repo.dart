import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';

@Injectable(as: AuthenticationRepo)
class IAuthenticationRepo implements AuthenticationRepo {
  final AuthenticationClient client;

  IAuthenticationRepo({
    required this.client,
  });

  Future<Either<Failure, T>> _safeRequest<T>(
    Future<T> Function() request,
  ) async {
    try {
      final response = await request();
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
  Future<Either<Failure, ApiMessageResponse>> initiateRegistration(
    RegisterInitiateRequest request,
  ) {
    return _safeRequest(
      () => client.initiateRegistration(request),
    );
  }

  @override
  Future<Either<Failure, ApiMessageResponse>> verifyRegistrationCode(
    RegisterVerifyRequest request,
  ) {
    return _safeRequest(
      () => client.verifyRegistrationCode(request),
    );
  }

  @override
  Future<Either<Failure, RegisterCompleteResponse>> completeRegistration(
    RegisterCompleteRequest request,
  ) {
    return _safeRequest(
      () => client.completeRegistration(request),
    );
  }

  @override
  Future<Either<Failure, LoginResponse>> login(
    LoginRequest request,
  ) {
    return _safeRequest(
      () => client.login(request),
    );
  }

  @override
  Future<Either<Failure, ApiMessageResponse>> forgotPassword(
    ForgotPasswordRequest request,
  ) {
    return _safeRequest(
      () => client.forgotPassword(request),
    );
  }

  @override
  Future<Either<Failure, ApiMessageResponse>> verifyForgotPasswordCode(
    ForgotPasswordVerifyRequest request,
  ) {
    return _safeRequest(
      () => client.verifyForgotPasswordCode(request),
    );
  }

  @override
  Future<Either<Failure, ApiMessageResponse>> resetPassword(
    ResetPasswordRequest request,
  ) {
    return _safeRequest(
      () => client.resetPassword(request),
    );
  }

  @override
  Future<Either<Failure, OnboardingOptionsResponse>> getOnboardingOptions() {
    return _safeRequest(
      () => client.getOnboardingOptions(),
    );
  }

  @override
  Future<Either<Failure, OnboardingPreferenceResponse>> saveOnboardingPreferences(
    OnboardingPreferenceRequest request,
  ) {
    return _safeRequest(
      () => client.saveOnboardingPreferences(request),
    );
  }

  @override
  Future<Either<Failure, ApiMessageResponse>> logout() {
    return _safeRequest(
      () => client.logout(),
    );
  }
}
