import 'package:json_annotation/json_annotation.dart';

part 'word_of_the_day_model.g.dart';

@JsonSerializable(
  fieldRename: FieldRename.snake,
)
class WordOfTheDayModel {
  final String id;
  final String word;
  final String romanization;
  final String meaning;

  const WordOfTheDayModel({
    required this.id,
    required this.word,
    required this.romanization,
    required this.meaning,
  });

  factory WordOfTheDayModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$WordOfTheDayModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$WordOfTheDayModelToJson(this);
  }
}

@JsonSerializable()
class WordOfTheDayResponse {
  final WordOfTheDayModel data;

  const WordOfTheDayResponse({
    required this.data,
  });

  factory WordOfTheDayResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$WordOfTheDayResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$WordOfTheDayResponseToJson(this);
  }
}