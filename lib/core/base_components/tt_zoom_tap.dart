import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class TtZoomTap extends StatelessWidget {
  final Widget child;
  final Function onTap;

  const TtZoomTap({super.key,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: child,
    );
  }
}