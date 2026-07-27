import 'package:flutter/material.dart';

extension TtAnimatedDialog on BuildContext {
  Future<T?> showTtAnimatedDialog<T>({
    required Widget dialog,
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: this,
      barrierLabel: 'Dismiss',
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return dialog;
      },
      transitionBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
          ) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeIn,
        );

        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.88,
              end: 1,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }
}