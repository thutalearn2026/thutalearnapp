import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:thuta_learn/core/base_components/tt_responsive_app_frame.dart';

extension MediaQueryExtension on BuildContext {
  bool get isMobile {
    return !isTablet;
  }

  bool get isTablet {
    final responsiveScope = TtResponsiveScope.maybeOf(this);

    if (responsiveScope != null) {
      return responsiveScope.isTablet;
    }

    return TtResponsiveAppFrame.isTabletSize(
      MediaQuery.sizeOf(this),
    );
  }

  bool get isLandscape {
    final responsiveScope = TtResponsiveScope.maybeOf(this);

    if (responsiveScope != null) {
      return responsiveScope.orientation == Orientation.landscape;
    }

    return MediaQuery.orientationOf(this) == Orientation.landscape;
  }

  int adaptiveGridColumnCount({
    int mobile = 2,
    int tabletPortrait = 3,
    int tabletLandscape = 4,
  }) {
    if (!isTablet) {
      return mobile;
    }

    return isLandscape ? tabletLandscape : tabletPortrait;
  }

  double get getDeviceHeight {
    return Device.height;
  }
}
