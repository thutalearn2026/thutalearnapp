import 'package:flutter/material.dart';

/// Provides one responsive canvas for every application route.
///
/// Phone layouts are returned unchanged. On tablets, the complete application
/// remains full-screen while its logical viewport is reduced slightly and then
/// scaled to the available display. This makes fonts, controls, cards, icons,
/// and spacing larger without adding side gutters or changing phone designs.
class TtResponsiveAppFrame extends StatelessWidget {
  final Widget child;

  const TtResponsiveAppFrame({
    super.key,
    required this.child,
  });

  static const double tabletBreakpoint = 600;
  static const double tabletPortraitScale = 1.15;
  static const double tabletLandscapeScale = 1.10;

  static bool isTabletSize(Size size) {
    return size.shortestSide >= tabletBreakpoint;
  }

  static double scaleFor(Size size) {
    if (!isTabletSize(size)) {
      return 1;
    }

    return size.width > size.height
        ? tabletLandscapeScale
        : tabletPortraitScale;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;

    // This is intentionally a direct return so the existing mobile widget
    // tree, constraints, spacing, and visual design remain unchanged.
    if (!isTabletSize(screenSize)) {
      return child;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableSize = Size(
          constraints.maxWidth,
          constraints.maxHeight,
        );
        final scale = scaleFor(screenSize);
        final logicalSize = Size(
          availableSize.width / scale,
          availableSize.height / scale,
        );

        final scaledMediaQuery = mediaQuery.copyWith(
          size: logicalSize,
          padding: _divideInsets(
            mediaQuery.padding,
            scale,
          ),
          viewPadding: _divideInsets(
            mediaQuery.viewPadding,
            scale,
          ),
          viewInsets: _divideInsets(
            mediaQuery.viewInsets,
            scale,
          ),
          systemGestureInsets: _divideInsets(
            mediaQuery.systemGestureInsets,
            scale,
          ),
        );

        return SizedBox.expand(
          child: FittedBox(
            key: const ValueKey(
              'tablet-responsive-frame',
            ),
            fit: BoxFit.fill,
            alignment: Alignment.topLeft,
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              width: logicalSize.width,
              height: logicalSize.height,
              child: MediaQuery(
                data: scaledMediaQuery,
                child: TtResponsiveScope(
                  isTablet: true,
                  orientation: screenSize.width > screenSize.height
                      ? Orientation.landscape
                      : Orientation.portrait,
                  scale: scale,
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static EdgeInsets _divideInsets(
    EdgeInsets insets,
    double scale,
  ) {
    return EdgeInsets.fromLTRB(
      insets.left / scale,
      insets.top / scale,
      insets.right / scale,
      insets.bottom / scale,
    );
  }
}

class TtResponsiveScope extends InheritedWidget {
  final bool isTablet;
  final Orientation orientation;
  final double scale;

  const TtResponsiveScope({
    super.key,
    required this.isTablet,
    required this.orientation,
    required this.scale,
    required super.child,
  });

  static TtResponsiveScope? maybeOf(
    BuildContext context,
  ) {
    return context.dependOnInheritedWidgetOfExactType<TtResponsiveScope>();
  }

  @override
  bool updateShouldNotify(
    TtResponsiveScope oldWidget,
  ) {
    return isTablet != oldWidget.isTablet ||
        orientation != oldWidget.orientation ||
        scale != oldWidget.scale;
  }
}
