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
      },
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) {
        return LoginPage();
      },
    ),
    GoRoute(
      path: Routes.register,
      builder: (context, state) {
        return RegisterPage();
      },
    ),
    GoRoute(
      path: Routes.regCodeVerify,
      builder: (context, state) {
        return RegCodeVerifyPage();
      },
    ),
    GoRoute(
      path: Routes.regSetPassword,
      builder: (context, state) {
        return RegSetPasswordPage();
      },
    ),
    GoRoute(
      path: Routes.forgotPassword,
      builder: (context, state) {
        return ForgotPwPage();
      },
    ),
    GoRoute(
      path: Routes.forgotCodeVerify,
      builder: (context, state) {
        return ForgotPwCodeVerifyPage();
      },
    ),
    GoRoute(
      path: Routes.forgotSetNewPassword,
      builder: (context, state) {
        return ForgotSetNewPasswordPage();
      },
    ),
  ];
}

class Routes {
  /// Routes
  static const onboarding = "/onboarding";

  /// Authentication
  static const login = "/login";
  static const register = "/register";
  static const regCodeVerify = "/reg-code-verify";
  static const regSetPassword = "/reg-set-password";
  static const forgotPassword = "/forgot-password";
  static const forgotCodeVerify = "/forgot-code-verify";
  static const forgotSetNewPassword = "/forgot-set-new-password";
}
