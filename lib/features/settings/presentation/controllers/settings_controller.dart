import 'package:get/get.dart';
import 'package:quiz_app/features/settings/domain/usecases/get_sound_enabled_usecase.dart';
import 'package:quiz_app/features/settings/domain/usecases/set_sound_enabled_usecase.dart';

class SettingsController extends GetxController {
  SettingsController(this._getSoundEnabledUsecase, this._setSoundEnabledUsecase);

  final GetSoundEnabledUsecase _getSoundEnabledUsecase;
  final SetSoundEnabledUsecase _setSoundEnabledUsecase;

  final isSoundOn = true.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    try {
      isSoundOn.value = await _getSoundEnabledUsecase();
    } on Exception {
      // Keep the default (on) if the setting can't be read.
    }
  }

  Future<void> setSound(bool value) async {
    isSoundOn.value = value; // update the screen first, then save
    try {
      await _setSoundEnabledUsecase(value);
    } on Exception {
      // The switch still works for this session if saving fails.
    }
  }
}