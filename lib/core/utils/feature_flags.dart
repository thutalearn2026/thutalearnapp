class FeatureFlags {
  const FeatureFlags._();

  /// Temporarily disabled for the initial production release.
  ///
  /// Set this to true when self-registration should be available again.
  static const bool registrationEnabled = false;

  /// Uses the authenticated enrolled-courses endpoint on the Learn page.
  ///
  /// Set this to false to restore the original public course catalogue.
  static const bool enrolledCoursesOnly = false;

  /// Temporarily hides the Home notification entry point for Phase 1.
  ///
  /// Set this to true when the notification feature is ready for release.
  static const bool notificationsEnabled = false;

  /// Temporarily hides Continue Learning until lesson-progress
  /// tracking is available.
  static const bool continueLearningEnabled = false;

  /// Temporarily hides Real-life Scenarios from module lessons for Phase 1.
  ///
  /// Set this to true when the scenario feature is ready for release.
  static const bool realLifeScenariosEnabled = false;

  /// Temporarily replaces Search with a coming-soon state for Phase 1.
  ///
  /// Set this to true when the Search API and result flow are ready.
  static const bool searchEnabled = false;
}
