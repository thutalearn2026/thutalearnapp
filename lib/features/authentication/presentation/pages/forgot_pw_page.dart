import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';

class ForgotPwPage extends StatelessWidget {
  const ForgotPwPage({super.key});

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
              TtText(
                "Forget Password",
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
              12.gh,
              TtText(
                StringUtils.enterMailOfRegisteredAccount,
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
              Container(
                width: double.infinity,
                child: TtButton(
                  onTap: () {
                    context.push(Routes.forgotCodeVerify);
                  },
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
