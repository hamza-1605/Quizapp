import 'package:quiz_app/features/settings/domain/repositories/settings_repository.dart';

class SetSoundEnabledUsecase {
  SetSoundEnabledUsecase(this._repository);
  final SettingsRepository _repository;

  Future<void> call(bool value) => _repository.setSoundEnabled(value);
}