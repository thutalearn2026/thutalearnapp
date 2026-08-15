import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';

part 'account_set_up_event.dart';
part 'account_set_up_state.dart';

@Injectable()
class AccountSetUpBloc
    extends Bloc<AccountSetUpEvent, AccountSetUpState> {
  final AuthenticationUseCase authenticationUseCase;

  AccountSetUpBloc({
    required this.authenticationUseCase,
  }) : super(
    AccountSetUpState(
      accountSetUpStatus: AccountSetUpStatus.initial,
      loadStatus: AccountSetUpLoadStatus.initial,
      submitStatus: AccountSetUpSubmitStatus.initial,
      accountSetUpController: PageController(),
      currentIndex: 0,
      learningReasons: const [],
      currentLevels: const [],
      dailyGoals: const [],
    ),
  ) {
    on<OnGetOnboardingOptions>(_onGetOnboardingOptions);
    on<OnChooseLearningReason>(_onChooseLearningReason);
    on<OnChooseCurrentLevel>(_onChooseCurrentLevel);
    on<OnChooseDailyGoal>(_onChooseDailyGoal);
    on<OnSubmitOnboardingPreferences>(_onSubmitPreferences);
    on<OnSkipAccountSetUp>(_onSkip);
    on<OnBack>(_onBack);
  }

  Future<void> _onGetOnboardingOptions(
      OnGetOnboardingOptions event,
      Emitter<AccountSetUpState> emit,
      ) async {
    emit(
      state.copyWith(
        loadStatus: AccountSetUpLoadStatus.loading,
        message: '',
      ),
    );

    final result =
    await authenticationUseCase.getOnboardingOptions();

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            loadStatus: AccountSetUpLoadStatus.failure,
            message: _failureMessage(
              failure,
              fallback:
              'Unable to load account setup options.',
            ),
          ),
        );
      },
          (response) {
        final learningReasons = [
          ...response.data.learningReasons,
        ]..sort(
              (first, second) {
            return first.sortOrder.compareTo(
              second.sortOrder,
            );
          },
        );

        final currentLevels = [
          ...response.data.currentLevels,
        ]..sort(
              (first, second) {
            return first.sortOrder.compareTo(
              second.sortOrder,
            );
          },
        );

        final dailyGoals = [
          ...response.data.dailyGoals,
        ]..sort(
              (first, second) {
            return first.sortOrder.compareTo(
              second.sortOrder,
            );
          },
        );

        emit(
          state.copyWith(
            loadStatus: AccountSetUpLoadStatus.success,
            learningReasons: learningReasons,
            currentLevels: currentLevels,
            dailyGoals: dailyGoals,
            message: '',
          ),
        );
      },
    );
  }

  Future<void> _onChooseLearningReason(
      OnChooseLearningReason event,
      Emitter<AccountSetUpState> emit,
      ) async {
    const nextPage = 1;

    emit(
      state.copyWith(
        accountSetUpStatus: AccountSetUpStatus.next,
        selectedLearningReason: event.learningReason,
        currentIndex: nextPage,
      ),
    );

    _animateToPage(nextPage);
  }

  Future<void> _onChooseCurrentLevel(
      OnChooseCurrentLevel event,
      Emitter<AccountSetUpState> emit,
      ) async {
    const nextPage = 2;

    emit(
      state.copyWith(
        accountSetUpStatus: AccountSetUpStatus.next,
        selectedCurrentLevel: event.currentLevel,
        currentIndex: nextPage,
      ),
    );

    _animateToPage(nextPage);
  }

  Future<void> _onChooseDailyGoal(
      OnChooseDailyGoal event,
      Emitter<AccountSetUpState> emit,
      ) async {
    emit(
      state.copyWith(
        accountSetUpStatus: AccountSetUpStatus.next,
        selectedDailyGoal: event.dailyGoal,
      ),
    );
  }

  Future<void> _onSubmitPreferences(
      OnSubmitOnboardingPreferences event,
      Emitter<AccountSetUpState> emit,
      ) async {
    await _savePreferences(emit);
  }

  Future<void> _onSkip(
      OnSkipAccountSetUp event,
      Emitter<AccountSetUpState> emit,
      ) async {
    // Preserve any answers already selected.
    // Unanswered fields are sent as null.
    await _savePreferences(emit);
  }

  Future<void> _savePreferences(
      Emitter<AccountSetUpState> emit,
      ) async {
    if (state.isSubmitting) return;

    emit(
      state.copyWith(
        submitStatus: AccountSetUpSubmitStatus.loading,
        message: '',
      ),
    );

    final result =
    await authenticationUseCase.saveOnboardingPreferences(
      learningReason: state.selectedLearningReason?.key,
      currentLevel: state.selectedCurrentLevel?.key,
      dailyGoalMinutes: state.selectedDailyGoal?.value,
    );

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            submitStatus: AccountSetUpSubmitStatus.failure,
            message: _failureMessage(
              failure,
              fallback:
              'Unable to save your account setup.',
            ),
          ),
        );
      },
          (response) {
        emit(
          state.copyWith(
            accountSetUpStatus:
            AccountSetUpStatus.completed,
            submitStatus:
            AccountSetUpSubmitStatus.success,
            message: response.message,
          ),
        );
      },
    );
  }

  Future<void> _onBack(
      OnBack event,
      Emitter<AccountSetUpState> emit,
      ) async {
    if (state.isSubmitting) return;

    final currentIndex = state.currentIndex;

    if (currentIndex > 0) {
      final previousPage = currentIndex - 1;

      emit(
        state.copyWith(
          accountSetUpStatus:
          AccountSetUpStatus.previous,
          currentIndex: previousPage,
        ),
      );

      _animateToPage(previousPage);
      return;
    }

    emit(
      state.copyWith(
        accountSetUpStatus: AccountSetUpStatus.back,
      ),
    );
  }

  void _animateToPage(int pageIndex) {
    state.accountSetUpController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  String _failureMessage(
      Failure failure, {
        required String fallback,
      }) {
    if (failure is ConnectionFailure) {
      return 'Please check your internet connection and try again.';
    }

    final message = failure.e?.toString();

    if (message == null || message.isEmpty) {
      return fallback;
    }

    return message;
  }

  @override
  Future<void> close() {
    state.accountSetUpController.dispose();
    return super.close();
  }
}