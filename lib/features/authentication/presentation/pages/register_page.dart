import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegisterBloc>(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _email = '';

  void _register() {
    final bloc = context.read<RegisterBloc>();

    if (bloc.state.isLoading) return;

    if (!(_formKey.currentState?.validate() ?? false)) return;

    _formKey.currentState?.save();

    bloc.add(
      OnInitiateRegistration(
        name: _name.trim(),
        email: _email.trim(),
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
            state.step == RegisterStep.initiate) {
          context.showSnackBar(state.message ?? 'Verification code sent.');

          context.push(
            Routes.regCodeVerify,
            extra: RegisterVerifyArgs(
              name: _name.trim(),
              email: _email.trim(),
            ),
          );
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
                    StringUtils.letsCreateAccount,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  16.gh,
                  TtTextFormField(
                    hintText: 'Enter Username',
                    textInputType: TextInputType.name,
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: ColorUtils.hintColor,
                    ),
                    onSaved: (value) => _name = value ?? '',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your username.';
                      }
                      return null;
                    },
                  ),
                  16.gh,
                  TtTextFormField(
                    hintText: 'Enter Email',
                    textInputType: TextInputType.emailAddress,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: ColorUtils.hintColor,
                    ),
                    onSaved: (value) => _email = value ?? '',
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
                  20.gh,
                  SizedBox(
                    width: double.infinity,
                    child: TtButton(
                      onTap: _register,
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

                  // Keep your existing login and social-login sections here.
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
