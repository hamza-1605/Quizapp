import 'package:quiz_app/features/sync/domain/repositories/sync_repository.dart';

class GetLastCheckedAtUsecase {
  GetLastCheckedAtUsecase(this._repository);

  final SyncRepository _repository;

  Future<DateTime?> call() => _repository.getLastCheckedAt();
}