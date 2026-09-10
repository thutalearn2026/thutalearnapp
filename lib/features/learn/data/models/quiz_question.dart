enum QuizQuestionType {
  listening,
  reading,
}

class QuizOption {
  final String answer;

  const QuizOption({
    required this.answer,
  });
}

class QuizQuestion {
  final QuizQuestionType type;
  final String question;
  final String? audioUrl;
  final List<QuizOption> options;
  final int correctOptionIndex;
  final String explanation;

  const QuizQuestion({
    required this.type,
    required this.question,
    this.audioUrl,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });
}