import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

class SearchInputBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClose;

  const SearchInputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.text,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              cursorColor: ColorUtils.secondaryColor,
              style: const TextStyle(
                fontFamily: 'helvetica_neue',
                fontSize: 14,
                color: ColorUtils.primaryColor,
              ),
              decoration: const InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                  fontFamily: 'helvetica_neue',
                  fontSize: 14,
                  color: ColorUtils.greyTextColor,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: ColorUtils.primaryColor,
                  size: 26,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ),
        12.gw,
        TtZoomTap(
          onTap: onClose,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.close_rounded,
              color: ColorUtils.primaryColor,
              size: 27,
            ),
          ),
        ),
      ],
    );
  }
}