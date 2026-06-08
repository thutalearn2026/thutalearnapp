part of 'account_set_up_bloc.dart';

enum AccountSetUpStatus {
  initial,
  next,
  skip,
  prev,
  back,
}

class AccountSetUpState {
  AccountSetUpStatus accountSetUpStatus;
  PageController? accountSetUpController;
  int? currentIndex;
  List<LearningReasonModel>? learningReasons;
  List<CurrentLevelModel>? currentLevels;
  List<DailyGoalModel>? dailyGoals;
  LearningReasonModel? selectedLearningReason;
  String? selectedCurrentLevel;
  DailyGoalModel? selectedDailyGoal;

  AccountSetUpState({
    required this.accountSetUpStatus,
    this.accountSetUpController,
    this.currentIndex,
    this.learningReasons,
    this.currentLevels,
    this.dailyGoals,
    this.selectedLearningReason,
    this.selectedCurrentLevel,
    this.selectedDailyGoal,
  });

  AccountSetUpState copyWith({
    required AccountSetUpStatus accountSetUpStatus,
    PageController? accountSetUpController,
    int? currentIndex,
    List<LearningReasonModel>? learningReasons,
    List<CurrentLevelModel>? currentLevels,
    List<DailyGoalModel>? dailyGoals,
    LearningReasonModel? selectedLearningReason,
    String? selectedCurrentLevel,
    DailyGoalModel? selectedDailyGoal,
  }) {
    return AccountSetUpState(
      accountSetUpStatus: accountSetUpStatus,
      accountSetUpController: accountSetUpController ?? this.accountSetUpController,
      currentIndex: currentIndex ?? this.currentIndex,
      learningReasons: learningReasons ?? this.learningReasons,
      currentLevels: currentLevels ?? this.currentLevels,
      dailyGoals: dailyGoals ?? this.dailyGoals,
      selectedLearningReason: selectedLearningReason ?? this.selectedLearningReason,
      selectedCurrentLevel: selectedCurrentLevel ?? this.selectedCurrentLevel,
      selectedDailyGoal: selectedDailyGoal ?? this.selectedDailyGoal,
    );
  }
}
