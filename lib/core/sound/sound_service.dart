import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:quiz_app/features/settings/presentation/controllers/settings_controller.dart';

// Every sound effect in the app, with its file and loudness (0 to 1).
enum Sfx {
  correct('sounds/correct.mp3', 0.6, 1),
  wrong('sounds/wrong.wav', 0.6, 1),
  click('sounds/click.wav', 0.4, 4),
  tick('sounds/tick.mp3', 0.5, 2),
  celebrate('sounds/celebrate.mp3', 0.7, 1);

  const Sfx(this.assetPath, this.volume, this.maxPlayers);

  // Relative to the assets/ folder.
  final String assetPath;
  final double volume;
  final int maxPlayers;
}

class SoundService {
  SoundService(this._settings);

  final SettingsController _settings;
  final Map<Sfx, AudioPool> _pools = {};

  // Prepares a pool of ready players for each sound. Never throws: a
  // missing file just means that sound stays silent.
  Future<void> init() async {
    for (final sfx in Sfx.values) {
      try {
        _pools[sfx] = await AudioPool.createFromAsset(
          path: sfx.assetPath,
          maxPlayers: sfx.maxPlayers,
        );
      } on Object catch (e) {
        debugPrint('Sound ${sfx.name} could not be loaded: $e');
      }
    }
  }

  // Plays a sound, unless the player turned sound off in Settings.
  Future<void> play(Sfx sfx) async {
    if (!_settings.isSoundOn.value) return;
    final pool = _pools[sfx];
    if (pool == null) return;
    try {
      await pool.start(volume: sfx.volume);
    } on Object catch (e) {
      debugPrint('Sound ${sfx.name} failed: $e');
    }
  }
}

// The faint tap sound used by buttons and tiles.
void playClick() => Get.find<SoundService>().play(Sfx.click);