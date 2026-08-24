import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';
import 'package:thuta_learn/features/profile/profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<ProfileBloc>()
            ..add(OnGetProfile()),
        ),
        BlocProvider(
          create: (_) => getIt<LogoutBloc>(),
        ),
      ],
      child: BlocConsumer<LogoutBloc, LogoutState>(
        listener: (context, state) {
          if (state.status == LogoutStatus.failure) {
            context.showSnackBar(
              state.message ??
                  'Unable to logout. Please try again.',
              snackBarType: SnackBarType.error,
            );
          }

          if (state.status == LogoutStatus.success) {
            // Do not show a snackbar immediately before
            // navigating because it can cause duplicate
            // SnackBar Hero errors.
            context.go(Routes.login);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              const _ProfileView(),

              if (state.isLoading)
                const Positioned.fill(
                  child: _LogoutLoadingOverlay(),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _LogoutLoadingOverlay extends StatelessWidget {
  const _LogoutLoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black38,
      child: PopScope(
        canPop: false,
        child: Center(
          child: Container(
            width: 110,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 22,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: ColorUtils.secondaryColor,
                ),
                SizedBox(height: 14),
                TtText(
                  'Logging out...',
                  fontSize: 14,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  bool _appSoundEnabled = false;
  bool _notificationsEnabled = true;
  bool _studyReminderEnabled = true;

  void _showLogoutDialog() {
    final logoutBloc = context.read<LogoutBloc>();

    if (logoutBloc.state.isLoading) return;

    context.showTtAnimatedDialog<void>(
      dialog: ProfileLogoutDialog(
        onContinue: () {
          logoutBloc.add(
            OnLogout(),
          );
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
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const TtText(
                'Cancel',
                fontSize: 14,
                color: ColorUtils.greyTextColor,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();

                // Delete-account API integration will be added later.
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

  Future<void> _refreshProfile() async {
    final profileBloc = context.read<ProfileBloc>();

    if (profileBloc.state.isRefreshing) {
      await profileBloc.stream.firstWhere(
            (state) => !state.isRefreshing,
      );
      return;
    }

    final refreshCompleted =
    profileBloc.stream.firstWhere(
          (state) {
        return !state.isRefreshing &&
            (state.status == ProfileStatus.success ||
                state.status == ProfileStatus.failure);
      },
    );

    profileBloc.add(OnGetProfile());

    await refreshCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) {
        return previous.message != current.message &&
            current.message != null;
      },
      listener: (context, state) {
        context.showSnackBar(
          state.message!,
          margin: const EdgeInsets.only(
            bottom: 100,
            left: 16,
            right: 16,
          ),
          snackBarType: SnackBarType.error,
        );
      },
      builder: (context, state) {
        if (state.isLoading && state.profile == null) {
          return const Scaffold(
            backgroundColor: ColorUtils.scaffoldBackgroundColor,
            body: Center(
              child: CircularProgressIndicator(
                color: ColorUtils.secondaryColor,
              ),
            ),
          );
        }

        if (state.status == ProfileStatus.failure && state.profile == null) {
          return _ProfileErrorView(
            message: state.message ?? 'Unable to load your profile.',
            onRetry: () {
              context.read<ProfileBloc>().add(
                OnGetProfile(),
              );
            },
          );
        }

        final profile = state.profile;

        if (profile == null) {
          return const Scaffold(
            backgroundColor: ColorUtils.scaffoldBackgroundColor,
            body: SizedBox.shrink(),
          );
        }

        return Scaffold(
          backgroundColor: ColorUtils.scaffoldBackgroundColor,
          body: Stack(
            children: [
              RefreshIndicator(
                color: ColorUtils.secondaryColor,
                onRefresh: _refreshProfile,
                child: _buildProfileContent(profile),
              ),

              if (state.isRefreshing && state.profile != null)
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    minHeight: 2,
                    color: ColorUtils.secondaryColor,
                    backgroundColor: Colors.transparent,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileContent(ProfileModel profile) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 120),
      children: [
        ProfileHeaderSectionView(
          profile: profile,
          onEdit: () async {
            final updatedProfile = await context.push<ProfileModel>(
              Routes.editProfile,
              extra: profile,
            );

            if (!mounted || updatedProfile == null) {
              return;
            }

            context.read<ProfileBloc>().add(
              OnGetProfile(),
            );

            // Wait for the Edit Profile route transition to finish.
            await Future<void>.delayed(
              const Duration(milliseconds: 350),
            );

            if (!mounted) return;

            context.showSnackBar(
              'Profile updated successfully.',
            );
          },
        ),
        14.gh,

        // Certificates
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

        // Learning information
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

        // Application settings
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
                // Open the language selection sheet later.
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

        // Legal and support information
        ProfileSettingsCard(
          children: [
            ProfileSettingTile(
              title: 'Contact Us',
              onTap: () {
                // Open Contact Us page later.
              },
            ),
            ProfileSettingTile(
              title: 'Privacy Policy',
              onTap: () {
                // Open Privacy Policy page later.
              },
            ),
            ProfileSettingTile(
              title: 'Terms of Use',
              onTap: () {
                // Open Terms of Use page later.
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

        // Account actions
        ProfileSettingsCard(
          children: [
            ProfileSettingTile(
              title: 'Help',
              onTap: () {
                // Open Help page later.
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
    );
  }
}

class _ProfileErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ProfileErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 56,
                color: Colors.red,
              ),
              16.gh,
              const TtText(
                'Unable to load profile',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              8.gh,
              TtText(
                message,
                fontSize: 14,
                color: ColorUtils.greyTextColor,
                textAlign: TextAlign.center,
              ),
              20.gh,
              SizedBox(
                width: 160,
                child: TtButton(
                  onTap: onRetry,
                  child: const TtText(
                    'Try Again',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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
