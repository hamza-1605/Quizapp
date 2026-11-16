import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/core/theme/app_colors.dart';
import 'package:quiz_app/core/widgets/app_scaffold.dart';
import 'package:quiz_app/core/widgets/game_button.dart';
import 'package:quiz_app/features/quiz/presentation/controllers/results_controller.dart';

class ResultsPage extends GetView<ResultsController> {
  const ResultsPage({super.key});

  String _message(int percentage) {
    if (percentage == 100) return 'PERFECTION!';
    if (percentage >= 80) return 'Great job!';
    if (percentage >= 50) return 'Good effort!';
    if (percentage >= 30) return 'Keep on practicing.';
    if (percentage < 10) return 'Abysmal!';
    return 'Need more practice.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final result = controller.result;

    if (result.percentage == 100) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          controller.launchConfetti(context);
        }
      });
    } 
    
    return AppScaffold(
      appBar: AppBar(title: const Text('Results')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (result.timedOut) ...[
                  Text(
                    "Time's up!",
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Icon(
                  Icons.emoji_events_outlined,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  '${result.correctCount} out of ${result.total} correct',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '${result.percentage}%',
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                if (result.unansweredCount > 0) ...[
                Text(
                    '${result.unansweredCount} unanswered',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                ],
                Text(
                  _message(result.percentage),
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: GameButton(
                          style: GameButtonStyle.secondary,
                          onPressed: controller.playAgain,
                          label: 'Play again',
                          icon: Icons.replay,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: GameButton(
                          style: GameButtonStyle.secondary,
                          onPressed: controller.openReview,
                          label: 'Review answers',
                          icon: Icons.description_outlined,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 18),
                      GameButton(
                        style: GameButtonStyle.secondary,
                        onPressed: controller.backToHome,
                        label: 'Back to home',
                        icon: Icons.home,
                        fontSize: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}