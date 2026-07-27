import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/profile/profile.dart';

class WeeklyActivityCard extends StatelessWidget {
  final List<WeeklyActivityItem> activities;
  final int totalMinutes;
  final int percentageChange;

  const WeeklyActivityCard({
    super.key,
    required this.activities,
    required this.totalMinutes,
    required this.percentageChange,
  });

  @override
  Widget build(BuildContext context) {
    final maximumMinutes = activities.fold<int>(
      1,
          (maximum, item) {
        return item.minutes > maximum
            ? item.minutes
            : maximum;
      },
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: TtText(
                  'Weekly activity',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _PercentageBadge(
                percentage: percentageChange,
              ),
            ],
          ),
          10.gh,
          TtText(
            '$totalMinutes min this week',
            fontSize: 14,
            color: ColorUtils.greyTextColor,
          ),
          22.gh,
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                activities.length,
                    (index) {
                  final item = activities[index];

                  return Expanded(
                    child: WeeklyActivityBar(
                      item: item,
                      maximumMinutes: maximumMinutes,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WeeklyActivityBar extends StatelessWidget {
  final WeeklyActivityItem item;
  final int maximumMinutes;

  const WeeklyActivityBar({
    super.key,
    required this.item,
    required this.maximumMinutes,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedValue = maximumMinutes == 0
        ? 0.05
        : (item.minutes / maximumMinutes).clamp(
      0.05,
      1.0,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: normalizedValue,
                widthFactor: 0.55,
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: 7,
                  ),
                  decoration: BoxDecoration(
                    color: item.isCurrentDay
                        ? ColorUtils.secondaryColor
                        : ColorUtils.secondaryColor.withValues(
                      alpha: 0.38,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(7),
                    ),
                  ),
                ),
              ),
            ),
          ),
          12.gh,
          TtText(
            item.day,
            fontSize: 14,
            color: item.isCurrentDay
                ? ColorUtils.primaryColor
                : ColorUtils.greyTextColor,
            fontWeight: item.isCurrentDay
                ? FontWeight.bold
                : FontWeight.w400,
          ),
        ],
      ),
    );
  }
}

class _PercentageBadge extends StatelessWidget {
  final int percentage;

  const _PercentageBadge({
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = percentage >= 0;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: isPositive
            ? ColorUtils.secondaryBackgroundColor
            : const Color(0xFFFFEEEE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TtText(
        '${isPositive ? '+' : ''}$percentage% vs last week',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: isPositive
            ? ColorUtils.secondaryColor
            : Colors.red,
      ),
    );
  }
}

BoxDecoration get _cardDecoration {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: const Color(0xFFE1E5EA),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.035),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );
}