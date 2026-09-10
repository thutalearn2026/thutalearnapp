import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

class LearnModuleView extends StatelessWidget {
  final LearnModuleItem item;
  final bool isFirst;
  final bool isLast;
  final VoidCallback? onTap;

  const LearnModuleView({
    super.key,
    required this.item,
    required this.isFirst,
    required this.isLast,
    this.onTap,
  });

  bool get _isLocked => item.status == LearnModuleStatus.locked;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 26,
            child: _TimelineIndicator(
              status: item.status,
              isFirst: isFirst,
              isLast: isLast,
            ),
          ),
          8.gw,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TtZoomTap(
                onTap: () {
                  if (!_isLocked) {
                    onTap?.call();
                  }
                },
                child: _ModuleCard(item: item),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineIndicator extends StatelessWidget {
  final LearnModuleStatus status;
  final bool isFirst;
  final bool isLast;

  const _TimelineIndicator({
    required this.status,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: 1,
            color: isFirst ? Colors.transparent : const Color(0xFFD9DEE5),
          ),
        ),
        _StatusIcon(status: status),
        Expanded(
          child: Container(
            width: 1,
            color: isLast ? Colors.transparent : const Color(0xFFD9DEE5),
          ),
        ),
      ],
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final LearnModuleStatus status;

  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case LearnModuleStatus.completed:
        return Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: ColorUtils.primaryColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.done_all,
            size: 13,
            color: Colors.white,
          ),
        );

      case LearnModuleStatus.inProgress:
        return Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: ColorUtils.secondaryColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.done_rounded,
            size: 13,
            color: Colors.white,
          ),
        );

      case LearnModuleStatus.locked:
        return Container(
          width: 20,
          height: 20 ,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFD5DDE7),
            ),
          ),
          child: const Icon(
            Icons.lock_outline_rounded,
            size: 13,
            color: ColorUtils.primaryColor,
          ),
        );
    }
  }
}

class _ModuleCard extends StatelessWidget {
  final LearnModuleItem item;

  const _ModuleCard({required this.item});

  bool get _isLocked => item.status == LearnModuleStatus.locked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFFE8EBEF),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_isLocked) ...[
            _ModuleStatusSection(item: item),
            8.gh,
          ],
          TtText(
            item.title,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _isLocked
                ? const Color(0xFF7890AC)
                : Colors.black,
          ),
          7.gh,
          TtText(
            item.description,
            fontSize: 14,
            height: 1.35,
            color: _isLocked
                ? const Color(0xFF8294A9)
                : const Color(0xFF333B44),
          ),
        ],
      ),
    );
  }
}

class _ModuleStatusSection extends StatelessWidget {
  final LearnModuleItem item;

  const _ModuleStatusSection({required this.item});

  @override
  Widget build(BuildContext context) {
    if (item.status == LearnModuleStatus.completed) {
      return Row(
        children: [
          const _StatusBadge(
            label: 'Completed',
            foregroundColor: ColorUtils.primaryColor,
            backgroundColor: Color(0xFFEFF3F8),
          ),
          8.gw,
          if (item.quizPassed)
            const _StatusBadge(
              label: 'Quiz Passed',
              foregroundColor: Color(0xFF21A965),
              backgroundColor: Color(0xFFE7F8ED),
            ),
        ],
      );
    }

    return Row(
      children: [
        const _StatusBadge(
          label: 'In Progress',
          foregroundColor: Color(0xFFFF7452),
          backgroundColor: Color(0xFFFFEEE9),
        ),
        10.gw,
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: item.progress,
              minHeight: 4,
              backgroundColor: const Color(0xFFE6E9ED),
              valueColor: const AlwaysStoppedAnimation<Color>(
                ColorUtils.secondaryColor,
              ),
            ),
          ),
        ),
        8.gw,
        TtText(
          '${(item.progress * 100).round()}% complete',
          fontSize: 12,
          color: ColorUtils.greyTextColor,
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color foregroundColor;
  final Color backgroundColor;

  const _StatusBadge({
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TtText(
        label,
        color: foregroundColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}