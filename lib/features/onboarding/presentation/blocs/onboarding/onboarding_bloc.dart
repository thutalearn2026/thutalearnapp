import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

@Injectable()
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final int lastIndex = 2;

  OnboardingBloc()
    : super(
        OnboardingState(
          onboardingStatus: OnboardingStatus.initial,
          currentIndex: 0,
          illustrationController: PageController(),
          contentController: PageController(),
        ),
      ) {
    on<OnTapNext>(_onTapNext);
    on<OnTapSkip>(_onTapSkip);
  }

  Future<void> _onTapNext(OnTapNext event, Emitter<OnboardingState> emit) async {
    int currentIndex = state.currentIndex ?? 0;
    if (currentIndex < lastIndex) {
      state.illustrationController?.animateToPage(
        currentIndex + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      state.contentController?.animateToPage(
        currentIndex + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      emit(
        state.copyWith(
          onboardingStatus: OnboardingStatus.next,
          currentIndex: currentIndex + 1,
        ),
      );
    } else {
      add(OnTapSkip());
    }
  }

  Future<void> _onTapSkip(
    OnTapSkip event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(state.copyWith(onboardingStatus: OnboardingStatus.skip));
  }
}
