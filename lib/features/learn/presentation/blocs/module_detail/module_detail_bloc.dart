import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

part 'module_detail_event.dart';
part 'module_detail_state.dart';

@Injectable()
class ModuleDetailBloc extends Bloc<ModuleDetailEvent, ModuleDetailState> {
  final LearnUseCase learnUseCase;

  ModuleDetailBloc({
    required this.learnUseCase,
  }) : super(const ModuleDetailState()) {
    on<OnGetModuleDetail>(_onGetModuleDetail);
    on<OnGetChapterVideos>(_onGetChapterVideos);
    on<OnGetChapterResources>(_onGetChapterResources);
    on<OnGetChapterQuizzes>(_onGetChapterQuizzes);
  }

  Future<void> _onGetModuleDetail(
    OnGetModuleDetail event,
    Emitter<ModuleDetailState> emit,
  ) async {
    if (state.isRefreshing) {
      return;
    }

    final cachedSnapshot = await learnUseCase.getCachedModuleLessons(
      moduleId: event.moduleId,
    );

    final visibleModule = cachedSnapshot?.module ?? state.module;

    final visibleChapters = cachedSnapshot?.chapters ?? state.chapters;

    final visibleVideos = cachedSnapshot?.videosByChapter ?? state.videosByChapter;

    final hasCachedData = visibleModule != null;

    emit(
      state.copyWith(
        status: hasCachedData ? ModuleDetailStatus.success : ModuleDetailStatus.loading,
        module: visibleModule,
        chapters: visibleChapters,
        videosByChapter: visibleVideos,
        isRefreshing: true,
        loadingChapterIds: const {},
        refreshingVideoChapterIds: const {},
        refreshedVideoChapterIds: const {},
        chapterVideoErrors: const {},
        clearMessage: true,
      ),
    );

    // Cached videos are already visible. This request
    // refreshes the first available chapter in the
    // background.
    _queueFirstVideoChapter(visibleChapters);

    final moduleFuture = learnUseCase.getModuleDetail(
      courseId: event.courseId,
      moduleId: event.moduleId,
    );

    final chaptersFuture = learnUseCase.getModuleChapters(
      moduleId: event.moduleId,
    );

    final moduleResult = await moduleFuture;
    final chaptersResult = await chaptersFuture;

    Failure? requestFailure;
    CourseModuleModel? remoteModule;
    List<ChapterModel>? remoteChapters;

    moduleResult.fold(
      (failure) {
        requestFailure = failure;
      },
      (response) {
        remoteModule = response.data;
      },
    );

    chaptersResult.fold(
      (failure) {
        requestFailure ??= failure;
      },
      (response) {
        remoteChapters = [...response.data]
          ..sort(
            (first, second) {
              return first.rank.compareTo(second.rank);
            },
          );
      },
    );

    if (requestFailure != null || remoteModule == null || remoteChapters == null) {
      if (hasCachedData) {
        // Silently retain cached module and chapters.
        emit(
          state.copyWith(
            status: ModuleDetailStatus.success,
            module: visibleModule,
            chapters: visibleChapters,
            isRefreshing: false,
            clearMessage: true,
          ),
        );

        return;
      }

      emit(
        state.copyWith(
          status: ModuleDetailStatus.failure,
          isRefreshing: false,
          message: _moduleFailureMessage(
            requestFailure,
          ),
        ),
      );

      return;
    }

    final validChapterIds = remoteChapters!.map((chapter) => chapter.id).toSet();

    final preservedResources = <String, List<ChapterResourceModel>>{
      for (final entry in state.resourcesByChapter.entries)
        if (validChapterIds.contains(entry.key)) entry.key: entry.value,
    };

    final preservedRefreshedResourceIds = state.refreshedResourceChapterIds
        .where(validChapterIds.contains)
        .toSet();

    final preservedVideos = <String, List<ChapterVideoModel>>{
      for (final entry in state.videosByChapter.entries)
        if (validChapterIds.contains(entry.key)) entry.key: entry.value,
    };

    final preservedRefreshedIds = state.refreshedVideoChapterIds
        .where(validChapterIds.contains)
        .toSet();

    final snapshot = ModuleLessonsCacheSnapshot(
      module: remoteModule!,
      chapters: remoteChapters!,
      videosByChapter: preservedVideos,
      cachedAt: DateTime.now(),
    );

    await learnUseCase.saveModuleLessonsCache(
      snapshot,
    );

    await learnUseCase.pruneChapterVideosCache(
      moduleId: event.moduleId,
      validChapterIds: validChapterIds,
    );

    await learnUseCase.pruneChapterResourcesCache(
      moduleId: event.moduleId,
      validChapterIds: validChapterIds,
    );

    emit(
      state.copyWith(
        status: ModuleDetailStatus.success,
        module: remoteModule,
        chapters: remoteChapters,
        videosByChapter: preservedVideos,
        refreshedVideoChapterIds: preservedRefreshedIds,
        isRefreshing: false,
        clearMessage: true,
        resourcesByChapter: preservedResources,
        refreshedResourceChapterIds: preservedRefreshedResourceIds,
      ),
    );

    _queueFirstVideoChapter(remoteChapters!);
  }

