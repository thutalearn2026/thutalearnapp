// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_vocabulary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoVocabularyModel _$VideoVocabularyModelFromJson(
  Map<String, dynamic> json,
) => VideoVocabularyModel(
  id: json['id'] as String,
  word: json['word'] as String,
  definition: json['definition'] as String?,
  example: json['example'] as String?,
  pronunciation: json['pronunciation'] as String?,
  image: json['image'] as String?,
  status: json['status'] as String,
  rank: (json['rank'] as num).toInt(),
  isSaved: json['is_saved'] as bool? ?? false,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$VideoVocabularyModelToJson(
  VideoVocabularyModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'word': instance.word,
  'definition': instance.definition,
  'example': instance.example,
  'pronunciation': instance.pronunciation,
  'image': instance.image,
  'status': instance.status,
  'rank': instance.rank,
  'is_saved': instance.isSaved,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

VideoVocabulariesResponse _$VideoVocabulariesResponseFromJson(
  Map<String, dynamic> json,
) => VideoVocabulariesResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => VideoVocabularyModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$VideoVocabulariesResponseToJson(
  VideoVocabulariesResponse instance,
) => <String, dynamic>{'data': instance.data};
