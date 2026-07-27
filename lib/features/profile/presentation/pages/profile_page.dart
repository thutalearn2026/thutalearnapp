import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/profile/profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _appSoundEnabled = false;
  bool _notificationsEnabled = true;
  bool _studyReminderEnabled = true;

  void _showLogoutDialog() {
    context.showTtAnimatedDialog<void>(
      dialog: ProfileLogoutDialog(
        onContinue: () {
          // Clear authentication data here.
          //
          // TokenModelBox().deleteTokenModel();
          // UserBox().deleteUsers();

          context.go(Routes.login);
        },
      ),
    );
  }

  Future<void> _showDeleteAccountDialog() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const TtText(
            'Delete Account',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
          content: const TtText(
            'Deleting your account is permanent and cannot '
                'be undone. Do you want to continue?',
            fontSize: 14,
            height: 1.4,
          ),
          actions: [
            TextButton(
              onPressed: Navigator.of(dialogContext).pop,
              child: const TtText(
                'Cancel',
                fontSize: 14,
                color: ColorUtils.greyTextColor,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();

                // Call the delete-account API later.
              },
              child: const TtText(
                'Delete',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.scaffoldBackgroundColor,
      body: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          ProfileHeaderSectionView(
            onEdit: () {
              context.push(Routes.editProfile);
            },
          ),
          14.gh,
          ProfileSettingsCard(
            children: [
              ProfileSettingTile(
                title: 'Get your certificates',
                trailing: const _CountBadge(count: 1),
                onTap: () {
                  context.push(Routes.certificates);
                },
              ),
            ],
          ),
          14.gh,
          ProfileSettingsCard(
            children: [
              ProfileSettingTile(
                title: 'Learning Progress',
                onTap: () {
                  context.push(Routes.learningProgress);
                },
              ),
              ProfileSettingTile(
                title: 'Saved Vocabulary',
                onTap: () {
                  context.push(Routes.savedVocabulary);
                },
              ),
            ],
          ),
          14.gh,
          ProfileSettingsCard(
            children: [
              ProfileSettingTile(
                title: 'App Language',
                trailing: const TtText(
                  'English',
                  fontSize: 14,
                  color: ColorUtils.greyTextColor,
                ),
                onTap: () {
                  // Open the language-selection sheet.
                },
              ),
              ProfileSettingTile(
                title: 'App Sound',
                showArrow: false,
                trailing: _ProfileSwitch(
                  value: _appSoundEnabled,
                  onChanged: (value) {
                    setState(() {
                      _appSoundEnabled = value;
                    });
                  },
                ),
              ),
              ProfileSettingTile(
                title: 'Notification',
                showArrow: false,
                trailing: _ProfileSwitch(
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                ),
              ),
              ProfileSettingTile(
                title: 'Study Reminder',
                showArrow: false,
                trailing: _ProfileSwitch(
                  value: _studyReminderEnabled,
                  onChanged: (value) {
                    setState(() {
                      _studyReminderEnabled = value;
                    });
                  },
                ),
              ),
            ],
          ),
          14.gh,
          ProfileSettingsCard(
            children: [
              ProfileSettingTile(
                title: 'Contact Us',
                onTap: () {
                  // Open the contact page.
                },
              ),
              ProfileSettingTile(
                title: 'Privacy Policy',
                onTap: () {
                  // Open the privacy-policy page.
                },
              ),
              ProfileSettingTile(
                title: 'Terms of Use',
                onTap: () {
                  // Open the terms page.
                },
              ),
              const ProfileSettingTile(
                title: 'Version',
                showArrow: false,
                trailing: TtText(
                  '1.0.0',
                  fontSize: 14,
                  color: ColorUtils.greyTextColor,
                ),
              ),
            ],
          ),
          14.gh,
          ProfileSettingsCard(
            children: [
              ProfileSettingTile(
                title: 'Help',
                onTap: () {
                  // Open the help page.
                },
              ),
              ProfileSettingTile(
                title: 'Logout',
                titleColor: Colors.red,
                onTap: _showLogoutDialog,
              ),
              ProfileSettingTile(
                title: 'Delete Account',
                titleColor: Colors.red,
                onTap: _showDeleteAccountDialog,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int count;

  const _CountBadge({
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: ColorUtils.secondaryColor,
        shape: BoxShape.circle,
      ),
      child: TtText(
        '$count',
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}

class _ProfileSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ProfileSwitch({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: value,
      activeThumbColor: Colors.white,
      activeTrackColor: ColorUtils.secondaryColor,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: const Color(0xFFE2E6EC),
      onChanged: onChanged,
    );
  }
}