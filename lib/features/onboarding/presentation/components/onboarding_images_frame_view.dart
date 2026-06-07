import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

class OnboardingImagesFrameView extends StatelessWidget {
  final OnboardingGradientType onboardingGradientType;
  final String image;

  const OnboardingImagesFrameView({
    super.key,
    required this.onboardingGradientType,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 36),
      decoration: BoxDecoration(
        color: onboardingGradientType == OnboardingGradientType.noGradient
            ? Colors.white
            : null,
        gradient: onboardingGradientType != OnboardingGradientType.noGradient
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: onboardingGradientType == OnboardingGradientType.topToBottom
                    ? [ColorUtils.onBoardingGradientGreen, Colors.white]
                    : [Colors.white, ColorUtils.onBoardingGradientGreen],
              )
            : null,
      ),
      child: Center(
        child: Container(
          child: Image.asset(
            image,
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}

enum OnboardingGradientType {
  topToBottom,
  bottomToTop,
  noGradient,
}
