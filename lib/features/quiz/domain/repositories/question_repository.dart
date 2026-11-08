import 'package:quiz_app/features/quiz/domain/entities/question.dart';

abstract interface class QuestionRepository {
  // How many questions each of the given categories has.
  Future<Map<int, int>> getQuestionCounts(List<int> categoryIds);

  // Up to [limit] random questions of one category, with their options.
  Future<List<Question>> getRandomQuestions(int categoryId, int limit);
}