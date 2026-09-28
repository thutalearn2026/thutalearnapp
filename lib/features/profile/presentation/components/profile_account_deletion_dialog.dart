import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

class ProfileAccountDeletionConfirmationDialog
    extends StatelessWidget {
  const ProfileAccountDeletionConfirmationDialog({
    super.key,
  });

  void _cancel(BuildContext context) {
    Navigator.of(context).pop(false);
  }

  void _confirm(BuildContext context) {
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 390,
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
                blurRadius: 30,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _AccountDeletionDialogIcon(
                icon: Icons.person_remove_outlined,
              ),
              22.gh,
              const TtText(
                'Delete Your Account?',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ColorUtils.primaryColor,
                textAlign: TextAlign.center,
              ),
              12.gh,
              const TtText(
                'Are you sure you want to request account '
                    'deletion? Deleting your account will permanently '
                    'remove your profile and learning information.',
                fontSize: 14,
                height: 1.5,
                color: ColorUtils.greyTextColor,
                textAlign: TextAlign.center,
              ),
              24.gh,
              Row(
                children: [
                  Expanded(
                    child: TtButton(
                      backgroundColor: const Color(
                        0xFFE9ECF1,
                      ),
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
                      backgroundColor: const Color(
                        0xFFE5484D,
                      ),
                      onTap: () {
                        _confirm(context);
                      },
                      child: const TtText(
                        'Confirm',
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
      ),
    );
  }
}

class ProfileAccountDeletionContactDialog
    extends StatelessWidget {
  final Future<void> Function() onOpenLink;

  const ProfileAccountDeletionContactDialog({
    super.key,
    required this.onOpenLink,
  });

  void _close(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 390,
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
                blurRadius: 30,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _AccountDeletionDialogIcon(
                icon: Icons.support_agent_rounded,
              ),
              22.gh,
              const TtText(
                'Contact Us',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ColorUtils.primaryColor,
                textAlign: TextAlign.center,
              ),
              12.gh,
              const TtText(
                'To request permanent deletion of your account '
                    'and associated information, please contact us '
                    'through the page below.',
                fontSize: 14,
                height: 1.5,
                color: ColorUtils.greyTextColor,
                textAlign: TextAlign.center,
              ),
              20.gh,
              Material(
                color: ColorUtils.secondaryBackgroundColor,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    onOpenLink();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: ColorUtils.secondaryColor.withValues(
                          alpha: 0.35,
                        ),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.open_in_new_rounded,
                          size: 21,
                          color: ColorUtils.secondaryColor,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TtText(
                            'https://thutalearn.com/account-deletion',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                            color: ColorUtils.secondaryColor,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              24.gh,
              SizedBox(
                width: double.infinity,
                child: TtButton(
                  onTap: () {
                    _close(context);
                  },
                  child: const TtText(
                    'Close',
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

class _AccountDeletionDialogIcon extends StatelessWidget {
  final IconData icon;

  const _AccountDeletionDialogIcon({
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFE5484D);

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
              color: accentColor.withValues(
                alpha: 0.08,
              ),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: accentColor.withValues(
                alpha: 0.12,
              ),
              shape: BoxShape.circle,
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
              color: accentColor,
              shape: BoxShape.circle,
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
              icon,
              size: 34,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}