import 'package:quiz_app/features/settings/domain/repositories/settings_repository.dart';

class GetSoundEnabledUsecase {
  GetSoundEnabledUsecase(this._repository);
  final SettingsRepository _repository;

  Future<bool> call() => _repository.getSoundEnabled();
}