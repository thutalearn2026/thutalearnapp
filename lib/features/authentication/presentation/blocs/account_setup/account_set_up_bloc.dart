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
class AccountSetUpBloc extends Bloc<AccountSetUpEvent, AccountSetUpState> {
  AccountSetUpBloc()
    : super(
        AccountSetUpState(
          accountSetUpStatus: AccountSetUpStatus.initial,
          currentIndex: 0,
          accountSetUpController: PageController(),
          learningReasons: AppHelper().learningReasons,
          currentLevels: AppHelper().currentLevels,
          dailyGoals: AppHelper().dailyGoals,
        ),
      ) {
    on<OnChooseLearningReason>(_onChooseLearningReason);
    on<OnChooseCurrentLevel>(_onChooseCurrentLevel);
    on<OnChooseDailyGoal>(_onChooseDailyGoal);
    on<OnBack>(_onBack);
  }

  void _animateToPage(int pageIndex) {
    state.accountSetUpController?.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  Future<void> _onChooseLearningReason(
    OnChooseLearningReason event,
    Emitter<AccountSetUpState> emit,
  ) async {
    List<LearningReasonModel> learningReasons = state.learningReasons ?? [];
    learningReasons = learningReasons.map((lr) {
      lr.isSelected = false;
      if (lr.title == event.learningReasonModel?.title) {
        lr.isSelected = true;
      }
      return lr;
    }).toList();
    _animateToPage((state.currentIndex ?? 0) + 1);
    var newState = state.copyWith(
      accountSetUpStatus: AccountSetUpStatus.next,
      selectedLearningReason: event.learningReasonModel,
      learningReasons: learningReasons,
      currentIndex: (state.currentIndex ?? 0) + 1,
    );
    emit(newState);
  }

  Future<void> _onChooseCurrentLevel(
    OnChooseCurrentLevel event,
    Emitter<AccountSetUpState> emit,
  ) async {
    _animateToPage((state.currentIndex ?? 0) + 1);
    var newState = state.copyWith(
      accountSetUpStatus: AccountSetUpStatus.next,
      selectedCurrentLevel: event.currentLevelTitle,
      currentIndex: (state.currentIndex ?? 0) + 1,
    );
    emit(newState);
  }

  Future<void> _onChooseDailyGoal(
    OnChooseDailyGoal event,
    Emitter<AccountSetUpState> emit,
  ) async {
    var dailyGoalList = state.dailyGoals ?? [];
    dailyGoalList = dailyGoalList.map((dg) {
      dg.isSelected = false;
      if (event.dailyGoalModel?.min == dg.min) {
        dg.isSelected = true;
      }
      return dg;
    }).toList();
    var newState = state.copyWith(
      accountSetUpStatus: AccountSetUpStatus.skip,
      selectedDailyGoal: event.dailyGoalModel,
    );
    emit(newState);
  }

  Future<void> _onBack(
    OnBack event,
    Emitter<AccountSetUpState> emit,
  ) async {
    int currentIndex = state.currentIndex ?? 0;
    if(currentIndex > 0) {
      _animateToPage(currentIndex - 1);
      emit(state.copyWith(accountSetUpStatus: AccountSetUpStatus.prev, currentIndex: currentIndex - 1));
    } else {
      emit(state.copyWith(accountSetUpStatus: AccountSetUpStatus.back));
    }
  }
}
