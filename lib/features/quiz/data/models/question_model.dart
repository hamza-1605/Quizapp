import 'package:quiz_app/features/quiz/domain/entities/answer_option.dart';
import 'package:quiz_app/features/quiz/domain/entities/question.dart';
import 'package:quiz_app/features/quiz/domain/entities/question_type.dart';

class QuestionModel extends Question {
  const QuestionModel({
    required super.id,
    required super.categoryId,
    required super.text,
    required super.type,
    required super.options,
    super.explanation,
    super.imageUrl,
  });

  factory QuestionModel.fromJson( Map<String, dynamic> json ) {
    final options = (json['options'] as List<dynamic>).map((raw) {
      final option = raw as Map<String, dynamic>;
      return AnswerOption(
        id: option['id'] as int,
        text: option['text'] as String,
        isCorrect: option['correct'] as bool,
      );
    }).toList();

    return QuestionModel(
      id: json['id'] as int,
      categoryId: json['categoryId'] as int,
      text: json['questionText'] as String,
      type: _typeFromApi(json['type'] as String),
      explanation: json['explanation'] as String?,
      imageUrl: json['imageUrl'] as String?,
      options: options,
    );
  }

  /// Row for the `questions` table.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'question_text': text,
      'type': _typeToApi(type),
      'explanation': explanation,
      'image_url': imageUrl,
    };
  }

  /// Rows for the `options` table, one per answer option.
  List<Map<String, Object?>> optionMaps() {
    return [
      for (final option in options)
        {
          'id': option.id,
          'question_id': id,
          'option_text': option.text,
          'is_correct': option.isCorrect ? 1 : 0,
        },
    ];
  }

  static QuestionType _typeFromApi(String value) => switch (value) {
        'TRUE_FALSE' => QuestionType.trueFalse,
        'MULTIPLE_CHOICE' => QuestionType.multipleChoice,
        _ => throw FormatException('Unknown question type: $value'),
      };

  static String _typeToApi(QuestionType type) => switch (type) {
        QuestionType.trueFalse => 'TRUE_FALSE',
        QuestionType.multipleChoice => 'MULTIPLE_CHOICE',
      };
}