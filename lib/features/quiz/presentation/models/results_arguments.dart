import 'package:quiz_app/features/quiz/domain/entities/round_result.dart';
import 'package:quiz_app/features/quiz/presentation/models/quiz_arguments.dart';

class ResultsArguments {
  const ResultsArguments({required this.result, required this.quizArguments});

  final RoundResult result;

  // The settings of the finished round, so "Play again" can reuse them.
  final QuizArguments quizArguments;
}