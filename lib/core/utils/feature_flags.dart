class FeatureFlags {
  const FeatureFlags._();

  /// Enables self-registration from the Login page.
  static const bool registrationEnabled = true;

  /// false = show every available course using the public course catalogue.
  /// true  = show only courses purchased by the logged-in user.
  ///
  /// Keep this false because the PM changed the Learn page back
  /// to displaying all available courses.
  static const bool enrolledCoursesOnly = false;

  /// Displays the notification button on the Home page.
  static const bool notificationsEnabled = true;

  /// Displays the Continue Learning section on the Home page.
  static const bool continueLearningEnabled = true;

  /// Displays Real-life Scenarios below the chapter video list.
  static const bool realLifeScenariosEnabled = true;

  /// Enables the Search UI and Search Results flow.
  static const bool searchEnabled = true;
}