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

  Future<Either<Failure, CourseDetailResponse>> getCourseDetail({
    required String courseId,
  }) {
    return learnRepo.getCourseDetail(
      courseId: courseId,
    );
  }

  Future<Either<Failure, CourseModulesResponse>> getCourseModules({
    required String courseId,
  }) {
    return learnRepo.getCourseModules(
      courseId: courseId,
    );
  }

  Future<Either<Failure, ModuleDetailResponse>> getModuleDetail({
    required String courseId,
    required String moduleId,
  }) {
    return learnRepo.getModuleDetail(
      courseId: courseId,
      moduleId: moduleId,
    );
  }

  Future<Either<Failure, ChapterListResponse>> getModuleChapters({
    required String moduleId,
  }) {
    return learnRepo.getModuleChapters(
      moduleId: moduleId,
    );
  }

  Future<Either<Failure, ChapterDetailResponse>> getChapterDetail({
    required String moduleId,
    required String chapterId,
  }) {
    return learnRepo.getChapterDetail(
      moduleId: moduleId,
      chapterId: chapterId,
    );
  }

  Future<Either<Failure, ChapterVideosResponse>> getChapterVideos({
    required String chapterId,
  }) {
    return learnRepo.getChapterVideos(
      chapterId: chapterId,
    );
  }

  Future<Either<Failure, ChapterVideoDetailResponse>> getChapterVideoDetail({
    required String chapterId,
    required String videoId,
  }) {
    return learnRepo.getChapterVideoDetail(
      chapterId: chapterId,
      videoId: videoId,
    );
  }

  Future<Either<Failure, ChapterResourcesResponse>> getChapterResources({
    required String chapterId,
  }) {
    return learnRepo.getChapterResources(
      chapterId: chapterId,
    );
  }

  Future<Either<Failure, ChapterResourceDetailResponse>> getChapterResourceDetail({
    required String chapterId,
    required String resourceId,
  }) {
    return learnRepo.getChapterResourceDetail(
      chapterId: chapterId,
      resourceId: resourceId,
    );
  }
}