  void _queueFirstVideoChapter(
    List<ChapterModel> chapters,
  ) {
    for (final chapter in chapters) {
      if (chapter.videosCount > 0) {
        add(
          OnGetChapterVideos(
            chapterId: chapter.id,
          ),
        );

        return;
      }
    }
  }

  Future<void> _onGetChapterVideos(
    OnGetChapterVideos event,
    Emitter<ModuleDetailState> emit,
  ) async {
    final moduleId = state.module?.id;

    if (moduleId == null) {
      return;
    }

    if (state.refreshingVideoChapterIds.contains(
          event.chapterId,
        ) ||
        state.refreshedVideoChapterIds.contains(
          event.chapterId,
        )) {
      return;
    }

    final hasCachedVideos = state.videosByChapter.containsKey(
      event.chapterId,
    );

    final refreshingIds = {
      ...state.refreshingVideoChapterIds,
      event.chapterId,
    };

    final loadingIds = {
      ...state.loadingChapterIds,
    };

    // Only show the large loading indicator when there
    // is no cached list to display.
    if (!hasCachedVideos) {
      loadingIds.add(event.chapterId);
    }

    final errors = {
      ...state.chapterVideoErrors,
    }..remove(event.chapterId);

    emit(
      state.copyWith(
        refreshingVideoChapterIds: refreshingIds,
        loadingChapterIds: loadingIds,
        chapterVideoErrors: errors,
        clearMessage: true,
      ),
    );

    final result = await learnUseCase.getChapterVideos(
      chapterId: event.chapterId,
    );

    await result.fold<Future<void>>(
      (failure) async {
        final updatedRefreshingIds = {
          ...state.refreshingVideoChapterIds,
        }..remove(event.chapterId);

        final updatedLoadingIds = {
          ...state.loadingChapterIds,
        }..remove(event.chapterId);

        if (hasCachedVideos) {
          // Silently retain the cached video list.
          emit(
            state.copyWith(
              refreshingVideoChapterIds: updatedRefreshingIds,
              loadingChapterIds: updatedLoadingIds,
              clearMessage: true,
            ),
          );

          return;
        }

        final updatedErrors = {
          ...state.chapterVideoErrors,
          event.chapterId: _chapterVideoFailureMessage(failure),
        };

        emit(
          state.copyWith(
            refreshingVideoChapterIds: updatedRefreshingIds,
            loadingChapterIds: updatedLoadingIds,
            chapterVideoErrors: updatedErrors,
          ),
        );
      },
      (response) async {
        final videos = [...response.data]
          ..sort(
            (first, second) {
              return first.rank.compareTo(second.rank);
            },
          );

        // Replacing this chapter key also handles an empty
        // response and removes videos deleted by backend.
        final updatedVideos = {
          ...state.videosByChapter,
          event.chapterId: videos,
        };

        final updatedRefreshingIds = {
          ...state.refreshingVideoChapterIds,
        }..remove(event.chapterId);

        final updatedLoadingIds = {
          ...state.loadingChapterIds,
        }..remove(event.chapterId);

        final updatedRefreshedIds = {
          ...state.refreshedVideoChapterIds,
          event.chapterId,
        };

        final updatedErrors = {
          ...state.chapterVideoErrors,
        }..remove(event.chapterId);

        await learnUseCase.saveChapterVideosCache(
          moduleId: moduleId,
          chapterId: event.chapterId,
          videos: videos,
        );

        emit(
          state.copyWith(
            videosByChapter: updatedVideos,
            refreshingVideoChapterIds: updatedRefreshingIds,
            refreshedVideoChapterIds: updatedRefreshedIds,
            loadingChapterIds: updatedLoadingIds,
            chapterVideoErrors: updatedErrors,
            clearMessage: true,
          ),
        );
      },
    );
  }

