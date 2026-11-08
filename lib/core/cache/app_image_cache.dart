import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// The one image cache the whole app shares.

// The default cache keeps only 200 files. We raise the limit and the
// retention time, because offline use depends on images staying on disk.
class AppImageCache {
  static final CacheManager instance = CacheManager(
    Config(
      'quizAppImages',
      stalePeriod: const Duration(days: 365),
      maxNrOfCacheObjects: 2000,
    ),
  );
}