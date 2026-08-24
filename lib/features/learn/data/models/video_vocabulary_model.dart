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

  VideoVocabularyModel copyWith({
    String? id,
    String? word,
    String? definition,
    String? example,
    String? pronunciation,
    String? image,
    String? status,
    int? rank,
    bool? isSaved,
    String? createdAt,
    String? updatedAt,
  }) {
    return VideoVocabularyModel(
      id: id ?? this.id,
      word: word ?? this.word,
      definition: definition ?? this.definition,
      example: example ?? this.example,
      pronunciation: pronunciation ?? this.pronunciation,
      image: image ?? this.image,
      status: status ?? this.status,
      rank: rank ?? this.rank,
      isSaved: isSaved ?? this.isSaved,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
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

@JsonSerializable()
class VocabularySaveResponse {
  final bool saved;

  const VocabularySaveResponse({
    required this.saved,
  });

  factory VocabularySaveResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$VocabularySaveResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$VocabularySaveResponseToJson(this);
  }
}