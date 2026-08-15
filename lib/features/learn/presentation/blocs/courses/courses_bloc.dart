import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

part 'courses_event.dart';
part 'courses_state.dart';

@Injectable()
class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
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
    if (state.isLoading) return;

    emit(
      state.copyWith(
        status: CoursesStatus.loading,
        courses: const [],
        currentPage: 0,
        lastPage: 1,
        total: 0,
        isLoadingMore: false,
        clearMessage: true,
      ),
    );

    final result = await learnUseCase.getCourses(
      page: 1,
    );

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            status: CoursesStatus.failure,
            message: _failureMessage(failure),
          ),
        );
      },
          (response) {
        final courses = [...response.data]
          ..sort(
                (first, second) {
              return first.rank.compareTo(second.rank);
            },
          );

        emit(
          state.copyWith(
            status: CoursesStatus.success,
            courses: courses,
            currentPage: response.meta.currentPage,
            lastPage: response.meta.lastPage,
            total: response.meta.total,
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

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            isLoadingMore: false,
            message: _failureMessage(failure),
          ),
        );
      },
          (response) {
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
      return 'Please check your internet connection and try again.';
    }

    final message = failure.e?.toString();

    if (message == null || message.isEmpty) {
      return 'Unable to load courses.';
    }

    return message;
  }
}