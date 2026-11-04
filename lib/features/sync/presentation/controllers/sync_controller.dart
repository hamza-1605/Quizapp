import 'package:get/get.dart';
import 'package:quiz_app/core/errors/app_exception.dart';
import 'package:quiz_app/features/sync/domain/entities/sync_result.dart';
import 'package:quiz_app/features/sync/domain/usecases/get_last_checked_at_usecase.dart';
import 'package:quiz_app/features/sync/domain/usecases/sync_content_usecase.dart';

class SyncController extends GetxController {
  SyncController({
    required this._syncContentUsecase,
    required this._getLastCheckedAtUsecase,
  });

  final SyncContentUsecase _syncContentUsecase;
  final GetLastCheckedAtUsecase _getLastCheckedAtUsecase;

  final isSyncing = false.obs;
  final isServerSlow = false.obs;
  final lastResult = Rxn<SyncResult>();
  final lastCheckedAt = Rxn<DateTime>();

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
    if (isSyncing.value) return; // never run two syncs at once
    isSyncing.value = true;
    isServerSlow.value = false;
    try {
      lastResult.value = await _syncContentUsecase(
        onSlowResponse: () => isServerSlow.value = true,
      );
      await _loadLastChecked();
    } 
    finally {
      isSyncing.value = false;
      isServerSlow.value = false;
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