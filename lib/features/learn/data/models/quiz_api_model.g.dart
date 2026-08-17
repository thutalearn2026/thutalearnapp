// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizDetailResponse _$QuizDetailResponseFromJson(Map<String, dynamic> json) =>
    QuizDetailResponse(
      data: QuizDetailModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QuizDetailResponseToJson(QuizDetailResponse instance) =>
    <String, dynamic>{'data': instance.data};

QuizDetailModel _$QuizDetailModelFromJson(Map<String, dynamic> json) =>
    QuizDetailModel(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => QuizQuestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuizDetailModelToJson(QuizDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'questions': instance.questions,
    };

QuizQuestionModel _$QuizQuestionModelFromJson(Map<String, dynamic> json) =>
    QuizQuestionModel(
      id: json['id'] as String,
      question: json['question'] as String,
      audioFile: json['audio_file'] as String?,
      sortOrder: (json['sort_order'] as num).toInt(),
      options: (json['options'] as List<dynamic>)
          .map(
            (e) => QuizQuestionOptionModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$QuizQuestionModelToJson(QuizQuestionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'audio_file': instance.audioFile,
      'sort_order': instance.sortOrder,
      'options': instance.options,
    };

QuizQuestionOptionModel _$QuizQuestionOptionModelFromJson(
  Map<String, dynamic> json,
) => QuizQuestionOptionModel(
  id: json['id'] as String,
  text: json['text'] as String,
  sortOrder: (json['sort_order'] as num).toInt(),
);

Map<String, dynamic> _$QuizQuestionOptionModelToJson(
  QuizQuestionOptionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'sort_order': instance.sortOrder,
};

QuizAttemptRequest _$QuizAttemptRequestFromJson(Map<String, dynamic> json) =>
    QuizAttemptRequest(
      answers: (json['answers'] as List<dynamic>)
          .map(
            (e) => QuizAttemptAnswerRequest.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$QuizAttemptRequestToJson(QuizAttemptRequest instance) =>
    <String, dynamic>{'answers': instance.answers};

QuizAttemptAnswerRequest _$QuizAttemptAnswerRequestFromJson(
  Map<String, dynamic> json,
) => QuizAttemptAnswerRequest(
  questionId: json['question_id'] as String,
  optionId: json['option_id'] as String,
);

Map<String, dynamic> _$QuizAttemptAnswerRequestToJson(
  QuizAttemptAnswerRequest instance,
) => <String, dynamic>{
  'question_id': instance.questionId,
  'option_id': instance.optionId,
};

QuizAttemptResponse _$QuizAttemptResponseFromJson(Map<String, dynamic> json) =>
    QuizAttemptResponse(
      data: QuizAttemptResultModel.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$QuizAttemptResponseToJson(
  QuizAttemptResponse instance,
) => <String, dynamic>{'data': instance.data};

QuizAttemptResultModel _$QuizAttemptResultModelFromJson(
  Map<String, dynamic> json,
) => QuizAttemptResultModel(
  id: json['id'] as String,
  quizId: json['quiz_id'] as String,
  totalQuestions: (json['total_questions'] as num).toInt(),
  correctAnswers: (json['correct_answers'] as num).toInt(),
  scorePercentage: json['score_percentage'] as num,
  passed: json['passed'] as bool,
  completedAt: json['completed_at'] as String?,
  answers: (json['answers'] as List<dynamic>)
      .map(
        (e) => QuizAttemptAnswerResultModel.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$QuizAttemptResultModelToJson(
  QuizAttemptResultModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'quiz_id': instance.quizId,
  'total_questions': instance.totalQuestions,
  'correct_answers': instance.correctAnswers,
  'score_percentage': instance.scorePercentage,
  'passed': instance.passed,
  'completed_at': instance.completedAt,
  'answers': instance.answers,
};

QuizAttemptAnswerResultModel _$QuizAttemptAnswerResultModelFromJson(
  Map<String, dynamic> json,
) => QuizAttemptAnswerResultModel(
  questionId: json['question_id'] as String,
  question: json['question'] as String,
  selectedOptionId: json['selected_option_id'] as String?,
  isCorrect: json['is_correct'] as bool,
  correctOptionId: json['correct_option_id'] as String?,
);

Map<String, dynamic> _$QuizAttemptAnswerResultModelToJson(
  QuizAttemptAnswerResultModel instance,
) => <String, dynamic>{
  'question_id': instance.questionId,
  'question': instance.question,
  'selected_option_id': instance.selectedOptionId,
  'is_correct': instance.isCorrect,
  'correct_option_id': instance.correctOptionId,
};
