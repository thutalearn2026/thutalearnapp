import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(toolbarHeight: 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              48.gh,
              Image.asset(
                ImageUtils.logo,
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
                hintText: "Enter Email",
                textInputType: TextInputType.emailAddress,
                prefixIcon: Icon(
                  Icons.mail_outline_outlined,
                  color: ColorUtils.hintColor,
                ),
              ),
              16.gh,
              TtTextFormField(
                hintText: "Enter Password",
                isPassword: true,
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: ColorUtils.hintColor,
                ),
              ),
              8.gh,
              ForgotPasswordView(),
              20.gh,
              Container(
                width: double.infinity,
                child: TtButton(
                  onTap: () {},
                  child: TtText(
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
              OrLoginWith(label: "or login with"),
              20.gh,
              SocialLoginSectionView(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({
    super.key,
  });

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
