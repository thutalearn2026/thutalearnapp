import 'package:dartz/dartz.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

abstract class LearnRepo {
  Future<Either<Failure, CoursesResponse>> getCourses({
    required int page,
  });

  Future<Either<Failure, CourseDetailResponse>>
  getCourseDetail({
    required String courseId,
  });

  Future<Either<Failure, CourseModulesResponse>>
  getCourseModules({
    required String courseId,
  });
}