import 'package:flutter/material.dart';

class TtFadeIn extends StatelessWidget {
  final Widget child;
  final bool isAnimatedScale;
  final Duration? duration;

  const TtFadeIn({
    super.key,
    required this.child,
    this.isAnimatedScale = false,
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeIn,
      duration: duration ?? const Duration(milliseconds: 300),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: isAnimatedScale ? value : 1,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
