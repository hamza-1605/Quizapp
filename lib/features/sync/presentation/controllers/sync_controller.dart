import 'package:get/get.dart';
import 'package:quiz_app/core/errors/app_exception.dart';
import 'package:quiz_app/features/sync/domain/entities/sync_result.dart';
import 'package:quiz_app/features/sync/domain/usecases/get_last_checked_at_usecase.dart';
import 'package:quiz_app/features/sync/domain/usecases/prefetch_images_usecase.dart';
import 'package:quiz_app/features/sync/domain/usecases/sync_content_usecase.dart';

class SyncController extends GetxController {
  SyncController({
    required this._syncContentUsecase,
    required this._getLastCheckedAtUsecase,
    required this._prefetchImagesUsecase,
  });

  final SyncContentUsecase _syncContentUsecase;
  final GetLastCheckedAtUsecase _getLastCheckedAtUsecase;
  final PrefetchImagesUsecase _prefetchImagesUsecase;

  final isSyncing = false.obs;
  final isServerSlow = false.obs;
  final isDownloadingImages = false.obs;
  final imagesDone = 0.obs;
  final imagesTotal = 0.obs;
  final lastResult = Rxn<SyncResult>();
  final lastCheckedAt = Rxn<DateTime>();

  /// True while a sync or an image download is running.
  bool get isBusy => isSyncing.value || isDownloadingImages.value;

  @override
  void onInit() {
    super.onInit();
    _loadLastChecked();
  }

  @override
  void onReady() {
    super.onReady();
    sync(); // silent check when the app starts
  }

  Future<void> sync() async {
    if (isBusy) return; // never run two syncs at once
    isSyncing.value = true;
    isServerSlow.value = false;
    SyncResult? result;
    try {
      result = await _syncContentUsecase(
        onSlowResponse: () => isServerSlow.value = true,
      );
      lastResult.value = result;
      await _loadLastChecked();
    } 
    finally {
      isSyncing.value = false;
      isServerSlow.value = false;
    }

    // Images are fetched after the content check, whether or not it changed:
    // that retries any image that failed last time.
    if (result is! SyncFailed) await _prefetchImages();
  }

  Future<void> _prefetchImages() async {
    isDownloadingImages.value = true;
    imagesDone.value = 0;
    imagesTotal.value = 0;
    try {
      await _prefetchImagesUsecase(
        onProgress: (done, total) {
          imagesDone.value = done;
          imagesTotal.value = total;
        },
      );
    } on AppException {
      // Images are a bonus: if this fails, the next sync tries again.
    } finally {
      isDownloadingImages.value = false;
    }
  }

  Future<void> _loadLastChecked() async {
    try {
      lastCheckedAt.value = await _getLastCheckedAtUsecase();
    } 
    on AppException {
      // The "last checked" text is optional, so we simply leave it empty.
    }
  }
}