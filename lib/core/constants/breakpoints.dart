class Breakpoints {
  Breakpoints._();

  /// Minimum width threshold where screen transitions from compact mobile to tablet/desktop.
  static const double largeScreenMinWidth = 600.0;

  /// Minimum width threshold for side-by-side split-screen hero layout.
  static const double desktopMinWidth = 900.0;

  /// Optimal maximum width for single-column auth form cards to prevent horizontal stretching.
  static const double maxFormCardWidth = 460.0;

  /// Maximum container width for desktop split-layout auth views.
  static const double maxSplitLayoutWidth = 1000.0;
}
