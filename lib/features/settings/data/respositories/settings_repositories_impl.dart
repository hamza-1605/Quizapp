import 'package:quiz_app/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:quiz_app/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._localDataSource);

  final SettingsLocalDataSource _localDataSource;

  @override
  Future<bool> getSoundEnabled() => _localDataSource.getSoundEnabled();

  @override
  Future<void> setSoundEnabled(bool value) =>
      _localDataSource.setSoundEnabled(value);
}