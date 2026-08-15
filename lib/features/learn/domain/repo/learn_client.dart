import 'package:thuta_learn/features/learn/learn.dart';

abstract class LearnClient {
  Future<CoursesResponse> getCourses({
    required int page,
  });

  Future<CourseDetailResponse> getCourseDetail({
    required String courseId,
  });

  Future<CourseModulesResponse> getCourseModules({
    required String courseId,
  });
}