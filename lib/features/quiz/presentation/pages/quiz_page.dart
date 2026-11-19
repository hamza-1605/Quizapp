import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/core/theme/app_colors.dart';
import 'package:quiz_app/core/widgets/app_scaffold.dart';
import 'package:quiz_app/core/widgets/game_button.dart';
import 'package:quiz_app/features/feedback/presentation/widgets/feedback_sheet.dart';
import 'package:quiz_app/features/quiz/domain/entities/answer_option.dart';
import 'package:quiz_app/features/quiz/presentation/controllers/quiz_controller.dart';
import 'package:quiz_app/features/quiz/presentation/widgets/answer_option_tile.dart';
import 'package:quiz_app/features/quiz/presentation/widgets/question_image.dart';
import 'package:quiz_app/core/utils/time_format.dart';
import 'package:quiz_app/features/quiz/presentation/widgets/question_panel.dart';

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
        child: AppScaffold(
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
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
            child: LinearProgressIndicator(
              value: (controller.currentIndex.value + 1) /
                  controller.totalQuestions,
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
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
                  QuestionPanel(text: question.text),
                  const SizedBox(height: 24),
                  for (final (index, option) in question.options.indexed)
                    AnswerOptionTile(
                      label: String.fromCharCode(65 + index),
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
                      onReport: () => showFeedbackSheet(question: question),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: SizedBox(
              width: 200,
              child: GameButton(
                style: GameButtonStyle.secondary,
                onPressed: onPressed,
                label: buttonLabel,
                playsSound: false,
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _Feedback extends StatelessWidget {
  const _Feedback({required this.isCorrect, this.explanation, required this.onReport});

  final bool isCorrect;
  final String? explanation;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isCorrect ? AppColors.correctLight : AppColors.wrongLight;
    final text = explanation;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(isCorrect ? Icons.check_circle : Icons.cancel, color: color),
              const SizedBox(width: 8),
              Text(
                isCorrect ? 'Correct!' : 'Incorrect.',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (text != null && text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(text, style: theme.textTheme.bodyMedium),
          ],
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onReport,
              icon: const Icon(Icons.flag_outlined, size: 18),
              label: const Text('Report a problem'),
            ),
          ),
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
      final color = seconds <= 10 ? AppColors.wrongLight : AppColors.gold;

      return Container(
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.navyDeep,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.timer_outlined, size: 18, color: color),
            const SizedBox(width: 6),
            Text(
              formatSeconds(seconds),
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      );
    });
  }
}