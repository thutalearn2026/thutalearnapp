import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

class ProfileLogoutDialog extends StatelessWidget {
  final VoidCallback onContinue;

  const ProfileLogoutDialog({
    super.key,
    required this.onContinue,
  });

  void _cancel(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _continue(BuildContext context) {
    Navigator.of(context).pop();
    onContinue();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 28,
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
          24,
          24,
          24,
          24,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              ImageUtils.logoutIcon,
              width: 150,
              height: 150,
              fit: BoxFit.contain,
              errorBuilder: (
                  context,
                  error,
                  stackTrace,
                  ) {
                // Temporary fallback until logout_icon.png
                // is added.
                return Container(
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(
                    color:
                    ColorUtils.secondaryBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    size: 65,
                    color: ColorUtils.primaryColor,
                  ),
                );
              },
            ),
            12.gh,
            const TtText(
              'LOGOUT ?',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorUtils.primaryColor,
            ),
            18.gh,
            const TtText(
              'Are you sure you want to logout from this '
                  'account? After you logout, you can login '
                  'anytime you want.',
              fontSize: 14,
              height: 1.4,
              textAlign: TextAlign.center,
              color: Colors.black,
            ),
            22.gh,
            Row(
              children: [
                Expanded(
                  child: TtButton(
                    backgroundColor:
                    const Color(0xFFE9ECF1),
                    onTap: () {
                      _cancel(context);
                    },
                    child: const TtText(
                      'Cancel',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ColorUtils.primaryColor,
                    ),
                  ),
                ),
                12.gw,
                Expanded(
                  child: TtButton(
                    backgroundColor: Colors.red,
                    onTap: () {
                      _continue(context);
                    },
                    child: const TtText(
                      'Continue',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}