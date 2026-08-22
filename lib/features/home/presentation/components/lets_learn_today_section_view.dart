import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/home/home.dart';

class LetsLearnTodaySectionView extends StatelessWidget {
  const LetsLearnTodaySectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return LetsLearnTodayFrame(
      child: Column(
        spacing: 16,
        children: [
          GreetingView(),
          PersonalStatsView(),
        ],
      ),
    );
  }
}

class PersonalStatsView extends StatelessWidget {
  const PersonalStatsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        PersonalStatItem(
          iconData: Icons.stairs_outlined,
          title: "L1",
          desc: "Current Level",
        ),
        PersonalStatItem(
          iconData: Icons.watch_later_outlined,
          title: "52min",
          desc: "Study Time",
        ),
        PersonalStatItem(
          iconData: Icons.calendar_today_outlined,
          title: "8",
          desc: "Day streak",
        ),
      ],
    );
  }
}

class PersonalStatItem extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String desc;

  const PersonalStatItem({
    super.key,
    required this.iconData,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: ColorUtils.highlightColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          spacing: 4,
          children: [
            Row(
              spacing: 4,
              children: [
                Icon(
                  iconData,
                  color: ColorUtils.secondaryColor,
                  size: 20,
                ),
                TtText(
                  title,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ],
            ),
            TtText(
              desc,
              color: Colors.white,
              fontSize: 11,
            ),
          ],
        ),
      ),
    );
  }
}

class GreetingView extends StatelessWidget {
  const GreetingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        Image.asset(
          ImageUtils.logoLight,
          width: 42,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              TtText(
                "Sawatdee, Sora",
                color: Colors.white,
              ),
              TtText(
                StringUtils.letsLearnForToday,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ],
          ),
        ),
        NotificationIcon(),
      ],
    );
  }
}

class LetsLearnTodayFrame extends StatelessWidget {
  final Widget child;

  const LetsLearnTodayFrame({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(29, 56, 92, 1.0),
            Color.fromRGBO(22, 48, 77, 1.0),
          ],
        ),
      ),
      child: child,
    );
  }
}
