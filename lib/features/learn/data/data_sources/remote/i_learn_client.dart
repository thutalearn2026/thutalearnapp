import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

@Injectable(as: LearnClient)
class ILearnClient implements LearnClient {
  final RestClient client;

  ILearnClient({
    required Dio dio,
    required IConfig config,
  }) : client = RestClient(
    dio,
    baseUrl: config.baseUrl,
  );

  @override
  Future<CoursesResponse> getCourses({
    required int page,
  }) {
    return client.getCourses(page);
  }

  @override
  Future<CourseDetailResponse> getCourseDetail({
    required String courseId,
  }) {
    return client.getCourseDetail(courseId);
  }

  @override
  Future<CourseModulesResponse> getCourseModules({
    required String courseId,
  }) {
    return client.getCourseModules(courseId);
  }
}