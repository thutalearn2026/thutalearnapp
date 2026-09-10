import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

@Injectable()
class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final LearnUseCase learnUseCase;

  QuizBloc({
    required this.learnUseCase,
  }) : super(const QuizState()) {
    on<OnGetQuizDetail>(_onGetQuizDetail);
    on<QuizAnswerSelected>(_onAnswerSelected);
    on<QuizContinuePressed>(_onContinuePressed);
    on<QuizSubmitPressed>(_onSubmitPressed);
    on<QuizAudioPressed>(_onAudioPressed);
    on<QuizRestartPressed>(_onRestartPressed);
  }

  Future<void> _onGetQuizDetail(
      OnGetQuizDetail event,
      Emitter<QuizState> emit,
      ) async {
    if (state.isLoading) {
      return;
    }

    emit(
      state.copyWith(
        status: QuizStatus.loading,
        clearMessage: true,
      ),
    );

    final result = await learnUseCase.getQuizDetail(
      chapterId: event.chapterId,
      quizId: event.quizId,
    );

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            status: QuizStatus.failure,
            message: _failureMessage(failure),
          ),
        );
      },
          (response) {
        final questions = response.data.questions
            .map(
              (question) {
            final options = [...question.options]
              ..sort(
                    (first, second) {
                  return first.sortOrder.compareTo(
                    second.sortOrder,
                  );
                },
              );

            return QuizQuestionModel(
              id: question.id,
              question: question.question,
              audioFile: question.audioFile,
              sortOrder: question.sortOrder,
              options: options,
            );
          },
        )
            .toList()
          ..sort(
                (first, second) {
              return first.sortOrder.compareTo(
                second.sortOrder,
              );
            },
          );

        if (questions.isEmpty) {
          emit(
            state.copyWith(
              status: QuizStatus.failure,
              message:
              'This quiz does not contain any questions.',
            ),
          );

          return;
        }

        final quiz = QuizDetailModel(
          id: response.data.id,
          title: response.data.title,
          type: response.data.type,
          questions: questions,
        );

        emit(
          QuizState(
            status: QuizStatus.inProgress,
            quiz: quiz,
          ),
        );
      },
    );
  }

  void _onAnswerSelected(
      QuizAnswerSelected event,
      Emitter<QuizState> emit,
      ) {
    if (state.isSubmitting ||
        state.status != QuizStatus.inProgress) {
      return;
    }

    final updatedAnswers = {
      ...state.selectedAnswers,
      event.questionId: event.optionId,
    };

    emit(
      state.copyWith(
        selectedAnswers: updatedAnswers,
        isAudioPlaying: false,
      ),
    );
  }

  void _onContinuePressed(
      QuizContinuePressed event,
      Emitter<QuizState> emit,
      ) {
    final question = state.currentQuestion;

    if (question == null ||
        state.selectedAnswers[question.id] == null ||
        state.isLastQuestion) {
      return;
    }

    emit(
      state.copyWith(
        currentQuestionIndex:
        state.currentQuestionIndex + 1,
        isAudioPlaying: false,
      ),
    );
  }

  Future<void> _onSubmitPressed(
      QuizSubmitPressed event,
      Emitter<QuizState> emit,
      ) async {
    final quiz = state.quiz;
    final question = state.currentQuestion;

    if (quiz == null ||
        question == null ||
        state.selectedAnswers[question.id] == null ||
        state.isSubmitting) {
      return;
    }

    emit(
      state.copyWith(
        status: QuizStatus.submitting,
        clearMessage: true,
        isAudioPlaying: false,
      ),
    );

    final answers = state.selectedAnswers.entries
        .map(
          (entry) {
        return QuizAttemptAnswerRequest(
          questionId: entry.key,
          optionId: entry.value,
        );
      },
    )
        .toList();

    final result =
    await learnUseCase.submitQuizAttempt(
      quizId: quiz.id,
      request: QuizAttemptRequest(
        answers: answers,
      ),
    );

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            status: QuizStatus.inProgress,
            message: _failureMessage(failure),
          ),
        );
      },
          (response) {
        emit(
          state.copyWith(
            status: QuizStatus.completed,
            attempt: response.data,
            clearMessage: true,
          ),
        );
      },
    );
  }

  void _onAudioPressed(
      QuizAudioPressed event,
      Emitter<QuizState> emit,
      ) {
    if (state.currentQuestion?.audioFile == null) {
      return;
    }

    emit(
      state.copyWith(
        isAudioPlaying: !state.isAudioPlaying,
      ),
    );

    // Connect the actual audio player package here.
  }

  void _onRestartPressed(
      QuizRestartPressed event,
      Emitter<QuizState> emit,
      ) {
    final quiz = state.quiz;

    if (quiz == null) {
      return;
    }

    emit(
      QuizState(
        status: QuizStatus.inProgress,
        quiz: quiz,
      ),
    );
  }

  String _failureMessage(Failure failure) {
    if (failure is ConnectionFailure) {
      return 'Please check your internet connection and try again.';
    }

    final message = failure.e?.toString();

    if (message == null ||
        message.trim().isEmpty) {
      return 'Something went wrong. Please try again.';
    }

    return message;
  }
}