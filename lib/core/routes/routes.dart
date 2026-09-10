import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thuta_learn/features/features.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class RouteClass {
  static GoRouter goRouter = GoRouter(
    routes: routeList,
    initialLocation: Routes.splash,
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
        final args = state.extra as RegisterVerifyArgs;

        return RegCodeVerifyPage(args: args);
      },
    ),

    GoRoute(
      path: Routes.regSetPassword,
      builder: (context, state) {
        final args = state.extra as RegisterCompleteArgs;

        return RegSetPasswordPage(args: args);
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
        final args = state.extra as ForgotPasswordVerifyArgs;

        return ForgotPwCodeVerifyPage(
          args: args,
        );
      },
    ),

    GoRoute(
      path: Routes.forgotSetNewPassword,
      builder: (context, state) {
        final args = state.extra as ResetPasswordArgs;

        return ForgotSetNewPasswordPage(
          args: args,
        );
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
      path: Routes.courseDetail,
      builder: (context, state) {
        final courseId = state.extra as String;

        return CourseDetailPage(
          courseId: courseId,
        );
      },
    ),
    GoRoute(
      path: Routes.moduleDetail,
      builder: (context, state) {
        final args = state.extra as ModuleDetailArgs;

        return ModuleDetailPage(
          args: args,
        );
      },
    ),

    GoRoute(
      path: Routes.lessonDetail,
      builder: (context, state) {
        final args = state.extra as LessonDetailArgs;

        return LessonDetailPage(
          args: args,
        );
      },
    ),
    GoRoute(
      path: Routes.quiz,
      builder: (context, state) {
        final args = state.extra as QuizDetailArgs;

        return QuizPage(
          args: args,
        );
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
        final profile = state.extra as ProfileModel;

        return ProfileEditPage(
          profile: profile,
        );
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

    GoRoute(
      path: Routes.splash,
      builder: (context, state) {
        return const SplashPage();
      },
    ),

    GoRoute(
      path: Routes.resourceDetail,
      builder: (context, state) {
        final args = state.extra as ResourceDetailArgs;

        return ResourceDetailPage(
          args: args,
        );
      },
    ),

    GoRoute(
      path: Routes.privacyPolicy,
      builder: (context, state) {
        return const LegalWebViewPage(
          title: 'Privacy Policy',
          url: 'https://thutalearn.com/privacy-policy',
        );
      },
    ),

    GoRoute(
      path: Routes.termsOfUse,
      builder: (context, state) {
        return const LegalWebViewPage(
          title: 'Terms of Use',
          url:
          'https://thutalearn.com/terms-and-conditions',
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
  static const courseDetail = '/course-detail';
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
  static const splash = '/splash';

  static const resourceDetail = '/resource-detail';

  static const privacyPolicy = '/privacy-policy';
  static const termsOfUse = '/terms-of-use';
}
