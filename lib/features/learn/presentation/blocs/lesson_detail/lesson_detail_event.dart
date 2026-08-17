part of 'lesson_detail_bloc.dart';

@immutable
sealed class LessonDetailEvent {}

class OnGetLessonDetail extends LessonDetailEvent {
  final String chapterId;
  final String videoId;

  OnGetLessonDetail({
    required this.chapterId,
    required this.videoId,
  });
}