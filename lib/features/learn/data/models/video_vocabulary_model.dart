import 'package:json_annotation/json_annotation.dart';

part 'video_vocabulary_model.g.dart';

@JsonSerializable(
  fieldRename: FieldRename.snake,
)
class VideoVocabularyModel {
  final String id;
  final String word;
  final String? definition;
  final String? example;
  final String? pronunciation;
  final String? image;
  final String status;
  final int rank;

  @JsonKey(defaultValue: false)
  final bool isSaved;

  final String? createdAt;
  final String? updatedAt;

  const VideoVocabularyModel({
    required this.id,
    required this.word,
    this.definition,
    this.example,
    this.pronunciation,
    this.image,
    required this.status,
    required this.rank,
    this.isSaved = false,
    this.createdAt,
    this.updatedAt,
  });

  factory VideoVocabularyModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$VideoVocabularyModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$VideoVocabularyModelToJson(this);
  }
}

@JsonSerializable()
class VideoVocabulariesResponse {
  final List<VideoVocabularyModel> data;

  const VideoVocabulariesResponse({
    required this.data,
  });

  factory VideoVocabulariesResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$VideoVocabulariesResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$VideoVocabulariesResponseToJson(this);
  }
}