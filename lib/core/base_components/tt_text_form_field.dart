import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thuta_learn/core/core.dart';

class TtTextFormField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final TextInputType? textInputType;

  const TtTextFormField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSaved,
    this.validator,
    this.textInputType,
  });

  @override
  State<TtTextFormField> createState() => _TtTextFormFieldState();
}

class _TtTextFormFieldState extends State<TtTextFormField> {

  bool isHiddenPassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.isPassword ? isHiddenPassword : false,
      onSaved: widget.onSaved,
      keyboardType: widget.textInputType,
      validator: widget.validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: ColorUtils.textFieldBackgroundColor,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  setState(() {
                    isHiddenPassword = !isHiddenPassword;
                  });
                },
                icon: Icon(
                  isHiddenPassword ? Icons.visibility : Icons.visibility_off,
                  color: ColorUtils.hintColor,
                ),
              )
            : widget.suffixIcon,
        contentPadding: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: ColorUtils.primaryColor.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        hintStyle: TextStyle(
          fontSize: 14,
          color: ColorUtils.hintColor,
        ),
      ),
    );
  }
}
