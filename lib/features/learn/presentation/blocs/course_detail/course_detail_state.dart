part of 'course_detail_bloc.dart';

enum CourseDetailStatus {
  initial,
  loading,
  success,
  failure,
}

enum WordOfTheDayStatus {
  initial,
  loading,
  success,
  failure,
}

class CourseDetailState {
  final CourseDetailStatus status;
  final CourseModel? course;
  final List<CourseModuleModel> modules;

  final WordOfTheDayStatus wordOfTheDayStatus;
  final WordOfTheDayModel? wordOfTheDay;

  final bool isRefreshing;
  final String? message;

  const CourseDetailState({
    this.status = CourseDetailStatus.initial,
    this.course,
    this.modules = const [],
    this.wordOfTheDayStatus = WordOfTheDayStatus.initial,
    this.wordOfTheDay,
    this.isRefreshing = false,
    this.message,
  });

  bool get isLoading {
    return (status == CourseDetailStatus.initial || status == CourseDetailStatus.loading) &&
        course == null;
  }

  bool get isShowingCachedData {
    return course != null && isRefreshing;
  }

  bool get isWordOfTheDayLoading {
    return wordOfTheDayStatus == WordOfTheDayStatus.loading && wordOfTheDay == null;
  }

  CourseDetailState copyWith({
    CourseDetailStatus? status,
    CourseModel? course,
    List<CourseModuleModel>? modules,
    WordOfTheDayStatus? wordOfTheDayStatus,
    WordOfTheDayModel? wordOfTheDay,
    bool? isRefreshing,
    String? message,
    bool clearMessage = false,
    bool clearWordOfTheDay = false,
  }) {
    return CourseDetailState(
      status: status ?? this.status,
      course: course ?? this.course,
      modules: modules ?? this.modules,
      wordOfTheDayStatus: wordOfTheDayStatus ?? this.wordOfTheDayStatus,
      wordOfTheDay: clearWordOfTheDay ? null : wordOfTheDay ?? this.wordOfTheDay,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      message: clearMessage ? null : message ?? this.message,
    );
  }
}
