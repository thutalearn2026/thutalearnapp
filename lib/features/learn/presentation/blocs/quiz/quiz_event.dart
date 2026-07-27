part of 'quiz_bloc.dart';

sealed class QuizEvent {}

class QuizAnswerSelected extends QuizEvent {
  final int optionIndex;

  QuizAnswerSelected(this.optionIndex);
}

class QuizContinuePressed extends QuizEvent {}

class QuizAudioPressed extends QuizEvent {}

class QuizRestartPressed extends QuizEvent {}