import 'package:quiz_app/features/feedback/domain/entities/feedback_type.dart';

class FeedbackReport {
  const FeedbackReport({
    required this.type,
    required this.message,
    this.questionId,
    this.questionText,
    this.options,
  });

  final FeedbackType type;
  final String message;

  /// Filled in when the report is about a specific question.
  final int? questionId;
  final String? questionText;
  final String? options;
}