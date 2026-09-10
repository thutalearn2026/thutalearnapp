import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thuta_learn/core/core.dart';

class ProfileEditAvatar extends StatelessWidget {
  final String? networkPhotoUrl;
  final XFile? selectedPhoto;
  final VoidCallback onChangePhoto;

  const ProfileEditAvatar({
    super.key,
    required this.onChangePhoto,
    this.networkPhotoUrl,
    this.selectedPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return TtZoomTap(
      onTap: onChangePhoto,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 132,
            height: 132,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: Color(0xFFCA6C80),
              shape: BoxShape.circle,
            ),
            child: _buildPhoto(),
          ),
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.35),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.photo_camera_outlined,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoto() {
    if (selectedPhoto != null) {
      return Image.file(
        File(selectedPhoto!.path),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return _fallbackAvatar();
        },
      );
    }

    final hasNetworkPhoto =
        networkPhotoUrl != null &&
            networkPhotoUrl!.trim().isNotEmpty;

    if (hasNetworkPhoto) {
      return CachedNetworkImage(
        imageUrl: networkPhotoUrl!,
        fit: BoxFit.cover,
        placeholder: (_, __) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          );
        },
        errorWidget: (_, __, ___) {
          return _fallbackAvatar();
        },
      );
    }

    return _fallbackAvatar();
  }

  Widget _fallbackAvatar() {
    return const Icon(
      Icons.person_rounded,
      size: 92,
      color: Colors.white,
    );
  }
}