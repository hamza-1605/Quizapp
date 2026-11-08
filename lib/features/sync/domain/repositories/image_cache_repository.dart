abstract interface class ImageCacheRepository {
  // Downloads every URL that is not in the cache yet.
  // Never throws: images that fail are simply skipped.
  Future<void> prefetch(
    List<String> urls, {
    void Function(int done, int total)? onProgress,
  });
}