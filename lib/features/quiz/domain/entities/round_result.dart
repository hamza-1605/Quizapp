import 'package:quiz_app/features/quiz/domain/entities/question.dart';

// What happened in a finished round.
class RoundResult {
  const RoundResult({required this.questions, required this.answers});

  final List<Question> questions;

  // Question id -> the option id the player chose. A question with no
  // entry was not answered, and counts as wrong.
  final Map<int, int> answers;

  int get total => questions.length;

  int get correctCount => questions.where(isCorrect).length;

  int get percentage => total == 0 ? 0 : (correctCount * 100 / total).round();

  bool isCorrect(Question question) => question.options.any(
        (option) => option.isCorrect && option.id == answers[question.id],
      );
}