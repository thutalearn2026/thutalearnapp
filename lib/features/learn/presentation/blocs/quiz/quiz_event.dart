part of 'quiz_bloc.dart';

@immutable
sealed class QuizEvent {}

class OnGetQuizDetail extends QuizEvent {
  final String chapterId;
  final String quizId;

  OnGetQuizDetail({
    required this.chapterId,
    required this.quizId,
  });
}

class QuizAnswerSelected extends QuizEvent {
  final String questionId;
  final String optionId;

  QuizAnswerSelected({
    required this.questionId,
    required this.optionId,
  });
}

class QuizContinuePressed extends QuizEvent {}

class QuizSubmitPressed extends QuizEvent {}

class QuizAudioPressed extends QuizEvent {}

class QuizRestartPressed extends QuizEvent {}