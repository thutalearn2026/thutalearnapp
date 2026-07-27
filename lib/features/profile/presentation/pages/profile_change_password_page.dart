import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/profile/profile.dart';

class ProfileChangePasswordPage extends StatefulWidget {
  const ProfileChangePasswordPage({super.key});

  @override
  State<ProfileChangePasswordPage> createState() =>
      _ProfileChangePasswordPageState();
}

class _ProfileChangePasswordPageState
    extends State<ProfileChangePasswordPage> {
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  late final TextEditingController _oldPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController
  _confirmPasswordController;

  bool _isSubmitting = false;

  bool get _isFormFilled {
    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword =
        _confirmPasswordController.text;

    return oldPassword.isNotEmpty &&
        newPassword.length >= 8 &&
        confirmPassword == newPassword &&
        newPassword != oldPassword;
  }

  @override
  void initState() {
    super.initState();

    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  void _handleFieldChanged(String value) {
    setState(() {});
  }

  String? _validateOldPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your current password';
    }

    return null;
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a new password';
    }

    if (value.length < 8) {
      return 'Password must contain at least 8 characters';
    }

    if (value == _oldPasswordController.text) {
      return 'New password must be different';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your new password';
    }

    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final oldPassword = _oldPasswordController.text;
      final newPassword = _newPasswordController.text;

      // Do not log either password.
      //
      // Dispatch your ChangePassword BLoC event here:
      //
      // context.read<ChangePasswordBloc>().add(
      //   ChangePasswordSubmitted(
      //     oldPassword: oldPassword,
      //     newPassword: newPassword,
      //   ),
      // );

      // Remove this delay when connecting the API.
      await Future<void>.delayed(
        const Duration(milliseconds: 500),
      );

      if (!mounted) {
        return;
      }

      context.showSnackBar(
        'Password changed successfully',
      );

      context.pop();
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonEnabled =
        _isFormFilled && !_isSubmitting;

    return Scaffold(
      backgroundColor: ColorUtils.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: ColorUtils.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorUtils.primaryColor,
          ),
        ),
        title: const TtText(
          'Change Password',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            16,
            36,
            16,
            32,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ProfileChangePasswordField(
                  controller: _oldPasswordController,
                  hintText: 'Enter Old Password',
                  textInputAction: TextInputAction.next,
                  validator: _validateOldPassword,
                  onChanged: _handleFieldChanged,
                ),
                18.gh,
                ProfileChangePasswordField(
                  controller: _newPasswordController,
                  hintText: 'New Password',
                  textInputAction: TextInputAction.next,
                  validator: _validateNewPassword,
                  onChanged: _handleFieldChanged,
                ),
                18.gh,
                ProfileChangePasswordField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  textInputAction: TextInputAction.done,
                  validator: _validateConfirmPassword,
                  onChanged: _handleFieldChanged,
                  onSubmitted:
                  buttonEnabled ? _submit : null,
                ),
                22.gh,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                    buttonEnabled ? _submit : null,
                    style: ElevatedButton.styleFrom(
                      elevation: 2,
                      shadowColor:
                      Colors.black.withValues(alpha: 0.2),
                      backgroundColor:
                      ColorUtils.primaryColor,
                      disabledBackgroundColor:
                      const Color(0xFFAAB7C8),
                      foregroundColor: Colors.white,
                      disabledForegroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 17,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(16),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                        : const TtText(
                      'Continue',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}