// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_of_the_day_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordOfTheDayModel _$WordOfTheDayModelFromJson(Map<String, dynamic> json) =>
    WordOfTheDayModel(
      id: json['id'] as String,
      word: json['word'] as String,
      romanization: json['romanization'] as String,
      meaning: json['meaning'] as String,
    );

Map<String, dynamic> _$WordOfTheDayModelToJson(WordOfTheDayModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'word': instance.word,
      'romanization': instance.romanization,
      'meaning': instance.meaning,
    };

WordOfTheDayResponse _$WordOfTheDayResponseFromJson(
  Map<String, dynamic> json,
) => WordOfTheDayResponse(
  data: WordOfTheDayModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$WordOfTheDayResponseToJson(
  WordOfTheDayResponse instance,
) => <String, dynamic>{'data': instance.data};
