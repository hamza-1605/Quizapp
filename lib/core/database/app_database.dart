import 'package:path/path.dart';
import 'package:quiz_app/core/database/database_schema.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  Future<Database>? _database;

  /// Opens the database on first use, then reuses the same connection.
  Future<Database> get database => _database ??= _open();

  Future<Database> _open() async {
    final dbPath = join( await getDatabasesPath(), DatabaseSchema.name );
    
    return openDatabase(
      dbPath,
      version: DatabaseSchema.version,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: (db, version) async {
        final batch = db.batch();
        for (final statement in DatabaseSchema.createStatements) {
          batch.execute(statement);
        }
        await batch.commit(noResult: true);
      },
    );
  }
}