abstract interface class SettingsRepository {
  Future<bool> getSoundEnabled();

  Future<void> setSoundEnabled(bool value);
}