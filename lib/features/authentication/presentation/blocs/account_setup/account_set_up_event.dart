part of 'account_set_up_bloc.dart';

sealed class AccountSetUpEvent {}

class OnChooseLearningReason extends AccountSetUpEvent {
  final LearningReasonModel? learningReasonModel;

  OnChooseLearningReason(this.learningReasonModel);
}

class OnChooseCurrentLevel extends AccountSetUpEvent {
  final String? currentLevelTitle;

  OnChooseCurrentLevel(this.currentLevelTitle);
}

class OnChooseDailyGoal extends AccountSetUpEvent {
  final DailyGoalModel? dailyGoalModel;

  OnChooseDailyGoal(this.dailyGoalModel);
}

class OnBack extends AccountSetUpEvent {

}