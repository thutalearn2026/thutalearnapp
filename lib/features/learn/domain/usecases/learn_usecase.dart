import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

@Injectable()
class LearnUseCase {
  final LearnRepo learnRepo;

  LearnUseCase({
    required this.learnRepo,
  });

  Future<Either<Failure, CoursesResponse>> getCourses({
    int page = 1,
  }) {
    return learnRepo.getCourses(
      page: page,
    );
  }

  Future<Either<Failure, CourseDetailResponse>>
  getCourseDetail({
    required String courseId,
  }) {
    return learnRepo.getCourseDetail(
      courseId: courseId,
    );
  }

  Future<Either<Failure, CourseModulesResponse>>
  getCourseModules({
    required String courseId,
  }) {
    return learnRepo.getCourseModules(
      courseId: courseId,
    );
  }
}