abstract class ApiConstants {
  static const baseUrl = 'https://quiz-backend-six-alpha.vercel.app';
  static const versionPath = '/api/content/version';
  static const syncPath = '/api/content/sync';

  /// The free-tier server of Neon can take 20-60 seconds to wake up.
  static const versionTimeout = Duration(seconds: 75);
  static const syncTimeout = Duration(seconds: 90);

  /// If no answer arrives within this time, the UI says "server is waking up".
  static const slowResponseThreshold = Duration(seconds: 4);
}