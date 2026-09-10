part of 'courses_bloc.dart';

enum CoursesStatus {
  initial,
  loading,
  success,
  failure,
}

class CoursesState {
  final CoursesStatus status;
  final List<CourseModel> courses;
  final int currentPage;
  final int lastPage;
  final int total;
  final bool isRefreshing;
  final bool isLoadingMore;
  final String? message;

  const CoursesState({
    this.status = CoursesStatus.initial,
    this.courses = const [],
    this.currentPage = 0,
    this.lastPage = 1,
    this.total = 0,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.message,
  });

  bool get isLoading {
    return (status == CoursesStatus.initial ||
        status == CoursesStatus.loading) &&
        courses.isEmpty;
  }

  bool get hasMore {
    return currentPage < lastPage;
  }

  bool get isShowingCachedData {
    return courses.isNotEmpty && isRefreshing;
  }

  CoursesState copyWith({
    CoursesStatus? status,
    List<CourseModel>? courses,
    int? currentPage,
    int? lastPage,
    int? total,
    bool? isRefreshing,
    bool? isLoadingMore,
    String? message,
    bool clearMessage = false,
  }) {
    return CoursesState(
      status: status ?? this.status,
      courses: courses ?? this.courses,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore:
      isLoadingMore ?? this.isLoadingMore,
      message:
      clearMessage ? null : message ?? this.message,
    );
  }
}