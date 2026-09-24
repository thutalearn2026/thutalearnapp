import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

class ProfileUpdateResultDialog extends StatelessWidget {
  final bool isSuccess;
  final String message;

  const ProfileUpdateResultDialog({
    super.key,
    required this.isSuccess,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = isSuccess
        ? ColorUtils.secondaryColor
        : const Color(0xFFE5484D);

    final backgroundColor = isSuccess
        ? ColorUtils.secondaryBackgroundColor
        : const Color(0xFFFFEEEE);

    return Dialog(
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 380,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            24,
            28,
            24,
            24,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.14,
                ),
                blurRadius: 32,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ResultIcon(
                isSuccess: isSuccess,
                accentColor: accentColor,
                backgroundColor: backgroundColor,
              ),
              22.gh,
              TtText(
                isSuccess
                    ? 'Profile Updated!'
                    : 'Update Unsuccessful',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ColorUtils.primaryColor,
                textAlign: TextAlign.center,
              ),
              10.gh,
              TtText(
                message,
                fontSize: 14,
                height: 1.5,
                color: ColorUtils.greyTextColor,
                textAlign: TextAlign.center,
              ),
              24.gh,
              SizedBox(
                width: double.infinity,
                child: TtButton(
                  backgroundColor: accentColor,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: TtText(
                    isSuccess ? 'Done' : 'Try Again',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultIcon extends StatelessWidget {
  final bool isSuccess;
  final Color accentColor;
  final Color backgroundColor;

  const _ResultIcon({
    required this.isSuccess,
    required this.accentColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 106,
      height: 106,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 106,
            height: 106,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor.withValues(
                alpha: 0.08,
              ),
            ),
          ),
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
              border: Border.all(
                color: accentColor.withValues(
                  alpha: 0.22,
                ),
                width: 1.5,
              ),
            ),
          ),
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor,
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(
                    alpha: 0.28,
                  ),
                  blurRadius: 16,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Icon(
              isSuccess
                  ? Icons.check_rounded
                  : Icons.priority_high_rounded,
              size: 38,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}