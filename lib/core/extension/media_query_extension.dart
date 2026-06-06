import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

extension MediaQueryExtension on BuildContext {
  bool get isMobile {
    return Device.screenType == ScreenType.mobile;
  }
}