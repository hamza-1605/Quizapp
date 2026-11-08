import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:quiz_app/features/sync/domain/repositories/image_cache_repository.dart';

class ImageCacheRepositoryImpl implements ImageCacheRepository {
  ImageCacheRepositoryImpl(this._cacheManager);

  static const _parallelDownloads = 3;
  static const _downloadTimeout = Duration(seconds: 30);

  final CacheManager _cacheManager;

  @override
  Future<void> prefetch(
    List<String> urls, {
    void Function(int done, int total)? onProgress,
  }) async {
    final unique = urls.toSet();
    final pending = <String>[];
    for (final url in unique) {
      if (await _cacheManager.getFileFromCache(url) == null) {
        pending.add(url);
      }
    }
    debugPrint( 'Image cache: ${pending.length} of ${unique.length} images to download');
    if (pending.isEmpty) return;

    var done = 0;
    onProgress?.call(done, pending.length);
    for (var i = 0; i < pending.length; i += _parallelDownloads) {
      final batch = pending.skip(i).take(_parallelDownloads).toList();
      await Future.wait(batch.map(_download));
      done += batch.length;
      onProgress?.call(done, pending.length);
    }
  }


  Future<void> _download(String url) async {
    try {
      await _cacheManager.downloadFile(url).timeout(_downloadTimeout);
    } catch (e) {
      debugPrint('Image download failed: $url ($e)');
    }
  }
}