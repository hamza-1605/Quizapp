import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/features/quiz/domain/entities/answer_option.dart';
import 'package:quiz_app/features/quiz/presentation/controllers/quiz_controller.dart';
import 'package:quiz_app/features/quiz/presentation/widgets/answer_option_tile.dart';

class QuizPage extends GetView<QuizController> {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Obx(() => Text(controller.appBarTitle))),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          final error = controller.errorMessage.value;
          if (error != null) {
            return Center(child: Text(error));
          }
          if (controller.isFinished.value) {
            return const _FinishedView();
          }
          return const _QuestionView();
        }),
      ),
    );
  }
}

class _QuestionView extends GetView<QuizController> {
  const _QuestionView();

  AnswerOptionState _stateOf(AnswerOption option) {
    final isSelected = controller.selectedOptionId.value == option.id;
    if (!controller.isSubmitted.value) {
      return isSelected ? AnswerOptionState.selected : AnswerOptionState.idle;
    }
    if (option.isCorrect) return AnswerOptionState.correct;
    if (isSelected) return AnswerOptionState.wrong;
    return AnswerOptionState.idle;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final question = controller.currentQuestion;
      final submitted = controller.isSubmitted.value;
      final hasSelection = controller.selectedOptionId.value != null;

      final buttonLabel = !submitted
          ? 'Submit'
          : (controller.isLastQuestion ? 'Finish' : 'Next');

      return Column(
        children: [
          LinearProgressIndicator(
            value: (controller.currentIndex.value + 1) /
                controller.totalQuestions,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(question.text, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 24),
                  for (final option in question.options)
                    AnswerOptionTile(
                      text: option.text,
                      state: _stateOf(option),
                      onTap: submitted
                          ? null
                          : () => controller.selectOption(option.id),
                    ),
                  if (submitted)
                    _Feedback(
                      isCorrect: controller.isCurrentAnswerCorrect,
                      explanation: question.explanation,
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: submitted
                    ? controller.next
                    : (hasSelection ? controller.submit : null),
                child: Text(buttonLabel),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _Feedback extends StatelessWidget {
  const _Feedback({required this.isCorrect, this.explanation});

  final bool isCorrect;
  final String? explanation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = explanation;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isCorrect ? 'Correct!' : 'Not quite.',
            style: theme.textTheme.titleMedium?.copyWith(
              color: isCorrect ? Colors.green.shade700 : Colors.red.shade700,
            ),
          ),
          if (text != null && text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(text, style: theme.textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}

class _FinishedView extends GetView<QuizController> {
  const _FinishedView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events_outlined,
                size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 24),
            Text('Round complete', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(
              'You scored ${controller.score} of ${controller.totalQuestions}',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: controller.backToHome,
              child: const Text('Back to home'),
            ),
          ],
        ),
      ),
    );
  }
}