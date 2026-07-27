import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

class ProfileHeaderSectionView extends StatelessWidget {
  final VoidCallback onEdit;

  const ProfileHeaderSectionView({
    super.key,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.paddingOf(context).top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        16,
        statusBarHeight + 16,
        16,
        22,
      ),
      decoration: const BoxDecoration(
        color: ColorUtils.primaryColor,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(34),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TtText(
            'Settings',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          18.gh,
          Row(
            children: [
              const _ProfileAvatar(),
              14.gw,
              const Expanded(
                child: _ProfileInformationView(),
              ),
              TtZoomTap(
                onTap: onEdit,
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                    size: 24,
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

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      height: 82,
      decoration: BoxDecoration(
        color: const Color(0xFFFF829E),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.35),
          width: 2,
        ),
      ),
      child: const Icon(
        Icons.person_rounded,
        size: 54,
        color: Colors.white,
      ),
    );
  }
}

class _ProfileInformationView extends StatelessWidget {
  const _ProfileInformationView();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.workspace_premium_outlined,
                size: 15,
                color: ColorUtils.secondaryColor,
              ),
              SizedBox(width: 4),
              TtText(
                'Beginner',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: ColorUtils.primaryColor,
              ),
            ],
          ),
        ),
        8.gh,
        const TtText(
          'Sora Lynn',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        7.gh,
        const Row(
          children: [
            TtText(
              'Signed in with',
              fontSize: 14,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            _GoogleAccountIcon(),
          ],
        ),
      ],
    );
  }
}

class _GoogleAccountIcon extends StatelessWidget {
  const _GoogleAccountIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: const TtText(
        'G',
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF4285F4),
      ),
    );
  }
}