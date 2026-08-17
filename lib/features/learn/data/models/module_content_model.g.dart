// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module_content_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModuleDetailResponse _$ModuleDetailResponseFromJson(
  Map<String, dynamic> json,
) => ModuleDetailResponse(
  data: CourseModuleModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ModuleDetailResponseToJson(
  ModuleDetailResponse instance,
) => <String, dynamic>{'data': instance.data};

ChapterModel _$ChapterModelFromJson(Map<String, dynamic> json) => ChapterModel(
  id: json['id'] as String,
  title: json['title'] as String,
  slug: json['slug'] as String,
  description: json['description'] as String?,
  videoLink: json['video_link'] as String?,
  status: json['status'] as String,
  rank: (json['rank'] as num).toInt(),
  videosCount: (json['videos_count'] as num).toInt(),
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$ChapterModelToJson(ChapterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'description': instance.description,
      'video_link': instance.videoLink,
      'status': instance.status,
      'rank': instance.rank,
      'videos_count': instance.videosCount,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

ChapterListResponse _$ChapterListResponseFromJson(Map<String, dynamic> json) =>
    ChapterListResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => ChapterModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChapterListResponseToJson(
  ChapterListResponse instance,
) => <String, dynamic>{'data': instance.data};

ChapterDetailResponse _$ChapterDetailResponseFromJson(
  Map<String, dynamic> json,
) => ChapterDetailResponse(
  data: ChapterModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChapterDetailResponseToJson(
  ChapterDetailResponse instance,
) => <String, dynamic>{'data': instance.data};

ChapterVideoModel _$ChapterVideoModelFromJson(Map<String, dynamic> json) =>
    ChapterVideoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String,
      thumbnail: json['thumbnail'] as String?,
      videoPath: json['video_path'] as String?,
      vimeoId: json['vimeo_id'] as String?,
      playerUrl: json['player_url'] as String?,
      videoSource: json['video_source'] as String?,
      status: json['status'] as String,
      rank: (json['rank'] as num).toInt(),
      isFree: json['is_free'] as bool,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$ChapterVideoModelToJson(ChapterVideoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'thumbnail': instance.thumbnail,
      'video_path': instance.videoPath,
      'vimeo_id': instance.vimeoId,
      'player_url': instance.playerUrl,
      'video_source': instance.videoSource,
      'status': instance.status,
      'rank': instance.rank,
      'is_free': instance.isFree,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

ChapterVideosResponse _$ChapterVideosResponseFromJson(
  Map<String, dynamic> json,
) => ChapterVideosResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => ChapterVideoModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ChapterVideosResponseToJson(
  ChapterVideosResponse instance,
) => <String, dynamic>{'data': instance.data};

ChapterVideoDetailResponse _$ChapterVideoDetailResponseFromJson(
  Map<String, dynamic> json,
) => ChapterVideoDetailResponse(
  data: ChapterVideoModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChapterVideoDetailResponseToJson(
  ChapterVideoDetailResponse instance,
) => <String, dynamic>{'data': instance.data};

ChapterResourceModel _$ChapterResourceModelFromJson(
  Map<String, dynamic> json,
) => ChapterResourceModel(
  id: json['id'] as String,
  title: json['title'] as String,
  slug: json['slug'] as String,
  fileUrl: json['file'] as String,
  fileType: json['file_type'] as String,
  status: json['status'] as String,
  rank: (json['rank'] as num).toInt(),
  isFree: json['is_free'] as bool,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$ChapterResourceModelToJson(
  ChapterResourceModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'slug': instance.slug,
  'file': instance.fileUrl,
  'file_type': instance.fileType,
  'status': instance.status,
  'rank': instance.rank,
  'is_free': instance.isFree,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

ChapterResourcesResponse _$ChapterResourcesResponseFromJson(
  Map<String, dynamic> json,
) => ChapterResourcesResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => ChapterResourceModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ChapterResourcesResponseToJson(
  ChapterResourcesResponse instance,
) => <String, dynamic>{'data': instance.data};

ChapterResourceDetailResponse _$ChapterResourceDetailResponseFromJson(
  Map<String, dynamic> json,
) => ChapterResourceDetailResponse(
  data: ChapterResourceModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChapterResourceDetailResponseToJson(
  ChapterResourceDetailResponse instance,
) => <String, dynamic>{'data': instance.data};
