import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';

class ForgotSetNewPasswordPage extends StatelessWidget {
  const ForgotSetNewPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWithBack(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              24.gh,
              Image.asset(
                ImageUtils.logo,
                width: 64,
                height: 64,
              ),
              24.gh,
              TtText(
                "Set new password",
                fontWeight: FontWeight.bold,
                fontSize: 24,
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
              16.gh,
              TtTextFormField(
                hintText: "Confirm Password",
                isPassword: true,
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: ColorUtils.hintColor,
                ),
              ),
              20.gh,
              Container(
                width: double.infinity,
                child: TtButton(
                  onTap: () {},
                  child: TtText(
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
  }
}
