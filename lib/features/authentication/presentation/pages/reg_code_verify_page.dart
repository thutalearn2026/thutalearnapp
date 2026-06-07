import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/features/authentication/authentication.dart';
import 'package:thuta_learn/core/core.dart';

class RegCodeVerifyPage extends StatelessWidget {
  const RegCodeVerifyPage({super.key});

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
                StringUtils.codeVerification,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
              12.gh,
              CodeFromMailDescView(),
              20.gh,
              PinPutField(),
              8.gh,
              Align(
                alignment: Alignment.centerRight,
                child: TtText(
                  "00 : 24",
                ),
              ),
              16.gh,
              Container(
                width: double.infinity,
                child: TtButton(
                  onTap: () {
                    context.push(Routes.regSetPassword);
                  },
                  child: TtText(
                    StringUtils.verify,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              8.gh,
              Container(
                width: double.infinity,
                child: TtButton(
                  backgroundColor: Colors.transparent,
                  onTap: () {},
                  child: TtText(
                    StringUtils.resendCode,
                    color: Colors.black,
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
