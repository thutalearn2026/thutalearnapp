import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';

class ForgotPwCodeVerifyPage extends StatelessWidget {
  final ForgotPasswordVerifyArgs args;

  const ForgotPwCodeVerifyPage({
    super.key,
    required this.args,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ForgotPasswordBloc>(),
      child: _ForgotPwCodeVerifyView(args: args),
    );
  }
}

class _ForgotPwCodeVerifyView extends StatefulWidget {
  final ForgotPasswordVerifyArgs args;

  const _ForgotPwCodeVerifyView({
    required this.args,
  });

  @override
  State<_ForgotPwCodeVerifyView> createState() =>
      _ForgotPwCodeVerifyViewState();
}

class _ForgotPwCodeVerifyViewState
    extends State<_ForgotPwCodeVerifyView> {
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _verify() {
    if (_pinController.text.length != 6) {
      context.showSnackBar(
        'Please enter the 6-digit verification code.',
        snackBarType: SnackBarType.error,
      );
      return;
    }

    context.read<ForgotPasswordBloc>().add(
      OnVerifyResetCode(
        email: widget.args.email,
        code: _pinController.text,
      ),
    );
  }

  void _resend() {
    context.read<ForgotPasswordBloc>().add(
      OnSendResetCode(
        email: widget.args.email,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state.status == ForgotPasswordStatus.failure) {
          context.showSnackBar(
            state.message ?? 'Verification failed.',
            snackBarType: SnackBarType.error,
          );
        }

        if (state.status == ForgotPasswordStatus.success &&
            state.step == ForgotPasswordStep.sendCode) {
          _pinController.clear();

          context.showSnackBar(
            state.message ?? 'A new reset code was sent.',
          );
        }

        if (state.status == ForgotPasswordStatus.success &&
            state.step == ForgotPasswordStep.verifyCode) {
          context.showSnackBar(
            state.message ?? 'Code verified.',
          );

          context.push(
            Routes.forgotSetNewPassword,
            extra: ResetPasswordArgs(
              email: widget.args.email,
              code: _pinController.text,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                24.gh,
                TtText(
                  StringUtils.codeVerification,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                12.gh,
                CodeFromMailDescView(
                  email: widget.args.email,
                ),
                20.gh,
                PinPutField(
                  controller: _pinController,
                ),
                16.gh,
                SizedBox(
                  width: double.infinity,
                  child: TtButton(
                    onTap: _verify,
                    child: state.isLoading &&
                        state.step == ForgotPasswordStep.verifyCode
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : TtText(
                      StringUtils.verify,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                8.gh,
                SizedBox(
                  width: double.infinity,
                  child: TtButton(
                    backgroundColor: Colors.transparent,
                    onTap: _resend,
                    child: TtText(
                      StringUtils.resendCode,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}