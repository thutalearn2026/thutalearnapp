import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

part 'courses_event.dart';
part 'courses_state.dart';

@Injectable()
class CoursesBloc
    extends Bloc<CoursesEvent, CoursesState> {
  final LearnUseCase learnUseCase;

  CoursesBloc({
    required this.learnUseCase,
  }) : super(const CoursesState()) {
    on<OnGetCourses>(_onGetCourses);
    on<OnLoadMoreCourses>(_onLoadMoreCourses);
  }

  Future<void> _onGetCourses(
      OnGetCourses event,
      Emitter<CoursesState> emit,
      ) async {
    if (state.isRefreshing) {
      return;
    }

    final cachedSnapshot =
    await learnUseCase.getCachedCourses();

    final cachedCourses =
        cachedSnapshot?.courses ?? state.courses;

    final hasCachedCourses = cachedCourses.isNotEmpty;

    emit(
      state.copyWith(
        status: hasCachedCourses
            ? CoursesStatus.success
            : CoursesStatus.loading,
        courses: cachedCourses,
        currentPage:
        cachedSnapshot?.currentPage ??
            state.currentPage,
        lastPage:
        cachedSnapshot?.lastPage ?? state.lastPage,
        total:
        cachedSnapshot?.total ??
            (state.total > 0
                ? state.total
                : cachedCourses.length),
        isRefreshing: true,
        isLoadingMore: false,
        clearMessage: true,
      ),
    );

    final result = await learnUseCase.getCourses(
      page: 1,
    );

    await result.fold<Future<void>>(
          (failure) async {
        emit(
          state.copyWith(
            status: hasCachedCourses
                ? CoursesStatus.success
                : CoursesStatus.failure,
            isRefreshing: false,
            message: _failureMessage(failure),
          ),
        );
      },
          (response) async {
        final courses = [...response.data]
          ..sort(
                (first, second) {
              return first.rank.compareTo(second.rank);
            },
          );

        final snapshot = CoursesCacheSnapshot(
          courses: courses,
          currentPage: response.meta.currentPage,
          lastPage: response.meta.lastPage,
          total: response.meta.total,
          cachedAt: DateTime.now(),
        );

        // Replace the old cache only after the API
        // request has completed successfully.
        await learnUseCase.saveCoursesCache(
          snapshot,
        );

        emit(
          state.copyWith(
            status: CoursesStatus.success,
            courses: courses,
            currentPage: response.meta.currentPage,
            lastPage: response.meta.lastPage,
            total: response.meta.total,
            isRefreshing: false,
            isLoadingMore: false,
            clearMessage: true,
          ),
        );
      },
    );
  }

  Future<void> _onLoadMoreCourses(
      OnLoadMoreCourses event,
      Emitter<CoursesState> emit,
      ) async {
    if (state.status != CoursesStatus.success ||
        state.isRefreshing ||
        state.isLoadingMore ||
        !state.hasMore) {
      return;
    }

    emit(
      state.copyWith(
        isLoadingMore: true,
        clearMessage: true,
      ),
    );

    final nextPage = state.currentPage + 1;

    final result = await learnUseCase.getCourses(
      page: nextPage,
    );

    await result.fold<Future<void>>(
          (failure) async {
        emit(
          state.copyWith(
            isLoadingMore: false,
            message: _failureMessage(failure),
          ),
        );
      },
          (response) async {
        final courseMap = <String, CourseModel>{
          for (final course in state.courses)
            course.id: course,
          for (final course in response.data)
            course.id: course,
        };

        final courses = courseMap.values.toList()
          ..sort(
                (first, second) {
              return first.rank.compareTo(second.rank);
            },
          );

        final snapshot = CoursesCacheSnapshot(
          courses: courses,
          currentPage: response.meta.currentPage,
          lastPage: response.meta.lastPage,
          total: response.meta.total,
          cachedAt: DateTime.now(),
        );

        await learnUseCase.saveCoursesCache(
          snapshot,
        );

        emit(
          state.copyWith(
            status: CoursesStatus.success,
            courses: courses,
            currentPage: response.meta.currentPage,
            lastPage: response.meta.lastPage,
            total: response.meta.total,
            isLoadingMore: false,
            clearMessage: true,
          ),
        );
      },
    );
  }

  String _failureMessage(Failure failure) {
    if (failure is ConnectionFailure) {
      return 'You are offline. Showing your saved courses.';
    }

    final message = failure.e?.toString();

    if (message == null || message.trim().isEmpty) {
      return 'Unable to update courses. Showing saved data.';
    }

    return message;
  }
}