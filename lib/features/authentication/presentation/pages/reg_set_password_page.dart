import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';

class RegSetPasswordPage extends StatelessWidget {
  final RegisterCompleteArgs args;

  const RegSetPasswordPage({
    super.key,
    required this.args,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegisterBloc>(),
      child: _RegSetPasswordView(args: args),
    );
  }
}

class _RegSetPasswordView extends StatefulWidget {
  final RegisterCompleteArgs args;

  const _RegSetPasswordView({
    required this.args,
  });

  @override
  State<_RegSetPasswordView> createState() => _RegSetPasswordViewState();
}

class _RegSetPasswordViewState extends State<_RegSetPasswordView> {
  final _formKey = GlobalKey<FormState>();

  String _password = '';
  String _passwordConfirmation = '';

  void _completeRegistration() {
    if (context.read<RegisterBloc>().state.isLoading) return;

    if (!(_formKey.currentState?.validate() ?? false)) return;

    _formKey.currentState?.save();

    if (_password != _passwordConfirmation) {
      context.showSnackBar(
        'Passwords do not match.',
        snackBarType: SnackBarType.error,
      );
      return;
    }

    context.read<RegisterBloc>().add(
      OnCompleteRegistration(
        email: widget.args.email,
        code: widget.args.code,
        password: _password,
        passwordConfirmation: _passwordConfirmation,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.status == RegisterStatus.failure) {
          context.showSnackBar(
            state.message ?? 'Registration failed.',
            snackBarType: SnackBarType.error,
          );
        }

        if (state.status == RegisterStatus.success &&
            state.step == RegisterStep.complete) {
          context.showSnackBar(
            state.message ?? 'Registration successful.',
          );

          context.go(Routes.accountSetUp);
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
                    StringUtils.setAPassword,
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
                    onSaved: (value) => _password = value ?? '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password.';
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
                      onTap: _completeRegistration,
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
