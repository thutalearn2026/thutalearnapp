part of 'module_detail_bloc.dart';

enum ModuleDetailStatus {
  initial,
  loading,
  success,
  failure,
}

class ModuleDetailState {
  final ModuleDetailStatus status;
  final CourseModuleModel? module;
  final List<ChapterModel> chapters;

  final Map<String, List<ChapterVideoModel>> videosByChapter;

  final Set<String> loadingChapterIds;

  final Map<String, String> chapterVideoErrors;

  final Map<String, List<ChapterResourceModel>> resourcesByChapter;

  final Set<String> loadingResourceChapterIds;

  final Map<String, String> chapterResourceErrors;

  final String? message;

  const ModuleDetailState({
    this.status = ModuleDetailStatus.initial,
    this.module,
    this.chapters = const [],
    this.videosByChapter = const {},
    this.loadingChapterIds = const {},
    this.chapterVideoErrors = const {},
    this.resourcesByChapter = const {},
    this.loadingResourceChapterIds = const {},
    this.chapterResourceErrors = const {},
    this.message,
  });

  bool get isLoading {
    return status == ModuleDetailStatus.loading;
  }

  int get totalVideoCount {
    return chapters.fold<int>(
      0,
      (total, chapter) {
        return total + chapter.videosCount;
      },
    );
  }

  ModuleDetailState copyWith({
    ModuleDetailStatus? status,
    CourseModuleModel? module,
    List<ChapterModel>? chapters,
    Map<String, List<ChapterVideoModel>>? videosByChapter,
    Set<String>? loadingChapterIds,
    Map<String, String>? chapterVideoErrors,
    Map<String, List<ChapterResourceModel>>? resourcesByChapter,
    Set<String>? loadingResourceChapterIds,
    Map<String, String>? chapterResourceErrors,
    String? message,
    bool clearMessage = false,
  }) {
    return ModuleDetailState(
      status: status ?? this.status,
      module: module ?? this.module,
      chapters: chapters ?? this.chapters,
      videosByChapter: videosByChapter ?? this.videosByChapter,
      loadingChapterIds: loadingChapterIds ?? this.loadingChapterIds,
      chapterVideoErrors: chapterVideoErrors ?? this.chapterVideoErrors,
      resourcesByChapter: resourcesByChapter ?? this.resourcesByChapter,
      loadingResourceChapterIds: loadingResourceChapterIds ?? this.loadingResourceChapterIds,
      chapterResourceErrors: chapterResourceErrors ?? this.chapterResourceErrors,
      message: clearMessage ? null : message ?? this.message,
    );
  }
}
