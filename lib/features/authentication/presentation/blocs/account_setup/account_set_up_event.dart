part of 'account_set_up_bloc.dart';

@immutable
sealed class AccountSetUpEvent {}

class OnGetOnboardingOptions extends AccountSetUpEvent {}

class OnChooseLearningReason extends AccountSetUpEvent {
  final OnboardingOptionModel learningReason;

  OnChooseLearningReason(
      this.learningReason,
      );
}

class OnChooseCurrentLevel extends AccountSetUpEvent {
  final OnboardingOptionModel currentLevel;

  OnChooseCurrentLevel(
      this.currentLevel,
      );
}

class OnChooseDailyGoal extends AccountSetUpEvent {
  final OnboardingOptionModel dailyGoal;

  OnChooseDailyGoal(
      this.dailyGoal,
      );
}

class OnSubmitOnboardingPreferences
    extends AccountSetUpEvent {}

class OnSkipAccountSetUp extends AccountSetUpEvent {}

class OnBack extends AccountSetUpEvent {}