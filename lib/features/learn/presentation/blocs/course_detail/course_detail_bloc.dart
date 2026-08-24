import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

part 'course_detail_event.dart';
part 'course_detail_state.dart';

@Injectable()
class CourseDetailBloc
    extends Bloc<CourseDetailEvent, CourseDetailState> {
  final LearnUseCase learnUseCase;

  CourseDetailBloc({
    required this.learnUseCase,
  }) : super(const CourseDetailState()) {
    on<OnGetCourseDetail>(_onGetCourseDetail);
  }

  Future<void> _onGetCourseDetail(
      OnGetCourseDetail event,
      Emitter<CourseDetailState> emit,
      ) async {
    if (state.isRefreshing) {
      return;
    }

    final cachedSnapshot =
    await learnUseCase.getCachedCourseDetail(
      courseId: event.courseId,
    );

    final visibleCourse =
        cachedSnapshot?.course ?? state.course;

    final visibleModules =
        cachedSnapshot?.modules ?? state.modules;

    final hasCachedData = visibleCourse != null;

    emit(
      state.copyWith(
        status: hasCachedData
            ? CourseDetailStatus.success
            : CourseDetailStatus.loading,
        course: visibleCourse,
        modules: visibleModules,
        isRefreshing: true,
        clearMessage: true,
      ),
    );

    // Start both API requests concurrently.
    final courseFuture =
    learnUseCase.getCourseDetail(
      courseId: event.courseId,
    );

    final modulesFuture =
    learnUseCase.getCourseModules(
      courseId: event.courseId,
    );

    final courseResult = await courseFuture;
    final modulesResult = await modulesFuture;

    Failure? requestFailure;
    CourseModel? remoteCourse;
    List<CourseModuleModel>? remoteModules;

    courseResult.fold(
          (failure) {
        requestFailure = failure;
      },
          (response) {
        remoteCourse = response.data;
      },
    );

    modulesResult.fold(
          (failure) {
        requestFailure ??= failure;
      },
          (response) {
        remoteModules = [...response.data]
          ..sort(
                (first, second) {
              return first.rank.compareTo(second.rank);
            },
          );
      },
    );

    // Do not partially update the cache. Both responses
    // must succeed before the snapshot is replaced.
    if (requestFailure != null ||
        remoteCourse == null ||
        remoteModules == null) {
      emit(
        state.copyWith(
          status: hasCachedData
              ? CourseDetailStatus.success
              : CourseDetailStatus.failure,
          course: visibleCourse,
          modules: visibleModules,
          isRefreshing: false,
          message: _failureMessage(
            requestFailure,
            hasCachedData: hasCachedData,
          ),
        ),
      );

      return;
    }

    final snapshot = CourseDetailCacheSnapshot(
      course: remoteCourse!,
      modules: remoteModules!,
      cachedAt: DateTime.now(),
    );

    await learnUseCase.saveCourseDetailCache(
      snapshot,
    );

    emit(
      state.copyWith(
        status: CourseDetailStatus.success,
        course: remoteCourse,
        modules: remoteModules,
        isRefreshing: false,
        clearMessage: true,
      ),
    );
  }

  String _failureMessage(
      Failure? failure, {
        required bool hasCachedData,
      }) {
    if (failure is ConnectionFailure) {
      return hasCachedData
          ? 'You are offline. Showing the saved course.'
          : 'Please check your internet connection and try again.';
    }

    final message = failure?.e?.toString();

    if (message == null || message.trim().isEmpty) {
      return hasCachedData
          ? 'Unable to refresh this course. Showing saved data.'
          : 'Unable to load course details.';
    }

    return message;
  }
}