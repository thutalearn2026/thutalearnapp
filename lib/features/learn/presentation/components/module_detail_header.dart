import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/learn/learn.dart';

class ModuleDetailHeader extends StatelessWidget {
  final LearnModuleItem module;
  final int videoCount;
  final String? teacherName;
  final VoidCallback onResume;
  final String secondaryActionLabel;
  final IconData secondaryActionIcon;
  final VoidCallback onSecondaryAction;

  const ModuleDetailHeader({
    super.key,
    required this.module,
    required this.videoCount,
    this.teacherName,
    required this.onResume,
    required this.secondaryActionLabel,
    required this.secondaryActionIcon,
    required this.onSecondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: ColorUtils.primaryColor,
      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ModuleBadge(
            moduleNumber: module.moduleNumber,
          ),
          20.gh,
          TtText(
            module.title,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          16.gh,

          // Progress is kept at its current value until
          // learner progress is returned by the API.
          _ModuleProgressView(
            progress: module.progress,
          ),
          18.gh,
          TtText(
            module.description,
            fontSize: 14,
            height: 1.4,
            color: Colors.white,
          ),
          18.gh,
          _ModuleMetadataView(
            teacherName: teacherName,
            videoCount: videoCount,
          ),
          22.gh,
          Row(
            children: [
              Expanded(
                child: TtButton(
                  backgroundColor: Colors.white,
                  onTap: onResume,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_circle_fill_rounded,
                        color: ColorUtils.primaryColor,
                      ),
                      SizedBox(width: 8),
                      TtText(
                        'Resume',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ColorUtils.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
              12.gw,
              Expanded(
                child: TtButton(
                  backgroundColor: ColorUtils.highlightColor,
                  onTap: onSecondaryAction,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        secondaryActionIcon,
                        color: Colors.white,
                      ),
                      8.gw,
                      TtText(
                        secondaryActionLabel,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModuleBadge extends StatelessWidget {
  final int moduleNumber;

  const _ModuleBadge({
    required this.moduleNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: ColorUtils.secondaryColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: TtText(
        'Module $moduleNumber',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }
}

class _ModuleProgressView extends StatelessWidget {
  final double progress;

  const _ModuleProgressView({
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: const Color(0xFFDCE3EC),
              valueColor: const AlwaysStoppedAnimation<Color>(
                ColorUtils.secondaryColor,
              ),
            ),
          ),
        ),
        12.gw,
        TtText(
          '${(progress * 100).round()}%',
          fontSize: 14,
          color: Colors.white,
        ),
      ],
    );
  }
}

class _ModuleMetadataView extends StatelessWidget {
  final String? teacherName;
  final int videoCount;

  const _ModuleMetadataView({
    required this.teacherName,
    required this.videoCount,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedTeacherName = teacherName?.trim();

    return Wrap(
      spacing: 16,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (normalizedTeacherName != null &&
            normalizedTeacherName.isNotEmpty)
          _MetadataItem(
            icon: Icons.person_rounded,
            label: 'by $normalizedTeacherName',
          ),
        _MetadataItem(
          icon: Icons.smart_display_rounded,
          label: '$videoCount video'
              '${videoCount == 1 ? '' : 's'}',
        ),

        // Duration is intentionally hidden because neither
        // the course nor module API currently provides it.
      ],
    );
  }
}

class _MetadataItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetadataItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 22,
          color: Colors.white,
        ),
        6.gw,
        TtText(
          label,
          fontSize: 14,
          color: Colors.white,
        ),
      ],
    );
  }
}