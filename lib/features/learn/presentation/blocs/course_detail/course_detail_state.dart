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
  final String? message;

  const CourseDetailState({
    this.status = CourseDetailStatus.initial,
    this.course,
    this.modules = const [],
    this.message,
  });

  bool get isLoading {
    return status == CourseDetailStatus.loading;
  }

  CourseDetailState copyWith({
    CourseDetailStatus? status,
    CourseModel? course,
    List<CourseModuleModel>? modules,
    String? message,
    bool clearMessage = false,
  }) {
    return CourseDetailState(
      status: status ?? this.status,
      course: course ?? this.course,
      modules: modules ?? this.modules,
      message: clearMessage
          ? null
          : message ?? this.message,
    );
  }
}