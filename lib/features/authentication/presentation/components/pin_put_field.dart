import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:thuta_learn/core/core.dart';

class PinPutField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onCompleted;

  const PinPutField({
    super.key,
    this.controller,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ColorUtils.textFieldBackgroundColor,
      ),
    );

    return Pinput(
      controller: controller,
      length: 6,
      keyboardType: TextInputType.number,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: defaultPinTheme.copyDecorationWith(
        border: Border.all(color: ColorUtils.primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      submittedPinTheme: defaultPinTheme.copyDecorationWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
      showCursor: true,
      onCompleted: onCompleted,
    );
  }
}
