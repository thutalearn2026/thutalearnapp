class FeatureFlags {
  const FeatureFlags._();

  /// Enables the email registration and verification flow.
  static const bool registrationEnabled = true;

  /// Social authentication is not part of the current release.
  static const bool socialLoginEnabled = false;

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

  /// Displays safe initial values until progress tracking is connected.
  static const bool homePersonalStatsEnabled = true;

  /// Uses the approved temporary banner until backend banners are available.
  static const bool homeBannersEnabled = true;

  /// Shows only Quick Menu destinations backed by working features.
  static const bool homeQuickMenuEnabled = true;

  /// The AI assistant has no completed destination or service integration.
  static const bool homeAiAssistantEnabled = false;

  /// Current Learning is static sample content.
  static const bool homeCurrentLearningEnabled = false;

  /// Home review summary currently uses a fixed word count.
  static const bool homeReviewEnabled = false;

  /// Learning progress is hidden until progress data is supplied by an API.
  static const bool learningProgressEnabled = false;

  /// Level and module progress are hidden until supplied by an API.
  static const bool courseProgressEnabled = false;
  static const bool moduleProgressEnabled = false;

  /// Transcript and special notes are static placeholder content.
  static const bool lessonTranscriptEnabled = false;
  static const bool lessonSpecialNotesEnabled = false;

  /// The lesson-level favorite button is local-only and not persisted.
  static const bool lessonFavoriteEnabled = false;

  /// Pronunciation drills and vocabulary flash cards still use demo data.
  /// API-backed quiz types remain available.
  static const bool advancedPracticeEnabled = false;

  /// The profile level badge is a fixed placeholder value.
  static const bool profileLevelEnabled = false;

  /// The version tile is hidden until it reads the installed build version.
  static const bool profileVersionEnabled = false;
}
