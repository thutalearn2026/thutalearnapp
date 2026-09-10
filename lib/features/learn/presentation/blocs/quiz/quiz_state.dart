part of 'quiz_bloc.dart';

enum QuizStatus {
  initial,
  loading,
  inProgress,
  submitting,
  completed,
  failure,
}

class QuizState {
  final QuizStatus status;
  final QuizDetailModel? quiz;
  final int currentQuestionIndex;

  final Map<String, String> selectedAnswers;

  final QuizAttemptResultModel? attempt;
  final bool isAudioPlaying;
  final String? message;

  const QuizState({
    this.status = QuizStatus.initial,
    this.quiz,
    this.currentQuestionIndex = 0,
    this.selectedAnswers = const {},
    this.attempt,
    this.isAudioPlaying = false,
    this.message,
  });

  bool get isLoading {
    return status == QuizStatus.loading;
  }

  bool get isSubmitting {
    return status == QuizStatus.submitting;
  }

  List<QuizQuestionModel> get questions {
    return quiz?.questions ?? const [];
  }

  QuizQuestionModel? get currentQuestion {
    if (questions.isEmpty || currentQuestionIndex >= questions.length) {
      return null;
    }

    return questions[currentQuestionIndex];
  }

  String? get currentSelectedOptionId {
    final question = currentQuestion;

    if (question == null) {
      return null;
    }

    return selectedAnswers[question.id];
  }

  bool get hasSelectedCurrentAnswer {
    return currentSelectedOptionId != null;
  }

  bool get isLastQuestion {
    return questions.isNotEmpty && currentQuestionIndex == questions.length - 1;
  }

  double get progress {
    if (questions.isEmpty) {
      return 0;
    }

    return (currentQuestionIndex + 1) / questions.length;
  }

  QuizState copyWith({
    QuizStatus? status,
    QuizDetailModel? quiz,
    int? currentQuestionIndex,
    Map<String, String>? selectedAnswers,
    QuizAttemptResultModel? attempt,
    bool? isAudioPlaying,
    String? message,
    bool clearMessage = false,
  }) {
    return QuizState(
      status: status ?? this.status,
      quiz: quiz ?? this.quiz,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      attempt: attempt ?? this.attempt,
      isAudioPlaying: isAudioPlaying ?? this.isAudioPlaying,
      message: clearMessage ? null : message ?? this.message,
    );
  }
}
