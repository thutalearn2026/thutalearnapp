import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thuta_learn/core/core.dart';

class ProfileEditInformationCard extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController phoneController;
  final String email;

  const ProfileEditInformationCard({
    super.key,
    required this.usernameController,
    required this.phoneController,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE1E5EA),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          ProfileEditableFieldRow(
            label: 'Username',
            controller: usernameController,
            textInputAction: TextInputAction.done,
          ),
          const Divider(
            height: 1,
            color: Color(0xFFE5E8EC),
          ),
          ProfileEmailRow(email: email),
          const Divider(
            height: 1,
            color: Color(0xFFE5E8EC),
          ),
          ProfileEditableFieldRow(
            label: 'Phone Number',
            controller: phoneController,
            hintText: '--',
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'[0-9+\-\s()]'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileEditableFieldRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  const ProfileEditableFieldRow({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 64),
      child: Row(
        children: [
          Expanded(
            child: TtText(
              label,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ColorUtils.primaryColor,
            ),
          ),
          16.gw,
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              inputFormatters: inputFormatters,
              textAlign: TextAlign.right,
              cursorColor: ColorUtils.secondaryColor,
              style: const TextStyle(
                fontFamily: 'helvetica_neue',
                fontSize: 14,
                color: ColorUtils.primaryColor,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  fontFamily: 'helvetica_neue',
                  fontSize: 14,
                  color: Color(0xFFA4AFBF),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileEmailRow extends StatelessWidget {
  final String email;

  const ProfileEmailRow({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 64),
      child: Row(
        children: [
          const Expanded(
            child: TtText(
              'Email',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ColorUtils.primaryColor,
            ),
          ),
          12.gw,
          const _GoogleIcon(),
          10.gw,
          Flexible(
            child: TtText(
              email,
              fontSize: 14,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              color: ColorUtils.greyTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: const Color(0xFFE4E7EB),
        ),
      ),
      child: const TtText(
        'G',
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF4285F4),
      ),
    );
  }
}