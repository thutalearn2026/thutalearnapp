import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';

class AccountSetUpPage extends StatelessWidget {
  const AccountSetUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}

class AccSetUpPageView extends StatelessWidget {
  const AccSetUpPageView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        LearningReasonSectionView(),
        CurrentLevelSectionView(),
        DailyGoalSectionView(),
      ],
    );
  }
}

class AccSetUpProgressSectionView extends StatelessWidget {
  const AccSetUpProgressSectionView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        spacing: 12,
        children: List.generate(
          3,
          (index) {
            return Expanded(
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: ColorUtils.progressBackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            );
          },
        ),
      ),
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
          context.pop();
        },
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.black,
        ),
      ),
      title: TtText(
        "Step 1 of 3",
        fontSize: 14,
        color: Colors.black,
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
