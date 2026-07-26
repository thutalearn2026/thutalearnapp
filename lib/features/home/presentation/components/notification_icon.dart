import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/features.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return TtZoomTap(
      onTap: () {

      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: ColorUtils.highlightColor,
          shape: BoxShape.circle,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              color: Colors.white,
              size: 24,
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: ColorUtils.secondaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