  String _moduleFailureMessage(
    Failure? failure,
  ) {
    if (failure is ConnectionFailure) {
      return 'Please check your internet connection and try again.';
    }

    final message = failure?.e?.toString();

    if (message == null || message.trim().isEmpty) {
      return 'Unable to load module information.';
    }

    return message;
  }

  String _chapterVideoFailureMessage(
    Failure? failure,
  ) {
    if (failure is ConnectionFailure) {
      return 'Please check your internet connection and try again.';
    }

    final message = failure?.e?.toString();

    if (message == null || message.trim().isEmpty) {
      return 'Unable to load the videos in this chapter.';
    }

    return message;
  }

  Future<void> _onGetChapterResources(
    OnGetChapterResources event,
    Emitter<ModuleDetailState> emit,
  ) async {
    final moduleId = state.module?.id;
    final chapterId = event.chapterId;

    if (moduleId == null) {
      return;
    }

    if (state.refreshingResourceChapterIds.contains(
          chapterId,
        ) ||
        state.refreshedResourceChapterIds.contains(
          chapterId,
        )) {
      return;
    }

    final cachedResources =
        state.resourcesByChapter[chapterId] ??
        await learnUseCase.getCachedChapterResources(
          moduleId: moduleId,
          chapterId: chapterId,
        );

    final hasCachedResources = cachedResources != null;

    final updatedResources = {
      ...state.resourcesByChapter,
    };

    if (cachedResources != null) {
      updatedResources[chapterId] = cachedResources;
    }

    final refreshingIds = {
      ...state.refreshingResourceChapterIds,
      chapterId,
    };

    final loadingIds = {
      ...state.loadingResourceChapterIds,
    };

    // Keep cached resources visible while the network
    // request refreshes in the background.
    if (!hasCachedResources) {
      loadingIds.add(chapterId);
    }

    final errors = {
      ...state.chapterResourceErrors,
    }..remove(chapterId);

    emit(
      state.copyWith(
        resourcesByChapter: updatedResources,
        refreshingResourceChapterIds: refreshingIds,
        loadingResourceChapterIds: loadingIds,
        chapterResourceErrors: errors,
        clearMessage: true,
      ),
    );

    final result = await learnUseCase.getChapterResources(
      chapterId: chapterId,
    );

    await result.fold<Future<void>>(
      (failure) async {
        final updatedRefreshingIds = {
          ...state.refreshingResourceChapterIds,
        }..remove(chapterId);

        final updatedLoadingIds = {
          ...state.loadingResourceChapterIds,
        }..remove(chapterId);

        if (hasCachedResources) {
          // Silently retain cached resources.
          emit(
            state.copyWith(
              refreshingResourceChapterIds: updatedRefreshingIds,
              loadingResourceChapterIds: updatedLoadingIds,
              clearMessage: true,
            ),
          );

          return;
        }

        final updatedErrors = {
          ...state.chapterResourceErrors,
          chapterId: _chapterResourceFailureMessage(
            failure,
          ),
        };

        emit(
          state.copyWith(
            refreshingResourceChapterIds: updatedRefreshingIds,
            loadingResourceChapterIds: updatedLoadingIds,
            chapterResourceErrors: updatedErrors,
          ),
        );
      },
      (response) async {
        final resources = [...response.data]
          ..sort(
            (first, second) {
              return first.rank.compareTo(second.rank);
            },
          );

        // This replaces previous data even when the
        // response is empty.
        final updatedResources = {
          ...state.resourcesByChapter,
          chapterId: resources,
        };

        final updatedRefreshingIds = {
          ...state.refreshingResourceChapterIds,
        }..remove(chapterId);

        final updatedLoadingIds = {
          ...state.loadingResourceChapterIds,
        }..remove(chapterId);

        final updatedRefreshedIds = {
          ...state.refreshedResourceChapterIds,
          chapterId,
        };

        final updatedErrors = {
          ...state.chapterResourceErrors,
        }..remove(chapterId);

        await learnUseCase.saveChapterResourcesCache(
          moduleId: moduleId,
          chapterId: chapterId,
          resources: resources,
        );

        emit(
          state.copyWith(
            resourcesByChapter: updatedResources,
            refreshingResourceChapterIds: updatedRefreshingIds,
            refreshedResourceChapterIds: updatedRefreshedIds,
            loadingResourceChapterIds: updatedLoadingIds,
            chapterResourceErrors: updatedErrors,
            clearMessage: true,
          ),
        );
      },
    );
  }

