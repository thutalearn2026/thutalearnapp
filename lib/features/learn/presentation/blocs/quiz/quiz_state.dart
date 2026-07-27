part of 'quiz_bloc.dart';

enum QuizStatus {
  inProgress,
  completed,
}

class QuizState {
  final List<QuizQuestion> questions;
  final int currentQuestionIndex;
  final int? selectedOptionIndex;
  final int score;
  final bool isAudioPlaying;
  final QuizStatus status;

  const QuizState({
    required this.questions,
    required this.currentQuestionIndex,
    required this.score,
    required this.status,
    this.selectedOptionIndex,
    this.isAudioPlaying = false,
  });

  QuizQuestion get currentQuestion {
    return questions[currentQuestionIndex];
  }

  bool get hasAnswered {
    return selectedOptionIndex != null;
  }

  bool get selectedAnswerIsCorrect {
    return selectedOptionIndex ==
        currentQuestion.correctOptionIndex;
  }

  double get progress {
    if (questions.isEmpty) {
      return 0;
    }

    return (currentQuestionIndex + 1) / questions.length;
  }

  QuizState copyWith({
    int? currentQuestionIndex,
    int? selectedOptionIndex,
    int? score,
    bool? isAudioPlaying,
    QuizStatus? status,
    bool clearSelectedOption = false,
  }) {
    return QuizState(
      questions: questions,
      currentQuestionIndex:
      currentQuestionIndex ?? this.currentQuestionIndex,
      selectedOptionIndex: clearSelectedOption
          ? null
          : selectedOptionIndex ?? this.selectedOptionIndex,
      score: score ?? this.score,
      isAudioPlaying:
      isAudioPlaying ?? this.isAudioPlaying,
      status: status ?? this.status,
    );
  }
}