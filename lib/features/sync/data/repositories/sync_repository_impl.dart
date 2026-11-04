import 'package:quiz_app/core/errors/app_exception.dart';
import 'package:quiz_app/features/sync/data/datasources/sync_local_data_source.dart';
import 'package:quiz_app/features/sync/data/datasources/sync_remote_data_source.dart';
import 'package:quiz_app/features/sync/domain/entities/sync_result.dart';
import 'package:quiz_app/features/sync/domain/repositories/sync_repository.dart';
import 'package:sqflite/sqflite.dart';

class SyncRepositoryImpl implements SyncRepository {
  SyncRepositoryImpl({
    required SyncRemoteDataSource remoteDataSource,
    required SyncLocalDataSource localDataSource,
  })  : _remote = remoteDataSource,
        _local = localDataSource;

  final SyncRemoteDataSource _remote;
  final SyncLocalDataSource _local;

  @override
  Future<int?> getStoredVersion() => _guardStorage(_local.getStoredVersion);

  @override
  Future<DateTime?> getLastCheckedAt() => _guardStorage(_local.getLastCheckedAt);

  @override
  Future<void> markChecked() => _guardStorage(() => _local.saveLastCheckedAt(DateTime.now()));


  @override
  Future<int> fetchRemoteVersion({void Function()? onSlowResponse}) =>
      _remote.fetchVersion(onSlowResponse: onSlowResponse);

  @override
  Future<SyncUpdated> downloadAndReplaceContent({
    void Function()? onSlowResponse,
  }) async {
    final content = await _remote.fetchContent(onSlowResponse: onSlowResponse);
    final summary = await _guardStorage(() => _local.replaceContent(content));
    return SyncUpdated(
      categories: summary.categories,
      questions: summary.questions,
      questionsAdded: summary.questionsAdded,
    );
  }


  // Turns database errors into our own exception type.
  Future<T> _guardStorage<T>(Future<T> Function() action) async {
    try {
      return await action();
    } 
    on DatabaseException {
      throw const StorageException('Could not save the content on this device.');
    }
  }
}