import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/onboarding/onboarding.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<OnboardingBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<OnboardingBloc, OnboardingState>(
            listener: (context, state) {
              if(state.onboardingStatus == OnboardingStatus.skip) {
                context.push(Routes.login);
              }
            },
          ),
        ],
        child: OnboardingBody(),
      ),
    );
  }
}

class OnboardingBody extends StatelessWidget {
  const OnboardingBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          OnboardingImagesSectionView(),
          Expanded(
            child: OnboardingContentSectionView(),
          ),
        ],
      ),
    );
  }
}

class OnboardingContentSectionView extends StatelessWidget {
  const OnboardingContentSectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OnboardingContentsPageView(),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: TtButton(
            onTap: () {
              context.read<OnboardingBloc>().add(OnTapNext());
            },
            child: TtText(
              StringUtils.continueLabel,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        4.gh,
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: TtButton(
            backgroundColor: Colors.white,
            onTap: () {
              context.read<OnboardingBloc>().add(OnTapSkip());
            },
            child: TtText(
              StringUtils.skip,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingContentsPageView extends StatelessWidget {
  const OnboardingContentsPageView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          height: 27.h,
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: state.contentController,
            children: [
              OnboardingContentView(
                image: ImageUtils.onboardingIcon1,
                title: StringUtils.onboardingTitle1,
                subtitle: StringUtils.onboardingSubtitle1,
                content: StringUtils.onboardingContent1,
              ),
              OnboardingContentView(
                image: ImageUtils.onboardingIcon2,
                title: StringUtils.onboardingTitle2,
                subtitle: StringUtils.onboardingSubtitle2,
                content: StringUtils.onboardingContent2,
              ),
              OnboardingContentView(
                image: ImageUtils.onboardingIcon3,
                title: StringUtils.onboardingTitle3,
                subtitle: StringUtils.onboardingSubtitle3,
                content: StringUtils.onboardingContent3,
              ),
            ],
          ),
        );
      },
    );
  }
}

class OnboardingImagesSectionView extends StatelessWidget {
  const OnboardingImagesSectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          height: 48.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: state.illustrationController,
                  children: [
                    OnboardingImagesFrameView(
                      onboardingGradientType: OnboardingGradientType.topToBottom,
                      image: ImageUtils.onboarding1,
                    ),
                    OnboardingImagesFrameView(
                      onboardingGradientType: OnboardingGradientType.bottomToTop,
                      image: ImageUtils.onboarding2,
                    ),
                    OnboardingImagesFrameView(
                      onboardingGradientType: OnboardingGradientType.noGradient,
                      image: ImageUtils.onboarding3,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CurvedBorderView(),
              ),
              Positioned(
                bottom: 44,
                child: AnimatedSmoothIndicator(
                  activeIndex: state.currentIndex ?? 0,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    activeDotColor: ColorUtils.primaryColor,
                    expansionFactor: 3,
                    dotWidth: 8,
                    dotHeight: 8,
                    dotColor: Color.fromRGBO(223, 228, 234, 1.0),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CurvedBorderView extends StatelessWidget {
  const CurvedBorderView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(48),
          topRight: Radius.circular(48),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: Offset(0, -3),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
    );
  }
}
