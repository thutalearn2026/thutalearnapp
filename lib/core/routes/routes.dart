import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/features/features.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class RouteClass {
  static GoRouter goRouter = GoRouter(
    routes: routeList,
    initialLocation: Routes.onboarding,
    // initialLocation: Routes.accountSetUp,
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
    GoRoute(
      path: Routes.accountSetUp,
      builder: (context, state) {
        return AccountSetUpPage();
      },
    ),
    GoRoute(
      path: Routes.bottomNav,
      builder: (context, state) {
        return BottomNav();
      }
    ),
    GoRoute(
      path: Routes.moduleDetail,
      builder: (context, state) {
        final module = state.extra as LearnModuleItem;

        return ModuleDetailPage(
          module: module,
        );
      },
    ),

    GoRoute(
      path: Routes.lessonDetail,
      builder: (context, state) {
        final lesson = state.extra as ModuleLessonItem;

        return LessonDetailPage(
          lesson: lesson,
        );
      },
    ),
    GoRoute(
      path: Routes.quiz,
      builder: (context, state) {
        return const QuizPage();
      },
    ),
    GoRoute(
      path: Routes.pronunciationDrill,
      builder: (context, state) {
        return const PronunciationDrillPage();
      },
    ),
    GoRoute(
      path: Routes.vocabularyFlashCards,
      builder: (context, state) {
        return const VocabularyFlashCardPage();
      },
    ),
    GoRoute(
      path: Routes.editProfile,
      builder: (context, state) {
        return const ProfileEditPage();
      },
    ),
    GoRoute(
      path: Routes.changePassword,
      builder: (context, state) {
        return const ProfileChangePasswordPage();
      },
    ),
    GoRoute(
      path: Routes.certificates,
      builder: (context, state) {
        return const CertificatesPage();
      },
    ),
    GoRoute(
      path: Routes.learningProgress,
      builder: (context, state) {
        return const LearningProgressPage();
      },
    ),
    GoRoute(
      path: Routes.savedVocabulary,
      builder: (context, state) {
        return const SavedVocabularyPage();
      },
    ),

    GoRoute(
      path: Routes.search,
      builder: (context, state) {
        return const SearchPage();
      },
    ),
    GoRoute(
      path: Routes.searchResults,
      builder: (context, state) {
        final query = state.extra as String? ?? '';

        return SearchResultsPage(
          query: query,
        );
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
  static const accountSetUp = "/account-set-up";

  /// Home
  static const bottomNav = "/bottom-nav";
  /// Learn
  static const moduleDetail = '/module-detail';
  static const lessonDetail = '/lesson-detail';
  static const quiz = '/quiz';
  static const pronunciationDrill =
      '/pronunciation-drill';
  static const vocabularyFlashCards =
      '/vocabulary-flash-cards';
  static const editProfile = '/edit-profile';
  static const changePassword = '/change-password';
  static const certificates = '/certificates';
  static const learningProgress = '/learning-progress';
  static const savedVocabulary = '/saved-vocabulary';

  static const search = '/search';
  static const searchResults = '/search-results';
}
