import 'package:quiz_app/core/errors/app_exception.dart';
import 'package:quiz_app/features/sync/domain/entities/sync_result.dart';
import 'package:quiz_app/features/sync/domain/repositories/sync_repository.dart';

class SyncContentUsecase {
  SyncContentUsecase(this._repository);
  final SyncRepository _repository;

  Future<SyncResult> call({void Function()? onSlowResponse}) async {
    try {
      final storedVersion = await _repository.getStoredVersion();
      final remoteVersion = await _repository.fetchRemoteVersion(
        onSlowResponse: onSlowResponse,
      );

      if (storedVersion == remoteVersion) {
        await _repository.markChecked();
        return const SyncUpToDate();
      }

      return await _repository.downloadAndReplaceContent(
        onSlowResponse: onSlowResponse,
      );
    } 
    on AppException catch (e) {
      return SyncFailed(e.message);
    }
  }
}