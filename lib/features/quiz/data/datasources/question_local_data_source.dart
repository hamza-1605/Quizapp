import 'package:quiz_app/core/database/app_database.dart';
import 'package:quiz_app/features/quiz/data/models/question_model.dart';
import 'package:quiz_app/features/quiz/domain/entities/answer_option.dart';

class QuestionLocalDataSource {
  QuestionLocalDataSource(this._appDatabase);
  final AppDatabase _appDatabase;

  // Every requested category appears in the result, with 0 if it is empty.
  Future<Map<int, int>> getQuestionCounts(List<int> categoryIds) async {
    if (categoryIds.isEmpty) return {};
    final db = await _appDatabase.database;
    final rows = await db.rawQuery(
      'SELECT category_id, COUNT(*) AS total FROM questions '
      'WHERE category_id IN (${_placeholders(categoryIds.length)}) '
      'GROUP BY category_id',
      categoryIds,
    );
    
    final counts = {for (final id in categoryIds) id: 0};
    for (final row in rows) {
      counts[row['category_id'] as int] = row['total'] as int;
    }
    return counts;
  }


  Future<List<QuestionModel>> getRandomQuestions(
    int categoryId,
    int limit,
  ) async {
    final db = await _appDatabase.database;
    final questionRows = await db.query(
      'questions',
      where: 'category_id = ?',
      whereArgs: [categoryId],
      orderBy: 'RANDOM()',
      limit: limit,
    );
    if (questionRows.isEmpty) return [];

    final questionIds = questionRows.map((row) => row['id'] as int).toList();
    final optionRows = await db.rawQuery(
      'SELECT * FROM options '
      'WHERE question_id IN (${_placeholders(questionIds.length)}) '
      'ORDER BY id',
      questionIds,
    );

    final optionsByQuestion = <int, List<AnswerOption>>{};
    for (final row in optionRows) {
      optionsByQuestion
          .putIfAbsent(row['question_id'] as int, () => [])
          .add(QuestionModel.optionFromMap(row));
    }

    return [
      for (final row in questionRows)
        QuestionModel.fromMap(row, optionsByQuestion[row['id'] as int] ?? []),
    ];
  }


  // "?,?,?" for [count] values. Only markers go into the SQL text,
  // the real values are always passed separately; to avoid SQL Injection
  String _placeholders(int count) => List.filled(count, '?').join(',');
}