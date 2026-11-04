import 'package:quiz_app/features/quiz/domain/entities/answer_option.dart';
import 'package:quiz_app/features/quiz/domain/entities/question_type.dart';

class Question {
  const Question({
    required this.id,
    required this.categoryId,
    required this.text,
    required this.type,
    required this.options,
    this.explanation,
    this.imageUrl,
  });

  final int id;
  final int categoryId;
  final String text;
  final QuestionType type;
  final List<AnswerOption> options;
  final String? explanation;
  final String? imageUrl;
}