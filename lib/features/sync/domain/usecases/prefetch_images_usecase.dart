import 'package:quiz_app/features/sync/domain/repositories/image_cache_repository.dart';
import 'package:quiz_app/features/sync/domain/repositories/sync_repository.dart';

class PrefetchImagesUsecase {
  PrefetchImagesUsecase(this._syncRepository, this._imageCacheRepository);

  final SyncRepository _syncRepository;
  final ImageCacheRepository _imageCacheRepository;

  Future<void> call({void Function(int done, int total)? onProgress}) async {
    final urls = await _syncRepository.getImageUrls();
    await _imageCacheRepository.prefetch(urls, onProgress: onProgress);
  }
}