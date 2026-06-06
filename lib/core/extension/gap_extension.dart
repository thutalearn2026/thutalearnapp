import 'package:flutter/material.dart';

extension GapExtension on int {
  Widget get gw {
    return SizedBox(width: toDouble());
  }

  Widget get gh {
    return SizedBox(height: toDouble());
  }
}
