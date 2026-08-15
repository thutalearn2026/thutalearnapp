import 'package:json_annotation/json_annotation.dart';

part 'course_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CourseModel {
  final String id;
  final String title;
  final String slug;
  final String? image;
  final String? introThumbnail;
  final String? introVideo;
  final String? outline;
  final String? aboutProgram;
  final String? whoAttend;
  final String? price;
  final String? extendPrice;
  final String? discount;
  final String? originalPrice;
  final int rank;
  final String status;
  final String type;
  final bool assignment;
  final CourseCategoryModel? category;
  final CourseLevelModel? level;
  final CourseTeacherModel? teacher;
  final List<CourseModuleModel> modules;
  final String? createdAt;
  final String? updatedAt;

  const CourseModel({
    required this.id,
    required this.title,
    required this.slug,
    this.image,
    this.introThumbnail,
    this.introVideo,
    this.outline,
    this.aboutProgram,
    this.whoAttend,
    this.price,
    this.extendPrice,
    this.discount,
    this.originalPrice,
    required this.rank,
    required this.status,
    required this.type,
    required this.assignment,
    this.category,
    this.level,
    this.teacher,
    required this.modules,
    this.createdAt,
    this.updatedAt,
  });

  int get moduleCount => modules.length;

  int get chapterCount {
    return modules.fold<int>(
      0,
          (total, module) => total + module.chaptersCount,
    );
  }

  factory CourseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$CourseModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CourseModelToJson(this);
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CourseCategoryModel {
  final String id;
  final String title;
  final String slug;
  final String status;
  final int rank;

  const CourseCategoryModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.status,
    required this.rank,
  });

  factory CourseCategoryModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$CourseCategoryModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CourseCategoryModelToJson(this);
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CourseLevelModel {
  final String id;
  final String title;
  final String slug;
  final String status;
  final int rank;

  const CourseLevelModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.status,
    required this.rank,
  });

  factory CourseLevelModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$CourseLevelModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CourseLevelModelToJson(this);
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CourseTeacherModel {
  final String id;
  final String name;
  final String slug;
  final String? profile;
  final String? image;
  final String status;
  final int rank;

  const CourseTeacherModel({
    required this.id,
    required this.name,
    required this.slug,
    this.profile,
    this.image,
    required this.status,
    required this.rank,
  });

  factory CourseTeacherModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$CourseTeacherModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CourseTeacherModelToJson(this);
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CourseModuleModel {
  final String id;
  final String title;
  final String slug;
  final String status;
  final int rank;
  final int chaptersCount;
  final String? createdAt;
  final String? updatedAt;

  const CourseModuleModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.status,
    required this.rank,
    required this.chaptersCount,
    this.createdAt,
    this.updatedAt,
  });

  factory CourseModuleModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$CourseModuleModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CourseModuleModelToJson(this);
  }
}

@JsonSerializable()
class CoursesResponse {
  final List<CourseModel> data;
  final CoursePaginationLinks links;
  final CoursePaginationMeta meta;

  const CoursesResponse({
    required this.data,
    required this.links,
    required this.meta,
  });

  factory CoursesResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$CoursesResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CoursesResponseToJson(this);
  }
}

@JsonSerializable()
class CoursePaginationLinks {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  const CoursePaginationLinks({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory CoursePaginationLinks.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$CoursePaginationLinksFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CoursePaginationLinksToJson(this);
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CoursePaginationMeta {
  final int currentPage;
  final int? from;
  final int lastPage;
  final String path;
  final int perPage;
  final int? to;
  final int total;

  const CoursePaginationMeta({
    required this.currentPage,
    this.from,
    required this.lastPage,
    required this.path,
    required this.perPage,
    this.to,
    required this.total,
  });

  factory CoursePaginationMeta.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$CoursePaginationMetaFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CoursePaginationMetaToJson(this);
  }
}

@JsonSerializable()
class CourseDetailResponse {
  final CourseModel data;

  const CourseDetailResponse({
    required this.data,
  });

  factory CourseDetailResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$CourseDetailResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CourseDetailResponseToJson(this);
  }
}

@JsonSerializable()
class CourseModulesResponse {
  final List<CourseModuleModel> data;

  const CourseModulesResponse({
    required this.data,
  });

  factory CourseModulesResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return _$CourseModulesResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CourseModulesResponseToJson(this);
  }
}