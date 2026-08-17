import 'package:json_annotation/json_annotation.dart';
import 'package:thuta_learn/features/learn/data/models/course_model.dart';

part 'module_content_model.g.dart';

@JsonSerializable()
class ModuleDetailResponse {
  final CourseModuleModel data;

  const ModuleDetailResponse({
    required this.data,
  });

  factory ModuleDetailResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$ModuleDetailResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ModuleDetailResponseToJson(this);
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ChapterModel {
  final String id;
  final String title;
  final String slug;
  final String? description;
  final String? videoLink;
  final String status;
  final int rank;
  final int videosCount;
  final String? createdAt;
  final String? updatedAt;

  const ChapterModel({
    required this.id,
    required this.title,
    required this.slug,
    this.description,
    this.videoLink,
    required this.status,
    required this.rank,
    required this.videosCount,
    this.createdAt,
    this.updatedAt,
  });

  factory ChapterModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$ChapterModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ChapterModelToJson(this);
  }
}

@JsonSerializable()
class ChapterListResponse {
  final List<ChapterModel> data;

  const ChapterListResponse({
    required this.data,
  });

  factory ChapterListResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$ChapterListResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ChapterListResponseToJson(this);
  }
}

@JsonSerializable()
class ChapterDetailResponse {
  final ChapterModel data;

  const ChapterDetailResponse({
    required this.data,
  });

  factory ChapterDetailResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$ChapterDetailResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ChapterDetailResponseToJson(this);
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ChapterVideoModel {
  final String id;
  final String title;
  final String slug;
  final String? thumbnail;
  final String? videoPath;
  final String? vimeoId;
  final String? playerUrl;
  final String? videoSource;
  final String status;
  final int rank;
  final bool isFree;
  final String? createdAt;
  final String? updatedAt;

  const ChapterVideoModel({
    required this.id,
    required this.title,
    required this.slug,
    this.thumbnail,
    this.videoPath,
    this.vimeoId,
    this.playerUrl,
    this.videoSource,
    required this.status,
    required this.rank,
    required this.isFree,
    this.createdAt,
    this.updatedAt,
  });

  factory ChapterVideoModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$ChapterVideoModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ChapterVideoModelToJson(this);
  }
}

@JsonSerializable()
class ChapterVideosResponse {
  final List<ChapterVideoModel> data;

  const ChapterVideosResponse({
    required this.data,
  });

  factory ChapterVideosResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$ChapterVideosResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ChapterVideosResponseToJson(this);
  }
}

@JsonSerializable()
class ChapterVideoDetailResponse {
  final ChapterVideoModel data;

  const ChapterVideoDetailResponse({
    required this.data,
  });

  factory ChapterVideoDetailResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$ChapterVideoDetailResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ChapterVideoDetailResponseToJson(this);
  }
}

@JsonSerializable(
  fieldRename: FieldRename.snake,
)
class ChapterResourceModel {
  final String id;
  final String title;
  final String slug;

  @JsonKey(name: 'file')
  final String fileUrl;

  final String fileType;
  final String status;
  final int rank;
  final bool isFree;
  final String? createdAt;
  final String? updatedAt;

  const ChapterResourceModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.fileUrl,
    required this.fileType,
    required this.status,
    required this.rank,
    required this.isFree,
    this.createdAt,
    this.updatedAt,
  });

  factory ChapterResourceModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$ChapterResourceModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ChapterResourceModelToJson(this);
  }
}

@JsonSerializable()
class ChapterResourcesResponse {
  final List<ChapterResourceModel> data;

  const ChapterResourcesResponse({
    required this.data,
  });

  factory ChapterResourcesResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$ChapterResourcesResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ChapterResourcesResponseToJson(this);
  }
}

@JsonSerializable()
class ChapterResourceDetailResponse {
  final ChapterResourceModel data;

  const ChapterResourceDetailResponse({
    required this.data,
  });

  factory ChapterResourceDetailResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$ChapterResourceDetailResponseFromJson(
      json,
    );
  }

  Map<String, dynamic> toJson() {
    return _$ChapterResourceDetailResponseToJson(
      this,
    );
  }
}

@JsonSerializable(
  fieldRename: FieldRename.snake,
)
class ChapterQuizModel {
  final String id;
  final String title;
  final String type;
  final String status;
  final int sortOrder;
  final int questionsCount;

  const ChapterQuizModel({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    required this.sortOrder,
    required this.questionsCount,
  });

  factory ChapterQuizModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$ChapterQuizModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ChapterQuizModelToJson(this);
  }
}

@JsonSerializable()
class ChapterQuizzesResponse {
  final List<ChapterQuizModel> data;

  const ChapterQuizzesResponse({
    required this.data,
  });

  factory ChapterQuizzesResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$ChapterQuizzesResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ChapterQuizzesResponseToJson(this);
  }
}
