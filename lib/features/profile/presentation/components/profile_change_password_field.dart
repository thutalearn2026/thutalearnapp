import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

class ProfileChangePasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;

  const ProfileChangePasswordField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.textInputAction,
    this.validator,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<ProfileChangePasswordField> createState() =>
      _ProfileChangePasswordFieldState();
}

class _ProfileChangePasswordFieldState
    extends State<ProfileChangePasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      obscuringCharacter: '•',
      textInputAction: widget.textInputAction,
      keyboardType: TextInputType.visiblePassword,
      enableSuggestions: false,
      autocorrect: false,
      // textScaler: const TextScaler.linear(1),
      autovalidateMode:
      AutovalidateMode.onUserInteraction,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: (_) {
        widget.onSubmitted?.call();
      },
      cursorColor: ColorUtils.secondaryColor,
      style: const TextStyle(
        fontFamily: 'helvetica_neue',
        fontSize: 14,
        color: ColorUtils.primaryColor,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          fontFamily: 'helvetica_neue',
          fontSize: 14,
          color: Color(0xFFB9B9B9),
        ),
        filled: true,
        fillColor: const Color(0xFFF0F0F0),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 20,
        ),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(
            left: 12,
            right: 10,
          ),
          child: Icon(
            Icons.lock_outline_rounded,
            color: Color(0xFF9C9C9C),
            size: 26,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 50,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          icon: Icon(
            _obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: const Color(0xFFB5B5B5),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: ColorUtils.secondaryColor,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        errorStyle: const TextStyle(
          fontFamily: 'helvetica_neue',
          fontSize: 12,
          color: Colors.red,
        ),
      ),
    );
  }
}