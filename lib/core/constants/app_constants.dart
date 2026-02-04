class AppConstants {
  AppConstants._();

  static const String appName = 'Interligo';
  static const String appVersion = '1.0.0';

  // Pagination
  static const int defaultPageSize = 10;

  // Cache duration
  static const Duration cacheDuration = Duration(hours: 1);

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 350);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Debounce duration
  static const Duration debounceDuration = Duration(milliseconds: 300);
}
