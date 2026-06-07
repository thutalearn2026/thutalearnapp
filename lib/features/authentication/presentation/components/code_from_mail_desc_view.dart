import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

class CodeFromMailDescView extends StatelessWidget {
  const CodeFromMailDescView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "Enter the code we sent you to your email ",
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
          height: 1.6,
        ),
        children: [
          TextSpan(
            text: "ekzlynn@gmail.com.",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}