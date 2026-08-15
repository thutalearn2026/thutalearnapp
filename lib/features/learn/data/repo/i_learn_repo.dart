import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

@Injectable(as: LearnRepo)
class ILearnRepo implements LearnRepo {
  final LearnClient client;

  ILearnRepo({
    required this.client,
  });

  @override
  Future<Either<Failure, CoursesResponse>> getCourses({
    required int page,
  }) {
    return _request(
          () => client.getCourses(
        page: page,
      ),
    );
  }

  @override
  Future<Either<Failure, CourseDetailResponse>>
  getCourseDetail({
    required String courseId,
  }) {
    return _request(
          () => client.getCourseDetail(
        courseId: courseId,
      ),
    );
  }

  @override
  Future<Either<Failure, CourseModulesResponse>>
  getCourseModules({
    required String courseId,
  }) {
    return _request(
          () => client.getCourseModules(
        courseId: courseId,
      ),
    );
  }

  Future<Either<Failure, T>> _request<T>(
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
}