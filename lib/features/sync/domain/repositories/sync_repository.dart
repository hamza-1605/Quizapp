import 'package:quiz_app/features/sync/domain/entities/sync_result.dart';

abstract interface class SyncRepository {
  Future<int?> getStoredVersion();

  Future<DateTime?> getLastCheckedAt();

  Future<void> markChecked();

  
  Future<int> fetchRemoteVersion({
    void Function()? onSlowResponse
  });

  Future<SyncUpdated> downloadAndReplaceContent({
    void Function()? onSlowResponse,
  });

  Future<List<String>> getImageUrls();
}