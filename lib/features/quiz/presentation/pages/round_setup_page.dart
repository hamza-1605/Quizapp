import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/features/quiz/presentation/controllers/round_setup_controller.dart';

class RoundSetupPage extends GetView<RoundSetupController> {
  const RoundSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(controller.roundArguments.title)),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          final available = controller.availableCount.value;
          final smallest = RoundSetupController.countOptions.first;

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('How many questions?', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  children: [
                    for (final count in RoundSetupController.countOptions)
                      ChoiceChip(
                        label: Text('$count'),
                        selected: controller.selectedCount.value == count,
                        onSelected: controller.isAvailable(count)
                            ? (_) => controller.selectCount(count)
                            : null,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  available < smallest
                      ? 'Only $available questions available so far.'
                      : '$available questions available',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: controller.canStart ? controller.start : null,
                    child: const Text('Start'),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}