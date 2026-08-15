part of 'courses_bloc.dart';

@immutable
sealed class CoursesEvent {}

class OnGetCourses extends CoursesEvent {}

class OnLoadMoreCourses extends CoursesEvent {}