import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

class ProfileSettingTile extends StatelessWidget {
  final String title;
  final Color titleColor;
  final Widget? trailing;
  final bool showArrow;
  final VoidCallback? onTap;

  const ProfileSettingTile({
    super.key,
    required this.title,
    this.titleColor = ColorUtils.primaryColor,
    this.trailing,
    this.showArrow = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      constraints: const BoxConstraints(minHeight: 52),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: TtText(
              title,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: titleColor,
            ),
          ),
          if (trailing != null) ...[
            trailing!,
            if (showArrow) 8.gw,
          ],
          if (showArrow)
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 17,
              color: ColorUtils.primaryColor,
            ),
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return TtZoomTap(
      onTap: onTap!,
      child: content,
    );
  }
}