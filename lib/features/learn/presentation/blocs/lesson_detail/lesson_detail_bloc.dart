import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

part 'lesson_detail_event.dart';
part 'lesson_detail_state.dart';

@Injectable()
class LessonDetailBloc
    extends Bloc<LessonDetailEvent, LessonDetailState> {
  final LearnUseCase learnUseCase;

  LessonDetailBloc({
    required this.learnUseCase,
  }) : super(const LessonDetailState()) {
    on<OnGetLessonDetail>(_onGetLessonDetail);
  }

  Future<void> _onGetLessonDetail(
      OnGetLessonDetail event,
      Emitter<LessonDetailState> emit,
      ) async {
    if (state.isLoading) {
      return;
    }

    emit(
      state.copyWith(
        status: LessonDetailStatus.loading,
        clearMessage: true,
      ),
    );

    final result = await learnUseCase.getChapterVideoDetail(
      chapterId: event.chapterId,
      videoId: event.videoId,
    );

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            status: LessonDetailStatus.failure,
            message: _failureMessage(failure),
          ),
        );
      },
          (response) {
        emit(
          state.copyWith(
            status: LessonDetailStatus.success,
            video: response.data,
            clearMessage: true,
          ),
        );
      },
    );
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