import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
                StringUtils.letsCreateAccount,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
              16.gh,
              TtTextFormField(
                hintText: "Enter Username",
                textInputType: TextInputType.text,
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: ColorUtils.hintColor,
                ),
              ),
              16.gh,
              TtTextFormField(
                hintText: "Enter Email",
                textInputType: TextInputType.emailAddress,
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: ColorUtils.hintColor,
                ),
              ),
              20.gh,
              Container(
                width: double.infinity,
                child: TtButton(
                  onTap: () {
                    context.push(Routes.regCodeVerify);
                  },
                  child: TtText(
                    StringUtils.continueLabel,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              20.gh,
              DoNotHaveAccountSectionView(
                content: StringUtils.alreadyHaveAccount,
                actionButton: StringUtils.login,
                onTap: () {
                  context.pushReplacement(Routes.login);
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
