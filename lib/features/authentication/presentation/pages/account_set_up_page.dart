import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';

class AccountSetUpPage extends StatelessWidget {
  const AccountSetUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AccountSetUpBloc>()..add(OnGetOnboardingOptions()),
      child: BlocListener<AccountSetUpBloc, AccountSetUpState>(
        listenWhen: (previous, current) {
          return previous.accountSetUpStatus != current.accountSetUpStatus ||
              previous.submitStatus != current.submitStatus;
        },
        listener: (context, state) {
          if (state.accountSetUpStatus == AccountSetUpStatus.back) {
            context.pop();
            return;
          }

          if (state.submitStatus == AccountSetUpSubmitStatus.failure) {
            context.showSnackBar(
              state.message ?? 'Unable to save account setup.',
              snackBarType: SnackBarType.error,
            );
            return;
          }

          if (state.submitStatus == AccountSetUpSubmitStatus.success) {
            // Avoid showing a snackbar immediately before
            // navigation because that can produce duplicate
            // SnackBar Hero errors.
            context.go(Routes.bottomNav);
          }
        },
        child: const _AccountSetUpContent(),
      ),
    );
  }
}

class _AccountSetUpContent extends StatelessWidget {
  const _AccountSetUpContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountSetUpBloc, AccountSetUpState>(
      buildWhen: (previous, current) {
        return previous.loadStatus != current.loadStatus;
      },
      builder: (context, state) {
        switch (state.loadStatus) {
          case AccountSetUpLoadStatus.initial:
          case AccountSetUpLoadStatus.loading:
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(
                  color: ColorUtils.secondaryColor,
                ),
              ),
            );

          case AccountSetUpLoadStatus.failure:
            return _AccountSetUpErrorView(
              message: state.message ?? 'Unable to load account setup options.',
              onRetry: () {
                context.read<AccountSetUpBloc>().add(
                  OnGetOnboardingOptions(),
                );
              },
            );

          case AccountSetUpLoadStatus.success:
            return const AccountSetUpBody();
        }
      },
    );
  }
}

class AccountSetUpBody extends StatelessWidget {
  const AccountSetUpBody({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const AccountSetUpAppBar(),
        body: Column(
          children: [
            8.gh,
            const AccSetUpProgressSectionView(),
            8.gh,
            const Expanded(
              child: AccSetUpPageView(),
            ),
          ],
        ),
      ),
    );
  }
}

class AccSetUpPageView extends StatelessWidget {
  const AccSetUpPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AccountSetUpBloc, AccountSetUpState, PageController>(
      selector: (state) {
        return state.accountSetUpController;
      },
      builder: (context, pageController) {
        return PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            LearningReasonSectionView(),
            CurrentLevelsSectionView(),
            DailyGoalSectionView(),
          ],
        );
      },
    );
  }
}

class AccSetUpProgressSectionView extends StatelessWidget {
  const AccSetUpProgressSectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AccountSetUpBloc, AccountSetUpState, int>(
      selector: (state) {
        return state.currentIndex;
      },
      builder: (context, currentIndex) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            spacing: 12,
            children: List.generate(
              3,
              (index) {
                return Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 8,
                    decoration: BoxDecoration(
                      color: currentIndex >= index
                          ? ColorUtils.secondaryColor
                          : ColorUtils.progressBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class AccountSetUpAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AccountSetUpAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          HapticFeedback.mediumImpact();

          context.read<AccountSetUpBloc>().add(
            OnBack(),
          );
        },
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.black,
        ),
      ),
      title: BlocSelector<AccountSetUpBloc, AccountSetUpState, int>(
        selector: (state) {
          return state.currentIndex;
        },
        builder: (context, pageIndex) {
          return TtText(
            'Step ${pageIndex + 1} of 3',
            fontSize: 14,
            color: Colors.black,
          );
        },
      ),
      actions: [
        BlocSelector<AccountSetUpBloc, AccountSetUpState, bool>(
          selector: (state) {
            return state.isSubmitting;
          },
          builder: (context, isSubmitting) {
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: ColorUtils.secondaryColor,
                      ),
                    )
                  : TtZoomTap(
                      onTap: () {
                        context.read<AccountSetUpBloc>().add(
                          OnSkipAccountSetUp(),
                        );
                      },
                      child: const TtText(
                        'Skip',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(kToolbarHeight);
  }
}

class _AccountSetUpErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _AccountSetUpErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 52,
                color: Colors.red,
              ),
              16.gh,
              TtText(
                message,
                fontSize: 14,
                textAlign: TextAlign.center,
              ),
              20.gh,
              SizedBox(
                width: 150,
                child: TtButton(
                  onTap: onRetry,
                  child: const TtText(
                    'Try Again',
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
