import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/core/widgets/app_scaffold.dart';
import 'package:quiz_app/features/quiz/presentation/controllers/round_setup_controller.dart';
import 'package:quiz_app/core/utils/time_format.dart';

class RoundSetupPage extends GetView<RoundSetupController> {
  const RoundSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      appBar: AppBar(title: Text(controller.arguments.title)),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.isCustom) ...[
                        const _CategoryPicker(),
                        const Divider(height: 30),
                      ],
                      Text(
                        'Choose how many questions?',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        children: [
                          for (final count in controller.countOptions)
                            ChoiceChip(
                              label: Text('$count'),
                              selected: controller.selectedCount.value == count,
                              onSelected: controller.isAvailable(count)
                                  ? (_) => controller.selectCount(count)
                                  : null,
                            ),
                        ],
                      ),
                      const Divider(height: 36),
                      const _TimerSection(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: controller.canStart ? controller.start : null,
                    child: const Text('Start'),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _CategoryPicker extends GetView<RoundSetupController> {
  const _CategoryPicker();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Its own Obx: this widget is built separately from the page's Obx.
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Choose categories',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              TextButton(
                onPressed: controller.toggleSelectAll,
                child: Text(controller.areAllSelected ? 'Clear' : 'Select all'),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              !controller.hasEnoughCategories 
              ? 'Select at least ${RoundSetupController.minCustomCategories} categories to continue.'
              : '',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              for (final category in controller.arguments.selectableCategories)
                ChoiceChip(
                  label: Text(category.name),
                  selected: controller.selectedCategoryIds.contains(category.id),
                  onSelected: controller.categoryQuestionCount(category.id) > 0
                      ? (_) => controller.toggleCategory(category.id)
                      : null,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimerSection extends GetView<RoundSetupController> {
  const _TimerSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final isOn = controller.isTimerOn.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Timer', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      'Race the clock. You see the answers at the end.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Switch(value: isOn, onChanged: controller.setTimerOn),
            ],
          ),
          if (isOn) ...[
            const SizedBox(height: 8),
            Text('Seconds per question', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: [
                for (final seconds in RoundSetupController.paceOptions)
                  ChoiceChip(
                    label: Text('$seconds'),
                    selected: controller.secondsPerQuestion.value == seconds,
                    onSelected: (_) => controller.selectPace(seconds),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (controller.hasEnoughCategories &&
              controller.selectedCount.value > 0) ...[
              Text(
                'Total time: ${formatSeconds(controller.totalSeconds)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ]
          ],
        ],
      );
    });
  }
}