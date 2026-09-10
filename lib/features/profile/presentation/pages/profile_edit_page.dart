import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/profile/profile.dart';

class ProfileEditPage extends StatelessWidget {
  final ProfileModel profile;

  const ProfileEditPage({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EditProfileBloc>(),
      child: _ProfileEditView(
        profile: profile,
      ),
    );
  }
}

class _ProfileEditView extends StatefulWidget {
  final ProfileModel profile;

  const _ProfileEditView({
    required this.profile,
  });

  @override
  State<_ProfileEditView> createState() =>
      _ProfileEditViewState();
}

class _ProfileEditViewState extends State<_ProfileEditView> {
  final ImagePicker _imagePicker = ImagePicker();

  late final TextEditingController _usernameController;
  late final TextEditingController _phoneController;

  XFile? _selectedPhoto;

  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController(
      text: widget.profile.name,
    );

    // Phone is currently not returned or accepted by the API.
    _phoneController = TextEditingController();
  }

  Future<void> _changeProfilePhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_outlined,
                    color: ColorUtils.primaryColor,
                  ),
                  title: const TtText(
                    'Choose from gallery',
                    fontSize: 14,
                  ),
                  onTap: () {
                    Navigator.of(bottomSheetContext).pop(
                      ImageSource.gallery,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_camera_outlined,
                    color: ColorUtils.primaryColor,
                  ),
                  title: const TtText(
                    'Take a photo',
                    fontSize: 14,
                  ),
                  onTap: () {
                    Navigator.of(bottomSheetContext).pop(
                      ImageSource.camera,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source == null) return;

    final selectedPhoto = await _imagePicker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1600,
      maxHeight: 1600,
    );

    if (selectedPhoto == null) return;

    final fileSize = await selectedPhoto.length();
    const maximumSize = 2 * 1024 * 1024;

    if (!mounted) return;

    if (fileSize > maximumSize) {
      context.showSnackBar(
        'Profile photo must not be larger than 2 MB.',
        snackBarType: SnackBarType.error,
      );
      return;
    }

    setState(() {
      _selectedPhoto = selectedPhoto;
    });
  }

  Future<void> _handleChangePassword() async {
    final message = await context.push<String>(
      Routes.changePassword,
    );

    if (!mounted || message == null) return;

    // Wait until the Change Password route transition
    // has completely finished.
    await Future<void>.delayed(
      const Duration(milliseconds: 350),
    );

    if (!mounted) return;

    context.showSnackBar(message);
  }

  void _saveProfileChanges() {
    final bloc = context.read<EditProfileBloc>();

    if (bloc.state.isLoading) return;

    final name = _usernameController.text.trim();

    if (name.isEmpty) {
      context.showSnackBar(
        'Please enter your name.',
        snackBarType: SnackBarType.error,
      );
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    bloc.add(
      OnUpdateProfile(
        name: name,
        email: widget.profile.email,
        photoPath: _selectedPhoto?.path,
      ),
    );
  }

  void _handleBack() {
    if (context.read<EditProfileBloc>().state.isLoading) {
      return;
    }

    context.pop();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileBloc, EditProfileState>(
      listener: (context, state) {
        if (state.status == EditProfileStatus.failure) {
          context.showSnackBar(
            state.message ?? 'Unable to update your profile.',
            snackBarType: SnackBarType.error,
          );
        }

        if (state.status == EditProfileStatus.success &&
            state.updatedProfile != null) {
          // Do not show a snackbar here because this route
          // is about to be popped.
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          context.pop(state.updatedProfile);
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: !state.isLoading,
          child: Scaffold(
            backgroundColor:
            ColorUtils.scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor:
              ColorUtils.scaffoldBackgroundColor,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                onPressed: _handleBack,
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: ColorUtils.primaryColor,
                ),
              ),
              title: const TtText(
                'Your Profile',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              actions: [
                TextButton(
                  onPressed: state.isLoading
                      ? null
                      : _saveProfileChanges,
                  child: state.isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: ColorUtils.secondaryColor,
                    ),
                  )
                      : const TtText(
                    'Save',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ColorUtils.secondaryColor,
                  ),
                ),
              ],
            ),
            body: GestureDetector(
              onTap: FocusScope.of(context).unfocus,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  32,
                  16,
                  32,
                ),
                child: Column(
                  children: [
                    ProfileEditAvatar(
                      networkPhotoUrl: widget.profile.photo,
                      selectedPhoto: _selectedPhoto,
                      onChangePhoto: _changeProfilePhoto,
                    ),
                    36.gh,
                    ProfileEditInformationCard(
                      usernameController:
                      _usernameController,
                      phoneController: _phoneController,
                      email: widget.profile.email,
                    ),
                    16.gh,
                    _ChangePasswordCard(
                      onTap: _handleChangePassword,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ChangePasswordCard extends StatelessWidget {
  final VoidCallback onTap;

  const _ChangePasswordCard({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TtZoomTap(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 64,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE1E5EA),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.025),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Row(
          children: [
            Expanded(
              child: TtText(
                'Change Password',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: ColorUtils.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}