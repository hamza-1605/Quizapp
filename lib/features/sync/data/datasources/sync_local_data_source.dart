import 'package:quiz_app/core/database/app_database.dart';
import 'package:quiz_app/features/sync/data/models/sync_content_model.dart';
import 'package:sqflite/sqflite.dart';

class SyncLocalDataSource {
  SyncLocalDataSource(this._appDatabase);

  static const _versionKey = 'content_version';
  static const _lastCheckedKey = 'last_checked_at';

  final AppDatabase _appDatabase;

  Future<int?> getStoredVersion() async {
    final value = await _getMeta(_versionKey);
    return value == null ? null : int.tryParse(value);
  }

  Future<DateTime?> getLastCheckedAt() async {
    final value = await _getMeta(_lastCheckedKey);
    return value == null ? null : DateTime.tryParse(value)?.toLocal();
  }

  Future<void> saveLastCheckedAt(DateTime time) async {
    final db = await _appDatabase.database;
    await db.insert(
      'meta',
      {'key': _lastCheckedKey, 'value': time.toUtc().toIso8601String()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  /// Replaces all categories, questions and options in ONE transaction.
  /// If anything fails, nothing changes and the old version stays stored.
  Future<({int categories, int questions, int questionsAdded})> replaceContent(
    SyncContentModel content,
  ) async {
    final db = await _appDatabase.database;
    return db.transaction((txn) async {
      final oldIds = (await txn.query('questions', columns: ['id']))
          .map((row) => row['id'] as int)
          .toSet();

      // Cascade deletes the questions and options of every category.
      await txn.delete('categories');

      final batch = txn.batch();
      for (final category in content.categories) {
        batch.insert('categories', category.toMap());
      }
      for (final question in content.questions) {
        batch.insert('questions', question.toMap());
        for (final option in question.optionMaps()) {
          batch.insert('options', option);
        }
      }
      batch.insert(
        'meta',
        {'key': _versionKey, 'value': '${content.version}'},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      batch.insert(
        'meta',
        {
          'key': _lastCheckedKey,
          'value': DateTime.now().toUtc().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await batch.commit(noResult: true);

      final added =
          content.questions.where((q) => !oldIds.contains(q.id)).length;
      return (
        categories: content.categories.length,
        questions: content.questions.length,
        questionsAdded: added,
      );
    });
  }

  Future<String?> _getMeta(String key) async {
    final db = await _appDatabase.database;
    final rows = await db.query(
      'meta',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first['value'] as String?;
  }
}