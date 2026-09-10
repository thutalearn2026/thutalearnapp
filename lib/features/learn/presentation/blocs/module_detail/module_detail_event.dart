part of 'module_detail_bloc.dart';

@immutable
sealed class ModuleDetailEvent {}

class OnGetModuleDetail extends ModuleDetailEvent {
  final String courseId;
  final String moduleId;

  OnGetModuleDetail({
    required this.courseId,
    required this.moduleId,
  });
}

class OnGetChapterVideos extends ModuleDetailEvent {
  final String chapterId;

  OnGetChapterVideos({
    required this.chapterId,
  });
}

class OnGetChapterResources
    extends ModuleDetailEvent {
  final String chapterId;

  OnGetChapterResources({
    required this.chapterId,
  });
}

class OnGetChapterQuizzes
    extends ModuleDetailEvent {
  final String chapterId;

  OnGetChapterQuizzes({
    required this.chapterId,
  });
}