import 'package:quiz_app/core/database/app_database.dart';
import 'package:sqflite/sqflite.dart';

class SettingsLocalDataSource {
  SettingsLocalDataSource(this._appDatabase);

  static const _soundKey = 'sound_enabled';

  final AppDatabase _appDatabase;

  Future<bool> getSoundEnabled() async {
    final db = await _appDatabase.database;
    final rows = await db.query(
      'meta',
      where: 'key = ?',
      whereArgs: [_soundKey],
      limit: 1,
    );
    if (rows.isEmpty) return true; // sound is on until the player turns it off
    return rows.first['value'] == '1';
  }


  Future<void> setSoundEnabled(bool value) async {
    final db = await _appDatabase.database;
    await db.insert(
      'meta',
      {'key': _soundKey, 'value': value ? '1' : '0'},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}