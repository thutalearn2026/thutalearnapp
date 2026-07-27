import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:thuta_learn/features/learn/learn.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc({
    required List<QuizQuestion> questions,
  }) : super(
    QuizState(
      questions: questions,
      currentQuestionIndex: 0,
      score: 0,
      status: QuizStatus.inProgress,
    ),
  ) {
    on<QuizAnswerSelected>(_onAnswerSelected);
    on<QuizContinuePressed>(_onContinuePressed);
    on<QuizAudioPressed>(_onAudioPressed);
    on<QuizRestartPressed>(_onRestartPressed);
  }

  Future<void> _onAnswerSelected(
      QuizAnswerSelected event,
      Emitter<QuizState> emit,
      ) async {
    if (state.hasAnswered) {
      return;
    }

    final isCorrect =
        state.currentQuestion.correctOptionIndex ==
            event.optionIndex;

    emit(
      state.copyWith(
        selectedOptionIndex: event.optionIndex,
        score: isCorrect ? state.score + 1 : state.score,
        isAudioPlaying: false,
      ),
    );
  }

  Future<void> _onContinuePressed(
      QuizContinuePressed event,
      Emitter<QuizState> emit,
      ) async {
    if (!state.hasAnswered) {
      return;
    }

    final isLastQuestion =
        state.currentQuestionIndex ==
            state.questions.length - 1;

    if (isLastQuestion) {
      emit(
        state.copyWith(
          status: QuizStatus.completed,
          isAudioPlaying: false,
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        currentQuestionIndex:
        state.currentQuestionIndex + 1,
        clearSelectedOption: true,
        isAudioPlaying: false,
      ),
    );
  }

  Future<void> _onAudioPressed(
      QuizAudioPressed event,
      Emitter<QuizState> emit,
      ) async {
    if (state.hasAnswered) {
      return;
    }

    emit(
      state.copyWith(
        isAudioPlaying: !state.isAudioPlaying,
      ),
    );

    // Connect your audio player here later.
  }

  Future<void> _onRestartPressed(
      QuizRestartPressed event,
      Emitter<QuizState> emit,
      ) async {
    emit(
      QuizState(
        questions: state.questions,
        currentQuestionIndex: 0,
        score: 0,
        status: QuizStatus.inProgress,
      ),
    );
  }
}