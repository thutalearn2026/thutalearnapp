import 'package:flutter/material.dart';

extension TtAnimatedDialog on BuildContext {
  void showTtAnimatedDialog({required Widget dialog}) {
    showGeneralDialog(
      context: this,
      barrierLabel: '',
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, animation1, animation2, widget) {
        return Transform.scale(
          scale: animation1.value,
          child: Opacity(
            opacity: animation1.value,
            child: dialog,
          ),
        );
      },
    );
  }
}
