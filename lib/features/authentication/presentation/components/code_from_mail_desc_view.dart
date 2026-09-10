import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

class CodeFromMailDescView extends StatelessWidget {
  final String email;

  const CodeFromMailDescView({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          height: 1.5,
        ),
        children: [
          const TextSpan(
            text: 'Enter the code we sent you to your email\n',
          ),
          TextSpan(
            text: '$email.',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}