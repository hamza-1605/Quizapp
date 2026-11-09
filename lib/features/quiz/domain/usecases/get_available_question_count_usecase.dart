import 'package:quiz_app/features/quiz/domain/repositories/question_repository.dart';

class GetAvailableQuestionCountUsecase {
  GetAvailableQuestionCountUsecase(this._repository);
  final QuestionRepository _repository;

  // How many questions the given categories have in total.
  Future<int> call(List<int> categoryIds) async {
    final counts = await _repository.getQuestionCounts(categoryIds);
    return counts.values.fold<int>(0, (sum, count) => sum + count);
  }
}