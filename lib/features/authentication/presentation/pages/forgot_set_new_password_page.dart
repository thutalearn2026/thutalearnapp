import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';

class ForgotSetNewPasswordPage extends StatelessWidget {
  final ResetPasswordArgs args;

  const ForgotSetNewPasswordPage({
    super.key,
    required this.args,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ForgotPasswordBloc>(),
      child: _ForgotSetNewPasswordView(args: args),
    );
  }
}

class _ForgotSetNewPasswordView extends StatefulWidget {
  final ResetPasswordArgs args;

  const _ForgotSetNewPasswordView({
    required this.args,
  });

  @override
  State<_ForgotSetNewPasswordView> createState() =>
      _ForgotSetNewPasswordViewState();
}

class _ForgotSetNewPasswordViewState
    extends State<_ForgotSetNewPasswordView> {
  final _formKey = GlobalKey<FormState>();

  String _password = '';
  String _passwordConfirmation = '';

  void _resetPassword() {
    final bloc = context.read<ForgotPasswordBloc>();

    if (bloc.state.isLoading) return;

    if (!(_formKey.currentState?.validate() ?? false)) return;

    _formKey.currentState?.save();

    if (_password != _passwordConfirmation) {
      context.showSnackBar(
        'Passwords do not match.',
        snackBarType: SnackBarType.error,
      );
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    bloc.add(
      OnResetPassword(
        email: widget.args.email,
        code: widget.args.code,
        password: _password,
        passwordConfirmation: _passwordConfirmation,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state.status == ForgotPasswordStatus.failure) {
          context.showSnackBar(
            state.message ?? 'Unable to reset password.',
            snackBarType: SnackBarType.error,
          );
        }

        if (state.status == ForgotPasswordStatus.success &&
            state.step == ForgotPasswordStep.resetPassword) {
          context.showSnackBar(
            state.message ?? 'Password reset successful.',
          );

          context.go(Routes.login);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: const AppBarWithBack(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  24.gh,
                  Image.asset(
                    ImageUtils.bgLogo,
                    width: 64,
                    height: 64,
                  ),
                  24.gh,
                  TtText(
                    'Set new password',
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  16.gh,
                  TtTextFormField(
                    hintText: 'Enter Password',
                    isPassword: true,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: ColorUtils.hintColor,
                    ),
                    onSaved: (value) {
                      _password = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your new password.';
                      }

                      if (value.length < 8) {
                        return 'Password must contain at least 8 characters.';
                      }

                      return null;
                    },
                  ),
                  16.gh,
                  TtTextFormField(
                    hintText: 'Confirm Password',
                    isPassword: true,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: ColorUtils.hintColor,
                    ),
                    onSaved: (value) {
                      _passwordConfirmation = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password.';
                      }

                      return null;
                    },
                  ),
                  20.gh,
                  SizedBox(
                    width: double.infinity,
                    child: TtButton(
                      onTap: _resetPassword,
                      child: state.isLoading
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : TtText(
                        StringUtils.continueLabel,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}