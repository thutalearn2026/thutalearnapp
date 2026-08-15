import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';

class ForgotPwPage extends StatelessWidget {
  const ForgotPwPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ForgotPasswordBloc>(),
      child: const _ForgotPwView(),
    );
  }
}

class _ForgotPwView extends StatefulWidget {
  const _ForgotPwView();

  @override
  State<_ForgotPwView> createState() => _ForgotPwViewState();
}

class _ForgotPwViewState extends State<_ForgotPwView> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';

  void _sendCode() {
    final bloc = context.read<ForgotPasswordBloc>();

    if (bloc.state.isLoading) return;

    if (!(_formKey.currentState?.validate() ?? false)) return;

    _formKey.currentState?.save();
    FocusManager.instance.primaryFocus?.unfocus();

    bloc.add(
      OnSendResetCode(
        email: _email.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state.status == ForgotPasswordStatus.failure) {
          context.showSnackBar(
            state.message ?? 'Unable to send reset code.',
            snackBarType: SnackBarType.error,
          );
        }

        if (state.status == ForgotPasswordStatus.success &&
            state.step == ForgotPasswordStep.sendCode) {
          context.showSnackBar(
            state.message ?? 'Password reset code sent.',
          );

          context.push(
            Routes.forgotCodeVerify,
            extra: ForgotPasswordVerifyArgs(
              email: _email.trim(),
            ),
          );
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
                  TtText(
                    'Forgot Password',
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  12.gh,
                  TtText(
                    StringUtils.enterMailOfRegisteredAccount,
                  ),
                  16.gh,
                  TtTextFormField(
                    hintText: 'Enter Email',
                    textInputType: TextInputType.emailAddress,
                    prefixIcon: Icon(
                      Icons.mail_outline,
                      color: ColorUtils.hintColor,
                    ),
                    onSaved: (value) {
                      _email = value?.trim() ?? '';
                    },
                    validator: (value) {
                      final email = value?.trim() ?? '';

                      if (email.isEmpty) {
                        return 'Please enter your email.';
                      }

                      if (!RegExp(
                        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                      ).hasMatch(email)) {
                        return 'Please enter a valid email.';
                      }

                      return null;
                    },
                  ),
                  16.gh,
                  SizedBox(
                    width: double.infinity,
                    child: TtButton(
                      onTap: _sendCode,
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