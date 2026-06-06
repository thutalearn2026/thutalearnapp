import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension TtSnackBar on BuildContext {
  void showSnackBar(
    String message, {
    SnackBarType snackBarType = SnackBarType.success,
  }) {
    HapticFeedback.vibrate();
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 2000),
        backgroundColor: _getBackgroundColor(snackBarType),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        content: Row(
          spacing: 12,
          children: [
            Icon(
              _getIcon(snackBarType),
              color: Colors.white,
            ),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor(SnackBarType snackBarType) {
    switch (snackBarType) {
      case SnackBarType.success:
        return Colors.green;
      case SnackBarType.error:
        return Colors.red;
      case SnackBarType.warning:
        return Colors.orange;
      case SnackBarType.info:
        return Colors.blue;
      default:
        return Colors.blue;
    }
  }

  IconData _getIcon(SnackBarType snackBarType) {
    switch (snackBarType) {
      case SnackBarType.success:
        return Icons.check_circle_rounded;
      case SnackBarType.error:
        return Icons.warning;
      case SnackBarType.warning:
      case SnackBarType.info:
        return Icons.info;
      default:
        return Icons.info;
    }
  }
}

enum SnackBarType { success, error, warning, info }
