import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/profile/profile.dart';

class ProfileChangePasswordPage extends StatelessWidget {
  const ProfileChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ChangePasswordBloc>(),
      child: const _ProfileChangePasswordView(),
    );
  }
}

class _ProfileChangePasswordView extends StatefulWidget {
  const _ProfileChangePasswordView();

  @override
  State<_ProfileChangePasswordView> createState() {
    return _ProfileChangePasswordViewState();
  }
}

class _ProfileChangePasswordViewState
    extends State<_ProfileChangePasswordView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController
  _currentPasswordController;

  late final TextEditingController
  _newPasswordController;

  late final TextEditingController
  _confirmPasswordController;

  bool get _isFormFilled {
    final currentPassword =
        _currentPasswordController.text;

    final newPassword =
        _newPasswordController.text;

    final confirmPassword =
        _confirmPasswordController.text;

    return currentPassword.isNotEmpty &&
        newPassword.length >= 8 &&
        confirmPassword == newPassword &&
        newPassword != currentPassword;
  }

  @override
  void initState() {
    super.initState();

    _currentPasswordController =
        TextEditingController();

    _newPasswordController =
        TextEditingController();

    _confirmPasswordController =
        TextEditingController();
  }

  void _handleFieldChanged(String value) {
    setState(() {});
  }

  String? _validateCurrentPassword(String? value) {
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

    if (value == _currentPasswordController.text) {
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

  void _submit() {
    final bloc = context.read<ChangePasswordBloc>();

    if (bloc.state.isLoading) return;

    FocusManager.instance.primaryFocus?.unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    bloc.add(
      OnChangePassword(
        currentPassword:
        _currentPasswordController.text,
        password:
        _newPasswordController.text,
        passwordConfirmation:
        _confirmPasswordController.text,
      ),
    );
  }

  void _handleBack() {
    if (context.read<ChangePasswordBloc>()
        .state
        .isLoading) {
      return;
    }

    context.pop();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
        ChangePasswordBloc,
        ChangePasswordState>(
      listener: (context, state) {
        if (state.status ==
            ChangePasswordStatus.failure) {
          context.showSnackBar(
            state.message ??
                'Unable to change your password.',
            snackBarType: SnackBarType.error,
          );
        }

        if (state.status ==
            ChangePasswordStatus.success) {
          // Return the API message to the Edit Profile page.
          // Do not display a snackbar immediately before pop.
          context.pop(
            state.message ??
                'Password changed successfully.',
          );
        }
      },
      builder: (context, state) {
        final buttonEnabled =
            _isFormFilled && !state.isLoading;

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
                        controller:
                        _currentPasswordController,
                        hintText:
                        'Enter Current Password',
                        textInputAction:
                        TextInputAction.next,
                        validator:
                        _validateCurrentPassword,
                        onChanged:
                        _handleFieldChanged,
                      ),
                      18.gh,
                      ProfileChangePasswordField(
                        controller:
                        _newPasswordController,
                        hintText: 'New Password',
                        textInputAction:
                        TextInputAction.next,
                        validator:
                        _validateNewPassword,
                        onChanged:
                        _handleFieldChanged,
                      ),
                      18.gh,
                      ProfileChangePasswordField(
                        controller:
                        _confirmPasswordController,
                        hintText: 'Confirm Password',
                        textInputAction:
                        TextInputAction.done,
                        validator:
                        _validateConfirmPassword,
                        onChanged:
                        _handleFieldChanged,
                        onSubmitted:
                        buttonEnabled ? _submit : null,
                      ),
                      22.gh,
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                          buttonEnabled ? _submit : null,
                          style:
                          ElevatedButton.styleFrom(
                            elevation: 2,
                            shadowColor: Colors.black
                                .withValues(alpha: 0.2),
                            backgroundColor:
                            ColorUtils.primaryColor,
                            disabledBackgroundColor:
                            const Color(0xFFAAB7C8),
                            foregroundColor: Colors.white,
                            disabledForegroundColor:
                            Colors.white,
                            padding:
                            const EdgeInsets.symmetric(
                              vertical: 17,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(16),
                            ),
                          ),
                          child: state.isLoading
                              ? const SizedBox(
                            width: 22,
                            height: 22,
                            child:
                            CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                              : const TtText(
                            'Continue',
                            fontSize: 16,
                            fontWeight:
                            FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}