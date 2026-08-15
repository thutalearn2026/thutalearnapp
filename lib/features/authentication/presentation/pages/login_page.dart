import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginBloc>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';

  void _login() {
    final bloc = context.read<LoginBloc>();

    if (bloc.state.isLoading) return;

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    _formKey.currentState?.save();

    FocusManager.instance.primaryFocus?.unfocus();

    bloc.add(
      OnLogin(
        email: _email.trim(),
        password: _password,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.failure) {
          context.showSnackBar(
            state.message ?? 'Login failed.',
            snackBarType: SnackBarType.error,
          );
        }

        if (state.status == LoginStatus.success) {
          context.showSnackBar(
            state.message ?? 'Login successful.',
          );

          context.go(Routes.bottomNav);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(toolbarHeight: 0),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  48.gh,
                  Image.asset(
                    ImageUtils.bgLogo,
                    width: 64,
                    height: 64,
                  ),
                  24.gh,
                  TtText(
                    StringUtils.welcomeBack,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
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
                        return 'Please enter your password.';
                      }

                      return null;
                    },
                  ),
                  8.gh,
                  const ForgotPasswordView(),
                  20.gh,
                  SizedBox(
                    width: double.infinity,
                    child: TtButton(
                      onTap: _login,
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
                        StringUtils.login,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  20.gh,
                  DoNotHaveAccountSectionView(
                    content: StringUtils.doNotHaveAccount,
                    actionButton: StringUtils.register,
                    onTap: () {
                      context.pushReplacement(Routes.register);
                    },
                  ),
                  28.gh,
                  const OrLoginWith(
                    label: 'or login with',
                  ),
                  20.gh,
                  const SocialLoginSectionView(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TtZoomTap(
        onTap: () {
          context.push(Routes.forgotPassword);
        },
        child: TtText(
          StringUtils.forgotPassword,
        ),
      ),
    );
  }
}