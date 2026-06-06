import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/features/features.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class RouteClass {
  static GoRouter goRouter = GoRouter(
    routes: routeList,
    initialLocation: Routes.onboarding,
    navigatorKey: rootNavigatorKey,
  );

  static List<RouteBase> routeList = [
    GoRoute(
      path: Routes.onboarding,
      builder: (context, state) {
        return OnboardingPage();
      }
    ),
  ];
}

class Routes {
  /// Routes
  static const onboarding = "/onboarding";
}
