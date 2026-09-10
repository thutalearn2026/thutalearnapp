part of 'account_set_up_bloc.dart';

enum AccountSetUpStatus {
  initial,
  next,
  previous,
  back,
  completed,
}

enum AccountSetUpLoadStatus {
  initial,
  loading,
  success,
  failure,
}

enum AccountSetUpSubmitStatus {
  initial,
  loading,
  success,
  failure,
}

class AccountSetUpState {
  final AccountSetUpStatus accountSetUpStatus;
  final AccountSetUpLoadStatus loadStatus;
  final AccountSetUpSubmitStatus submitStatus;

  final PageController accountSetUpController;
  final int currentIndex;

  final List<OnboardingOptionModel> learningReasons;
  final List<OnboardingOptionModel> currentLevels;
  final List<OnboardingOptionModel> dailyGoals;

  final OnboardingOptionModel? selectedLearningReason;
  final OnboardingOptionModel? selectedCurrentLevel;
  final OnboardingOptionModel? selectedDailyGoal;

  final String? message;

  const AccountSetUpState({
    required this.accountSetUpStatus,
    required this.loadStatus,
    required this.submitStatus,
    required this.accountSetUpController,
    required this.currentIndex,
    required this.learningReasons,
    required this.currentLevels,
    required this.dailyGoals,
    this.selectedLearningReason,
    this.selectedCurrentLevel,
    this.selectedDailyGoal,
    this.message,
  });

  bool get isLoadingOptions {
    return loadStatus == AccountSetUpLoadStatus.loading;
  }

  bool get isSubmitting {
    return submitStatus == AccountSetUpSubmitStatus.loading;
  }

  AccountSetUpState copyWith({
    AccountSetUpStatus? accountSetUpStatus,
    AccountSetUpLoadStatus? loadStatus,
    AccountSetUpSubmitStatus? submitStatus,
    PageController? accountSetUpController,
    int? currentIndex,
    List<OnboardingOptionModel>? learningReasons,
    List<OnboardingOptionModel>? currentLevels,
    List<OnboardingOptionModel>? dailyGoals,
    OnboardingOptionModel? selectedLearningReason,
    OnboardingOptionModel? selectedCurrentLevel,
    OnboardingOptionModel? selectedDailyGoal,
    String? message,
  }) {
    return AccountSetUpState(
      accountSetUpStatus: accountSetUpStatus ?? this.accountSetUpStatus,
      loadStatus: loadStatus ?? this.loadStatus,
      submitStatus: submitStatus ?? this.submitStatus,
      accountSetUpController: accountSetUpController ?? this.accountSetUpController,
      currentIndex: currentIndex ?? this.currentIndex,
      learningReasons: learningReasons ?? this.learningReasons,
      currentLevels: currentLevels ?? this.currentLevels,
      dailyGoals: dailyGoals ?? this.dailyGoals,
      selectedLearningReason: selectedLearningReason ?? this.selectedLearningReason,
      selectedCurrentLevel: selectedCurrentLevel ?? this.selectedCurrentLevel,
      selectedDailyGoal: selectedDailyGoal ?? this.selectedDailyGoal,
      message: message ?? this.message,
    );
  }
}
