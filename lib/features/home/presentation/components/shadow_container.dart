import 'package:flutter/material.dart';

class ShadowContainer extends StatelessWidget {
  final Widget child;

  const ShadowContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}