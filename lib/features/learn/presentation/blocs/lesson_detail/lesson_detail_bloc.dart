import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

part 'lesson_detail_event.dart';
part 'lesson_detail_state.dart';

@Injectable()
class LessonDetailBloc extends Bloc<LessonDetailEvent, LessonDetailState> {
  final LearnUseCase learnUseCase;

  LessonDetailBloc({
    required this.learnUseCase,
  }) : super(const LessonDetailState()) {
    on<OnGetLessonDetail>(_onGetLessonDetail);
    on<OnGetLessonVocabularies>(_onGetLessonVocabularies);
  }

  Future<void> _onGetLessonDetail(
    OnGetLessonDetail event,
    Emitter<LessonDetailState> emit,
  ) async {
    if (state.isRefreshing) {
      return;
    }

    final cachedVideo = await learnUseCase.getCachedLessonDetail(
      chapterId: event.chapterId,
      videoId: event.videoId,
    );

    final visibleVideo = cachedVideo ?? state.video;

    final hasCachedData = visibleVideo != null;

    emit(
      state.copyWith(
        status: hasCachedData ? LessonDetailStatus.success : LessonDetailStatus.loading,
        video: visibleVideo,
        isRefreshing: true,
        clearMessage: true,
      ),
    );

    final result = await learnUseCase.getChapterVideoDetail(
      chapterId: event.chapterId,
      videoId: event.videoId,
    );

    await result.fold<Future<void>>(
      (failure) async {
        if (hasCachedData) {
          // Silently retain cached lesson metadata.
          emit(
            state.copyWith(
              status: LessonDetailStatus.success,
              video: visibleVideo,
              isRefreshing: false,
              clearMessage: true,
            ),
          );

          return;
        }

        emit(
          state.copyWith(
            status: LessonDetailStatus.failure,
            isRefreshing: false,
            message: _failureMessage(failure),
          ),
        );
      },
      (response) async {
        await learnUseCase.saveLessonDetailCache(
          chapterId: event.chapterId,
          video: response.data,
        );

        emit(
          state.copyWith(
            status: LessonDetailStatus.success,
            video: response.data,
            isRefreshing: false,
            clearMessage: true,
          ),
        );
      },
    );
  }

  Future<void> _onGetLessonVocabularies(
      OnGetLessonVocabularies event,
      Emitter<LessonDetailState> emit,
      ) async {
    if (state.isVocabularyRefreshing) {
      return;
    }

    final cachedVocabularies =
    await learnUseCase.getCachedVideoVocabularies(
      videoId: event.videoId,
    );

    final visibleVocabularies =
        cachedVocabularies ?? state.vocabularies;

    final hasCachedData =
        cachedVocabularies != null;

    emit(
      state.copyWith(
        vocabularyStatus: hasCachedData
            ? LessonVocabularyStatus.success
            : LessonVocabularyStatus.loading,
        vocabularies: visibleVocabularies,
        isVocabularyRefreshing: true,
        clearVocabularyMessage: true,
      ),
    );

    final result =
    await learnUseCase.getVideoVocabularies(
      videoId: event.videoId,
    );

    await result.fold<Future<void>>(
          (failure) async {
        if (hasCachedData) {
          // Silently retain cached vocabularies.
          emit(
            state.copyWith(
              vocabularyStatus:
              LessonVocabularyStatus.success,
              vocabularies: visibleVocabularies,
              isVocabularyRefreshing: false,
              clearVocabularyMessage: true,
            ),
          );

          return;
        }

        emit(
          state.copyWith(
            vocabularyStatus:
            LessonVocabularyStatus.failure,
            isVocabularyRefreshing: false,
            vocabularyMessage:
            _vocabularyFailureMessage(failure),
          ),
        );
      },
          (response) async {
        final vocabularies = [...response.data]
          ..sort(
                (first, second) {
              return first.rank.compareTo(second.rank);
            },
          );

        await learnUseCase.saveVideoVocabulariesCache(
          videoId: event.videoId,
          vocabularies: vocabularies,
        );

        emit(
          state.copyWith(
            vocabularyStatus:
            LessonVocabularyStatus.success,
            vocabularies: vocabularies,
            isVocabularyRefreshing: false,
            clearVocabularyMessage: true,
          ),
        );
      },
    );
  }

  String _vocabularyFailureMessage(
      Failure failure,
      ) {
    if (failure is ConnectionFailure) {
      return 'Please check your internet connection and try again.';
    }

    final message = failure.e?.toString();

    if (message == null || message.trim().isEmpty) {
      return 'Unable to load the vocabulary list.';
    }

    return message;
  }

  String _failureMessage(Failure failure) {
    if (failure is ConnectionFailure) {
      return 'Please check your internet connection and try again.';
    }

    final message = failure.e?.toString();

    if (message == null || message.trim().isEmpty) {
      return 'Unable to load this lesson.';
    }

    return message;
  }
}
