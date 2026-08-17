part of 'lesson_detail_bloc.dart';

enum LessonDetailStatus {
  initial,
  loading,
  success,
  failure,
}

class LessonDetailState {
  final LessonDetailStatus status;
  final ChapterVideoModel? video;
  final String? message;

  const LessonDetailState({
    this.status = LessonDetailStatus.initial,
    this.video,
    this.message,
  });

  bool get isLoading {
    return status == LessonDetailStatus.loading;
  }

  LessonDetailState copyWith({
    LessonDetailStatus? status,
    ChapterVideoModel? video,
    String? message,
    bool clearMessage = false,
  }) {
    return LessonDetailState(
      status: status ?? this.status,
      video: video ?? this.video,
      message: clearMessage
          ? null
          : message ?? this.message,
    );
  }
}