// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseModel _$CourseModelFromJson(Map<String, dynamic> json) => CourseModel(
  id: json['id'] as String,
  title: json['title'] as String,
  slug: json['slug'] as String,
  image: json['image'] as String?,
  introThumbnail: json['intro_thumbnail'] as String?,
  introVideo: json['intro_video'] as String?,
  outline: json['outline'] as String?,
  aboutProgram: json['about_program'] as String?,
  whoAttend: json['who_attend'] as String?,
  price: json['price'] as String?,
  extendPrice: json['extend_price'] as String?,
  discount: json['discount'] as String?,
  originalPrice: json['original_price'] as String?,
  rank: (json['rank'] as num).toInt(),
  status: json['status'] as String,
  type: json['type'] as String,
  assignment: json['assignment'] as bool,
  category: json['category'] == null
      ? null
      : CourseCategoryModel.fromJson(json['category'] as Map<String, dynamic>),
  level: json['level'] == null
      ? null
      : CourseLevelModel.fromJson(json['level'] as Map<String, dynamic>),
  teacher: json['teacher'] == null
      ? null
      : CourseTeacherModel.fromJson(json['teacher'] as Map<String, dynamic>),
  modules: (json['modules'] as List<dynamic>)
      .map((e) => CourseModuleModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$CourseModelToJson(CourseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'image': instance.image,
      'intro_thumbnail': instance.introThumbnail,
      'intro_video': instance.introVideo,
      'outline': instance.outline,
      'about_program': instance.aboutProgram,
      'who_attend': instance.whoAttend,
      'price': instance.price,
      'extend_price': instance.extendPrice,
      'discount': instance.discount,
      'original_price': instance.originalPrice,
      'rank': instance.rank,
      'status': instance.status,
      'type': instance.type,
      'assignment': instance.assignment,
      'category': instance.category,
      'level': instance.level,
      'teacher': instance.teacher,
      'modules': instance.modules,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

CourseCategoryModel _$CourseCategoryModelFromJson(Map<String, dynamic> json) =>
    CourseCategoryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String,
      status: json['status'] as String,
      rank: (json['rank'] as num).toInt(),
    );

Map<String, dynamic> _$CourseCategoryModelToJson(
  CourseCategoryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'slug': instance.slug,
  'status': instance.status,
  'rank': instance.rank,
};

CourseLevelModel _$CourseLevelModelFromJson(Map<String, dynamic> json) =>
    CourseLevelModel(
      id: json['id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String,
      status: json['status'] as String,
      rank: (json['rank'] as num).toInt(),
    );

Map<String, dynamic> _$CourseLevelModelToJson(CourseLevelModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'status': instance.status,
      'rank': instance.rank,
    };

CourseTeacherModel _$CourseTeacherModelFromJson(Map<String, dynamic> json) =>
    CourseTeacherModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      profile: json['profile'] as String?,
      image: json['image'] as String?,
      status: json['status'] as String,
      rank: (json['rank'] as num).toInt(),
    );

Map<String, dynamic> _$CourseTeacherModelToJson(CourseTeacherModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'profile': instance.profile,
      'image': instance.image,
      'status': instance.status,
      'rank': instance.rank,
    };

CourseModuleModel _$CourseModuleModelFromJson(Map<String, dynamic> json) =>
    CourseModuleModel(
      id: json['id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String,
      status: json['status'] as String,
      rank: (json['rank'] as num).toInt(),
      chaptersCount: (json['chapters_count'] as num).toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$CourseModuleModelToJson(CourseModuleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'status': instance.status,
      'rank': instance.rank,
      'chapters_count': instance.chaptersCount,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

CoursesResponse _$CoursesResponseFromJson(Map<String, dynamic> json) =>
    CoursesResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      links: CoursePaginationLinks.fromJson(
        json['links'] as Map<String, dynamic>,
      ),
      meta: CoursePaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CoursesResponseToJson(CoursesResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'links': instance.links,
      'meta': instance.meta,
    };

CoursePaginationLinks _$CoursePaginationLinksFromJson(
  Map<String, dynamic> json,
) => CoursePaginationLinks(
  first: json['first'] as String?,
  last: json['last'] as String?,
  prev: json['prev'] as String?,
  next: json['next'] as String?,
);

Map<String, dynamic> _$CoursePaginationLinksToJson(
  CoursePaginationLinks instance,
) => <String, dynamic>{
  'first': instance.first,
  'last': instance.last,
  'prev': instance.prev,
  'next': instance.next,
};

CoursePaginationMeta _$CoursePaginationMetaFromJson(
  Map<String, dynamic> json,
) => CoursePaginationMeta(
  currentPage: (json['current_page'] as num).toInt(),
  from: (json['from'] as num?)?.toInt(),
  lastPage: (json['last_page'] as num).toInt(),
  path: json['path'] as String,
  perPage: (json['per_page'] as num).toInt(),
  to: (json['to'] as num?)?.toInt(),
  total: (json['total'] as num).toInt(),
);

Map<String, dynamic> _$CoursePaginationMetaToJson(
  CoursePaginationMeta instance,
) => <String, dynamic>{
  'current_page': instance.currentPage,
  'from': instance.from,
  'last_page': instance.lastPage,
  'path': instance.path,
  'per_page': instance.perPage,
  'to': instance.to,
  'total': instance.total,
};

CourseDetailResponse _$CourseDetailResponseFromJson(
  Map<String, dynamic> json,
) => CourseDetailResponse(
  data: CourseModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CourseDetailResponseToJson(
  CourseDetailResponse instance,
) => <String, dynamic>{'data': instance.data};

CourseModulesResponse _$CourseModulesResponseFromJson(
  Map<String, dynamic> json,
) => CourseModulesResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => CourseModuleModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CourseModulesResponseToJson(
  CourseModulesResponse instance,
) => <String, dynamic>{'data': instance.data};
