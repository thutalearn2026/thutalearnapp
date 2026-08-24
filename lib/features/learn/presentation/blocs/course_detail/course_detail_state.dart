part of 'course_detail_bloc.dart';

enum CourseDetailStatus {
  initial,
  loading,
  success,
  failure,
}

class CourseDetailState {
  final CourseDetailStatus status;
  final CourseModel? course;
  final List<CourseModuleModel> modules;
  final bool isRefreshing;
  final String? message;

  const CourseDetailState({
    this.status = CourseDetailStatus.initial,
    this.course,
    this.modules = const [],
    this.isRefreshing = false,
    this.message,
  });

  bool get isLoading {
    return (status == CourseDetailStatus.initial ||
        status == CourseDetailStatus.loading) &&
        course == null;
  }

  bool get isShowingCachedData {
    return course != null && isRefreshing;
  }

  CourseDetailState copyWith({
    CourseDetailStatus? status,
    CourseModel? course,
    List<CourseModuleModel>? modules,
    bool? isRefreshing,
    String? message,
    bool clearMessage = false,
  }) {
    return CourseDetailState(
      status: status ?? this.status,
      course: course ?? this.course,
      modules: modules ?? this.modules,
      isRefreshing:
      isRefreshing ?? this.isRefreshing,
      message:
      clearMessage ? null : message ?? this.message,
    );
  }
}