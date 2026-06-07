import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thuta_learn/core/core.dart';

class TtButton extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;
  final Function onTap;

  const TtButton({
    super.key,
    this.backgroundColor = ColorUtils.primaryColor,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16),
        ),
      ),
      onPressed: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: child,
    );
  }
}
