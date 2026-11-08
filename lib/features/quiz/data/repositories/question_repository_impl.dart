import 'package:quiz_app/features/quiz/data/datasources/question_local_data_source.dart';
import 'package:quiz_app/features/quiz/domain/entities/question.dart';
import 'package:quiz_app/features/quiz/domain/repositories/question_repository.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  QuestionRepositoryImpl(this._localDataSource);

  final QuestionLocalDataSource _localDataSource;

  @override
  Future<Map<int, int>> getQuestionCounts(List<int> categoryIds) => _localDataSource.getQuestionCounts( categoryIds );

  @override
  Future<List<Question>> getRandomQuestions(int categoryId, int limit) => _localDataSource.getRandomQuestions( categoryId, limit );
}