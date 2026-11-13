import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/features/quiz/domain/entities/answer_option.dart';
import 'package:quiz_app/features/quiz/presentation/controllers/quiz_controller.dart';
import 'package:quiz_app/features/quiz/presentation/widgets/answer_option_tile.dart';
import 'package:quiz_app/features/quiz/presentation/widgets/question_image.dart';
import 'package:quiz_app/core/utils/time_format.dart';

class QuizPage extends GetView<QuizController> {
  const QuizPage({super.key});

  Future<void> _confirmQuit(BuildContext context) async {
    final quit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Quit this round?'),
        content: const Text('Your progress in this round will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep playing'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Quit'),
          ),
        ],
      ),
    );
    if (quit == true) Get.back();
  }

  Widget _buildBody() {
    if (controller.isLoading.value)   return const Center(child: CircularProgressIndicator());
    final error = controller.errorMessage.value;
    if (error != null)   return _ErrorView(message: error);
    return const _QuestionView();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        // While a round is running, going back must be confirmed first.
        canPop: !controller.isRoundInProgress,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _confirmQuit(context);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(controller.appBarTitle),
            actions: [
              if (controller.isTimed && controller.isRoundInProgress)
                const _TimerBadge(),
            ],
          ),
          body: SafeArea(child: _buildBody()),
        ),
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
      final imageUrl = question.imageUrl;
      final submitted = controller.isSubmitted.value;
      final hasSelection = controller.selectedOptionId.value != null;

      final isTimed = controller.isTimed;
      final buttonLabel = isTimed || submitted
          ? (controller.isLastQuestion ? 'Finish' : 'Next')
          : 'Submit';
      final VoidCallback? onPressed = isTimed
          ? (hasSelection ? controller.answerAndNext : null)
          : (submitted
              ? controller.next
              : (hasSelection ? controller.submit : null));

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
                  if (imageUrl != null && imageUrl.isNotEmpty) ...[
                    QuestionImage(url: imageUrl),
                    const SizedBox(height: 16),
                  ],
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
                onPressed: onPressed,
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


class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 24),
            Text(
              message,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Get.back(),
              child: const Text('Go back'),
            ),
          ],
        ),
      ),
    );
  }
}


class _TimerBadge extends GetView<QuizController> {
  const _TimerBadge();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final seconds = controller.remainingSeconds.value;
      final color =
          seconds <= 10 ? theme.colorScheme.error : theme.colorScheme.onSurface;

      return Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Row(
          children: [
            Icon(Icons.timer_outlined, color: color),
            const SizedBox(width: 4),
            Text(
              formatSeconds(seconds),
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      );
    });
  }
}