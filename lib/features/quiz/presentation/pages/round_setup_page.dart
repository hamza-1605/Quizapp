import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/features/categories/domain/entities/category.dart';
import 'package:quiz_app/features/categories/presentation/widgets/category_avatar.dart';
import 'package:quiz_app/features/quiz/presentation/controllers/round_setup_controller.dart';

class RoundSetupPage extends GetView<RoundSetupController> {
  const RoundSetupPage({super.key});

  String _hint(int available) {
    if (!controller.hasEnoughCategories) {
      return 'Select at least ${RoundSetupController.minCustomCategories} categories.';
    }
    if (available < RoundSetupController.countOptions.first) {
      return 'Only $available questions available so far.';
    }
    return '$available questions available';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
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
                      Text(
                        'How many questions?',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        children: [
                          for (final count
                              in RoundSetupController.countOptions)
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
                        _hint(controller.availableCount),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (controller.isCustom) ...[
                        const SizedBox(height: 24),
                        const _CategoryPicker(),
                      ],
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
          for (final category in controller.arguments.selectableCategories)
            _CategoryRow(category: category),
        ],
      ),
    );
  }
}

class _CategoryRow extends GetView<RoundSetupController> {
  const _CategoryRow({required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    final count = controller.categoryQuestionCount(category.id);

    return Obx(
      () => CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        value: controller.selectedCategoryIds.contains(category.id),
        onChanged:
            count > 0 ? (_) => controller.toggleCategory(category.id) : null,
        secondary: CategoryAvatar(category: category),
        title: Text(category.name),
        subtitle: Text(count == 0 ? 'No questions yet' : '$count questions'),
      ),
    );
  }
}