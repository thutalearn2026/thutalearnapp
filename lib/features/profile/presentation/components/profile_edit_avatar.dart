import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

class ProfileEditAvatar extends StatelessWidget {
  final VoidCallback onChangePhoto;

  const ProfileEditAvatar({
    super.key,
    required this.onChangePhoto,
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
            decoration: const BoxDecoration(
              color: Color(0xFFCA6C80),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 92,
              color: Colors.white,
            ),
          ),
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.25),
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
}