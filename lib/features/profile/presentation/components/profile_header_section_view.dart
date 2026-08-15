import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:thuta_learn/features/profile/data/models/profile_model.dart';

import '../../data/models/profile_model.dart';

class ProfileHeaderSectionView extends StatelessWidget {
  final ProfileModel profile;
  final VoidCallback onEdit;

  const ProfileHeaderSectionView({
    super.key,
    required this.profile,
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
              _ProfileAvatar(
                photoUrl: profile.photo,
              ),
              14.gw,
              Expanded(
                child: _ProfileInformationView(
                  name: profile.name,
                  email: profile.email,
                ),
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
  final String? photoUrl;

  const _ProfileAvatar({
    this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl != null && photoUrl!.trim().isNotEmpty;

    return Container(
      width: 82,
      height: 82,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: hasPhoto ? Colors.white : Colors.pink.shade300,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.35),
          width: 2,
        ),
      ),
      child: hasPhoto
          ? CachedNetworkImage(
              imageUrl: photoUrl!,
              fit: BoxFit.cover,
              imageBuilder: (context, imageProvider) {
                return Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover
                    ),
                  ),
                );
              },
              placeholder: (_, __) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                );
              },
              errorWidget: (_, __, ___) {
                return const Icon(
                  Icons.person_rounded,
                  size: 54,
                  color: Colors.white,
                );
              },
            )
          : const Icon(
              Icons.person_rounded,
              size: 54,
              color: Colors.white,
            ),
    );
  }
}

class _ProfileInformationView extends StatelessWidget {
  final String name;
  final String email;

  const _ProfileInformationView({
    required this.name,
    required this.email,
  });

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
        TtText(
          name,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        7.gh,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.email_outlined,
              size: 17,
              color: Colors.white,
            ),
            6.gw,
            Expanded(
              child: TtText(
                email,
                fontSize: 14,
                color: Colors.white,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
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
