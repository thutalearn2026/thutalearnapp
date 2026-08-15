part of 'course_detail_bloc.dart';

@immutable
sealed class CourseDetailEvent {}

class OnGetCourseDetail extends CourseDetailEvent {
  final String courseId;

  OnGetCourseDetail({
    required this.courseId,
  });
}