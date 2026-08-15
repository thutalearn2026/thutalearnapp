import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegCodeVerifyPage extends StatelessWidget {
  final RegisterVerifyArgs args;

  const RegCodeVerifyPage({
    super.key,
    required this.args,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegisterBloc>(),
      child: _RegCodeVerifyView(args: args),
    );
  }
}

class _RegCodeVerifyView extends StatefulWidget {
  final RegisterVerifyArgs args;

  const _RegCodeVerifyView({
    required this.args,
  });

  @override
  State<_RegCodeVerifyView> createState() => _RegCodeVerifyViewState();
}

class _RegCodeVerifyViewState extends State<_RegCodeVerifyView> {
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

    context.read<RegisterBloc>().add(
      OnVerifyRegistrationCode(
        email: widget.args.email,
        code: _pinController.text,
      ),
    );
  }

  void _resend() {
    context.read<RegisterBloc>().add(
      OnInitiateRegistration(
        name: widget.args.name,
        email: widget.args.email,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.status == RegisterStatus.failure) {
          context.showSnackBar(
            state.message ?? 'Verification failed.',
            snackBarType: SnackBarType.error,
          );
        }

        if (state.status == RegisterStatus.success &&
            state.step == RegisterStep.initiate) {
          _pinController.clear();
          context.showSnackBar(state.message ?? 'A new code was sent.');
        }

        if (state.status == RegisterStatus.success &&
            state.step == RegisterStep.verify) {
          context.showSnackBar(state.message ?? 'Code verified.');

          context.push(
            Routes.regSetPassword,
            extra: RegisterCompleteArgs(
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
                PinPutField(controller: _pinController),
                16.gh,
                SizedBox(
                  width: double.infinity,
                  child: TtButton(
                    onTap: state.isLoading ? () {} : _verify,
                    child: state.isLoading &&
                        state.step == RegisterStep.verify
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
                    onTap: state.isLoading ? () {} : _resend,
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
