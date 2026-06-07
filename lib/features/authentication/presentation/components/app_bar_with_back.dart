import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';

class AppBarWithBack extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWithBack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      leading: IconButton(
        onPressed: () {
          HapticFeedback.mediumImpact();
          context.pop();
        },
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}