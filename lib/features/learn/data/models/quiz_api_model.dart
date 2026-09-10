import 'package:json_annotation/json_annotation.dart';

part 'quiz_api_model.g.dart';

@JsonSerializable()
class QuizDetailResponse {
  final QuizDetailModel data;

  const QuizDetailResponse({
    required this.data,
  });

  factory QuizDetailResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$QuizDetailResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$QuizDetailResponseToJson(this);
  }
}

@JsonSerializable(
  fieldRename: FieldRename.snake,
)
class QuizDetailModel {
  final String id;
  final String title;
  final String type;
  final List<QuizQuestionModel> questions;

  const QuizDetailModel({
    required this.id,
    required this.title,
    required this.type,
    required this.questions,
  });

  factory QuizDetailModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$QuizDetailModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$QuizDetailModelToJson(this);
  }
}

@JsonSerializable(
  fieldRename: FieldRename.snake,
)
class QuizQuestionModel {
  final String id;
  final String question;
  final String? audioFile;
  final int sortOrder;
  final List<QuizQuestionOptionModel> options;

  const QuizQuestionModel({
    required this.id,
    required this.question,
    this.audioFile,
    required this.sortOrder,
    required this.options,
  });

  factory QuizQuestionModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$QuizQuestionModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$QuizQuestionModelToJson(this);
  }
}

@JsonSerializable(
  fieldRename: FieldRename.snake,
)
class QuizQuestionOptionModel {
  final String id;
  final String text;
  final int sortOrder;

  const QuizQuestionOptionModel({
    required this.id,
    required this.text,
    required this.sortOrder,
  });

  factory QuizQuestionOptionModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$QuizQuestionOptionModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$QuizQuestionOptionModelToJson(this);
  }
}

@JsonSerializable()
class QuizAttemptRequest {
  final List<QuizAttemptAnswerRequest> answers;

  const QuizAttemptRequest({
    required this.answers,
  });

  factory QuizAttemptRequest.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$QuizAttemptRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$QuizAttemptRequestToJson(this);
  }
}

@JsonSerializable(
  fieldRename: FieldRename.snake,
)
class QuizAttemptAnswerRequest {
  final String questionId;
  final String optionId;

  const QuizAttemptAnswerRequest({
    required this.questionId,
    required this.optionId,
  });

  factory QuizAttemptAnswerRequest.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$QuizAttemptAnswerRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$QuizAttemptAnswerRequestToJson(this);
  }
}

@JsonSerializable()
class QuizAttemptResponse {
  final QuizAttemptResultModel data;

  const QuizAttemptResponse({
    required this.data,
  });

  factory QuizAttemptResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$QuizAttemptResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$QuizAttemptResponseToJson(this);
  }
}

@JsonSerializable(
  fieldRename: FieldRename.snake,
)
class QuizAttemptResultModel {
  final String id;
  final String quizId;
  final int totalQuestions;
  final int correctAnswers;
  final num scorePercentage;
  final bool passed;
  final String? completedAt;
  final List<QuizAttemptAnswerResultModel> answers;

  const QuizAttemptResultModel({
    required this.id,
    required this.quizId,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.scorePercentage,
    required this.passed,
    this.completedAt,
    required this.answers,
  });

  factory QuizAttemptResultModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$QuizAttemptResultModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$QuizAttemptResultModelToJson(this);
  }
}

@JsonSerializable(
  fieldRename: FieldRename.snake,
)
class QuizAttemptAnswerResultModel {
  final String questionId;
  final String question;
  final String? selectedOptionId;
  final bool isCorrect;
  final String? correctOptionId;

  const QuizAttemptAnswerResultModel({
    required this.questionId,
    required this.question,
    this.selectedOptionId,
    required this.isCorrect,
    this.correctOptionId,
  });

  factory QuizAttemptAnswerResultModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$QuizAttemptAnswerResultModelFromJson(
      json,
    );
  }

  Map<String, dynamic> toJson() {
    return _$QuizAttemptAnswerResultModelToJson(
      this,
    );
  }
}