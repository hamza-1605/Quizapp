import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/core/theme/app_colors.dart';
import 'package:quiz_app/core/widgets/app_scaffold.dart';
import 'package:quiz_app/features/categories/presentation/controllers/home_controller.dart';
import 'package:quiz_app/features/categories/presentation/widgets/category_card.dart';
import 'package:quiz_app/features/categories/presentation/widgets/round_mode_tile.dart';
import 'package:quiz_app/features/sync/presentation/controllers/sync_controller.dart';
import 'package:quiz_app/features/sync/presentation/widgets/first_sync_view.dart';
import 'package:quiz_app/features/sync/presentation/widgets/sync_status_bar.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final sync = Get.find<SyncController>();

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
        actions: [
          Obx(() {
            // With no content, the first-launch screen has its own button.
            if (controller.categories.isEmpty) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Check for updates',
              onPressed: sync.isBusy ? null : sync.sync,
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.categories.isEmpty) {
          return const FirstSyncView();
        }
        return Column(
          children: [
            const SyncStatusBar(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: controller.categories.length + 1,
                itemBuilder: (context, index) {
                  if (index < controller.categories.length) {
                    final category = controller.categories[index];
                    return CategoryCard(
                      category: category,
                      alignRight: index.isOdd,
                      onTap: () => controller.openCategory(category),
                    );
                  }
                  // After the categories: the special round types.
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       Padding(
                        padding: const EdgeInsets.fromLTRB(28, 20, 28, 6),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'MIXED ROUNDS',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: AppColors.textMuted,
                                  letterSpacing: 1.4,
                                ),
                          ),
                        ),
                      ),
                      RoundModeTile(
                        icon: Icons.shuffle,
                        title: 'Random mix',
                        subtitle: 'Questions from all categories',
                        onTap: controller.openRandomRound,
                      ),
                      RoundModeTile(
                        icon: Icons.tune,
                        title: 'Custom quiz',
                        subtitle: 'Pick your own categories',
                        onTap: controller.openCustomRound,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}