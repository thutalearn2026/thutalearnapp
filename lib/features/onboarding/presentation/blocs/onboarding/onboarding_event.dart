part of 'onboarding_bloc.dart';

sealed class OnboardingEvent {}

class OnTapNext extends OnboardingEvent {

}

class OnTapSkip extends OnboardingEvent {

}