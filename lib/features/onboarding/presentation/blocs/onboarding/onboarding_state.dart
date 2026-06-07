part of 'onboarding_bloc.dart';

enum OnboardingStatus {
  initial,
  next,
  skip,
}

class OnboardingState {
  OnboardingStatus onboardingStatus;
  int? currentIndex;
  PageController? illustrationController;
  PageController? contentController;

  OnboardingState({
    required this.onboardingStatus,
    this.currentIndex,
    this.illustrationController,
    this.contentController,
  });

  OnboardingState copyWith({
    required OnboardingStatus onboardingStatus,
    int? currentIndex,
    PageController? illustrationController,
    PageController? contentController,
  }) {
    return OnboardingState(
      onboardingStatus: onboardingStatus,
      currentIndex: currentIndex ?? this.currentIndex,
      illustrationController:
      illustrationController ?? this.illustrationController,
      contentController: contentController ?? this.contentController,
    );
  }
}
