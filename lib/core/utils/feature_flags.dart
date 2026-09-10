class FeatureFlags {
  const FeatureFlags._();

  /// Temporarily disabled for the initial production release.
  ///
  /// Set this to true when self-registration should be available again.
  static const bool registrationEnabled = false;

  /// Uses the authenticated enrolled-courses endpoint on the Learn page.
  ///
  /// Set this to false to restore the original public course catalogue.
  static const bool enrolledCoursesOnly = true;
}
