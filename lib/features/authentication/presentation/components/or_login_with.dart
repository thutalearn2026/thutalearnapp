import 'package:flutter/material.dart';
import 'package:thuta_learn/core/core.dart';

class OrLoginWith extends StatelessWidget {
  final String label;

  const OrLoginWith({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Color.fromRGBO(239, 230, 250, 1.0),
          ),
        ),
        TtText(
          label,
          color: ColorUtils.hintColor,
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Color.fromRGBO(239, 230, 250, 1.0),
          ),
        ),
      ],
    );
  }
}
