import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/core/core.dart';

import '../../../authentication/data/data_sources/box/auth_session_box.dart';
import '../../../onboarding/data/data_sources/box/onboarding_box.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _navigationTimer = Timer(
      const Duration(seconds: 3),
      _navigateToApplication,
    );
  }

  void _navigateToApplication() {
    if (!mounted) {
      return;
    }

    final nextRoute = _resolveNextRoute();

    context.go(nextRoute);
  }

  String _resolveNextRoute() {
    final hasCompletedOnboarding = OnboardingBox.hasCompletedOnboarding;

    if (!hasCompletedOnboarding) {
      return Routes.onboarding;
    }

    if (AuthSessionBox.isLoggedIn) {
      return Routes.bottomNav;
    }

    return Routes.login;
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: ColorUtils.primaryColor,
      ),
      child: Scaffold(
        backgroundColor: ColorUtils.primaryColor,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: Center(
                  child: Image.asset(
                    ImageUtils.logo,
                    width: 160,
                    height: 160,
                    fit: BoxFit.contain,
                    errorBuilder:
                        (
                          context,
                          error,
                          stackTrace,
                        ) {
                          // Temporary fallback until logo.png
                          // is added.
                          return Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                            child: const Icon(
                              Icons.school_outlined,
                              size: 50,
                              color: Colors.white,
                            ),
                          );
                        },
                  ),
                ),
              ),
              const Positioned(
                left: 24,
                right: 24,
                bottom: 28,
                child: SplashFooterView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SplashFooterView extends StatelessWidget {
  const SplashFooterView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TtText(
          'Master Thai for your next chapter',
          fontSize: 14,
          textAlign: TextAlign.center,
          color: Colors.white,
        ),
        SizedBox(height: 16),
        SplashLoadingIndicator(),
      ],
    );
  }
}

class SplashLoadingIndicator extends StatelessWidget {
  const SplashLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SplashLoadingDot(size: 8),
        SizedBox(width: 7),
        SplashLoadingDot(size: 10),
        SizedBox(width: 7),
        SplashLoadingDot(size: 8),
      ],
    );
  }
}

class SplashLoadingDot extends StatelessWidget {
  final double size;

  const SplashLoadingDot({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: ColorUtils.secondaryColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
