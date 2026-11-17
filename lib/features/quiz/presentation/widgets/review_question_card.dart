import 'package:flutter/material.dart';
import 'package:quiz_app/core/theme/app_colors.dart';
import 'package:quiz_app/features/feedback/presentation/widgets/feedback_sheet.dart';
import 'package:quiz_app/features/quiz/domain/entities/answer_option.dart';
import 'package:quiz_app/features/quiz/domain/entities/question.dart';
import 'package:quiz_app/features/quiz/presentation/widgets/answer_option_tile.dart';
import 'package:quiz_app/features/quiz/presentation/widgets/question_image.dart';

class ReviewQuestionCard extends StatelessWidget {
  const ReviewQuestionCard({
    super.key,
    required this.number,
    required this.question,
    required this.chosenOptionId,
    required this.isCorrect,
  });

  final int number;
  final Question question;

  /// Null when the question was not answered.
  final int? chosenOptionId;
  final bool isCorrect;

  (IconData, Color) _marker(ColorScheme scheme) {
    if (chosenOptionId == null) {
      return (Icons.remove_circle_outline, scheme.outline);
    }
    return isCorrect
        ? (Icons.check_circle, AppColors.correctLight)
        : (Icons.cancel, AppColors.wrongLight);
  }

  AnswerOptionState _stateOf(AnswerOption option) {
    if (option.isCorrect) return AnswerOptionState.correct;
    if (option.id == chosenOptionId) return AnswerOptionState.wrong;
    return AnswerOptionState.idle;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final (icon, color) = _marker(scheme);
    final chosen =
        question.options.where((o) => o.id == chosenOptionId).firstOrNull;
    final explanation = question.explanation;
    final imageUrl = question.imageUrl;

    return Card(
      elevation: 0,
      color: AppColors.panel,
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: ExpansionTile(
        iconColor: AppColors.gold,
        collapsedIconColor: AppColors.outline,
        shape: const Border(),
        collapsedShape: const Border(),
        leading: Icon(icon, color: color),
        title: Text('$number. ${question.text}', style: theme.textTheme.bodyMedium ),
        subtitle: Text(
          chosen == null ? 'Not answered' : 'Your answer: ${chosen.text}',
          style: theme.textTheme.labelSmall?.copyWith(color: color),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          if (imageUrl != null && imageUrl.isNotEmpty) ...[
            QuestionImage(url: imageUrl),
            const SizedBox(height: 12),
          ],
          for (final (index, option) in question.options.indexed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: AnswerOptionTile(
                label: String.fromCharCode(65 + index),
                text: option.text, 
                state: _stateOf(option)
              ),
            ),
          if (explanation != null && explanation.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text('Explanation', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(explanation, style: theme.textTheme.bodyMedium),
          ],
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => showFeedbackSheet(question: question),
              icon: const Icon(Icons.flag_outlined, size: 18),
              label: const Text('Report a problem'),
            ),
          ),
        ],
      ),
    );
  }
}