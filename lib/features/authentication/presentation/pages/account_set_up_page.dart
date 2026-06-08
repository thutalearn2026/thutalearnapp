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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AccountSetUpBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AccountSetUpBloc, AccountSetUpState>(
            listener: (context, state) {
              /// Skip
              if (state.accountSetUpStatus == AccountSetUpStatus.skip) {
                context.showSnackBar("Account Set Up ပြီးပါပြီ။");
              }

              /// Back
              if (state.accountSetUpStatus == AccountSetUpStatus.back) {
                // context.showSnackBar("Back ပြန်ထွက်လိုက်ပါပြီ။");
                context.pop();
              }
            },
          ),
        ],
        child: AccountSetUpBody(),
      ),
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
        appBar: AccountSetUpAppBar(),
        body: Column(
          children: [
            8.gh,
            AccSetUpProgressSectionView(),
            8.gh,
            Expanded(
              child: AccSetUpPageView(),
            ),
          ],
        ),
      ),
    );
  }
}

class AccSetUpPageView extends StatelessWidget {
  const AccSetUpPageView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AccountSetUpBloc, AccountSetUpState, PageController?>(
      selector: (state) => state.accountSetUpController,
      builder: (context, pageController) {
        return PageView(
          controller: pageController,
          children: [
            LearningReasonSectionView(),
            CurrentLevelSectionView(),
            DailyGoalSectionView(),
          ],
        );
      },
    );
  }
}

class AccSetUpProgressSectionView extends StatelessWidget {
  const AccSetUpProgressSectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountSetUpBloc, AccountSetUpState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            spacing: 12,
            children: List.generate(
              3,
              (index) {
                return Expanded(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: 8,
                    decoration: BoxDecoration(
                      color: (state.currentIndex ?? 0) >= index
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
  const AccountSetUpAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          HapticFeedback.mediumImpact();
          context.read<AccountSetUpBloc>().add(OnBack());
        },
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.black,
        ),
      ),
      title: BlocSelector<AccountSetUpBloc, AccountSetUpState, int>(
        selector: (state) => state.currentIndex ?? 0,
        builder: (context, pageIndex) {
          return TtText(
            "Step ${pageIndex + 1} of 3",
            fontSize: 14,
            color: Colors.black,
          );
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: TtZoomTap(
            onTap: () {},
            child: TtText(
              "Skip",
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