  String _chapterResourceFailureMessage(
    Failure? failure,
  ) {
    if (failure is ConnectionFailure) {
      return 'Please check your internet connection and try again.';
    }

    final message = failure?.e?.toString();

    if (message == null || message.trim().isEmpty) {
      return 'Unable to load the resources in this chapter.';
    }

    return message;
  }

  String _failureMessage(Failure? failure) {
    if (failure is ConnectionFailure) {
      return 'Please check your internet connection and try again.';
    }

    final message = failure?.e?.toString();

    if (message == null || message.isEmpty) {
      return 'Unable to load module information.';
    }

    return message;
  }

  Future<void> _onGetChapterQuizzes(
    OnGetChapterQuizzes event,
    Emitter<ModuleDetailState> emit,
  ) async {
    final chapterId = event.chapterId;

    if (state.loadingQuizChapterIds.contains(
          chapterId,
        ) ||
        state.quizzesByChapter.containsKey(
          chapterId,
        )) {
      return;
    }

    final loadingIds = {
      ...state.loadingQuizChapterIds,
      chapterId,
    };

    final errors = {
      ...state.chapterQuizErrors,
    }..remove(chapterId);

    emit(
      state.copyWith(
        loadingQuizChapterIds: loadingIds,
        chapterQuizErrors: errors,
      ),
    );

    final result = await learnUseCase.getChapterQuizzes(
      chapterId: chapterId,
    );

    result.fold(
      (failure) {
        final updatedLoadingIds = {
          ...state.loadingQuizChapterIds,
        }..remove(chapterId);

        final updatedErrors = {
          ...state.chapterQuizErrors,
          chapterId: _failureMessage(failure),
        };

        emit(
          state.copyWith(
            loadingQuizChapterIds: updatedLoadingIds,
            chapterQuizErrors: updatedErrors,
          ),
        );
      },
      (response) {
        final quizzes = [...response.data]
          ..sort(
            (first, second) {
              return first.sortOrder.compareTo(
                second.sortOrder,
              );
            },
          );

        final updatedQuizzes = {
          ...state.quizzesByChapter,
          chapterId: quizzes,
        };

        final updatedLoadingIds = {
          ...state.loadingQuizChapterIds,
        }..remove(chapterId);

        emit(
          state.copyWith(
            quizzesByChapter: updatedQuizzes,
            loadingQuizChapterIds: updatedLoadingIds,
          ),
        );
      },
    );
  }
}
