import 'package:quiz_app/features/quiz/domain/repositories/question_repository.dart';

class GetQuestionCountsUsecase {
  GetQuestionCountsUsecase(this._repository);

  final QuestionRepository _repository;

  // Category id -> how many questions that category has.
  Future<Map<int, int>> call(List<int> categoryIds) =>
      _repository.getQuestionCounts(categoryIds);
}