import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thuta_learn/core/core.dart';

class DoNotHaveAccountSectionView extends StatelessWidget {

  final String content;
  final String actionButton;
  final Function onTap;

  const DoNotHaveAccountSectionView({
    super.key,
    required this.content,
    required this.actionButton,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
          text: "$content ",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: actionButton,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: ColorUtils.secondaryColor,
                decoration: TextDecoration.underline,
                decorationColor: ColorUtils.secondaryColor,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  HapticFeedback.mediumImpact();
                  onTap();
                },
            ),
          ],
        ),
      ),
    );
  }
}