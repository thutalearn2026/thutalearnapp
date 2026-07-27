import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/profile/profile.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() =>
      _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late final TextEditingController _usernameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController(
      text: 'Sora',
    );

    _phoneController = TextEditingController();
  }

  Future<void> _changeProfilePhoto() async {
    // Open the image picker here later.
    //
    // Recommended flow:
    // 1. Let the user choose Camera or Gallery.
    // 2. Request the required permission.
    // 3. Show the selected local image.
    // 4. Upload it when the API is available.
  }

  void _handleChangePassword() {
    context.push(Routes.changePassword);
  }

  void _saveProfileChanges() {
    final username = _usernameController.text.trim();
    final phoneNumber = _phoneController.text.trim();

    // Send username and phoneNumber to the BLoC/API later.
    debugPrint('Username: $username');
    debugPrint('Phone: $phoneNumber');
  }

  void _handleBack() {
    _saveProfileChanges();
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
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          _saveProfileChanges();
        }
      },
      child: Scaffold(
        backgroundColor: ColorUtils.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: ColorUtils.scaffoldBackgroundColor,
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
                  onChangePhoto: _changeProfilePhoto,
                ),
                36.gh,
                ProfileEditInformationCard(
                  usernameController:
                  _usernameController,
                  phoneController: _phoneController,
                  email: 'ekzlynn@gmail.com',
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