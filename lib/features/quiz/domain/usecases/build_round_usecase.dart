import 'dart:math';

import 'package:quiz_app/features/quiz/domain/entities/question.dart';
import 'package:quiz_app/features/quiz/domain/repositories/question_repository.dart';
import 'package:quiz_app/features/quiz/domain/services/balanced_quotas.dart';

class BuildRoundUsecase {
  BuildRoundUsecase(this._questionRepository, {Random? random}) : _random = random ?? Random();

  final QuestionRepository _questionRepository;
  final Random _random;

  // Picks [questionCount] questions, balanced across [categoryIds].
  // Questions never repeat, and both questions and options are shuffled.
  Future<List<Question>> call({
    required List<int> categoryIds,
    required int questionCount,
  }) async {
    final available = await _questionRepository.getQuestionCounts(categoryIds);
    final quotas = calculateBalancedQuotas(
      total: questionCount,
      available: available,
      random: _random,
    );

    final questions = <Question>[];
    for (final entry in quotas.entries) {
      if (entry.value == 0) continue;
      questions.addAll(
        await _questionRepository.getRandomQuestions(entry.key, entry.value),
      );
    }

    questions.shuffle(_random);
    return [for (final q in questions) q.withShuffledOptions(_random)];
  }
}