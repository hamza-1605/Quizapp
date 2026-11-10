import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/features/quiz/presentation/controllers/results_controller.dart';

class ResultsPage extends GetView<ResultsController> {
  const ResultsPage({super.key});

  String _message(int percentage) {
    if (percentage == 100) return 'PEFRECTION!';
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

    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.emoji_events_outlined,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  '${result.percentage}%',
                  style: theme.textTheme.displayMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '${result.correctCount} of ${result.total} correct',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  _message(result.percentage),
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: controller.playAgain,
                    child: const Text('Play again'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: controller.openReview,
                    child: const Text('Review answers'),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: controller.backToHome,
                  child: const Text('Back to home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}