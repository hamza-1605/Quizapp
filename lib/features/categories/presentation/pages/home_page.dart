import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/features/categories/presentation/controllers/home_controller.dart';
import 'package:quiz_app/features/categories/presentation/widgets/category_tile.dart';
import 'package:quiz_app/features/sync/presentation/controllers/sync_controller.dart';
import 'package:quiz_app/features/sync/presentation/widgets/first_sync_view.dart';
import 'package:quiz_app/features/sync/presentation/widgets/sync_status_bar.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final sync = Get.find<SyncController>();

    return Scaffold(
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
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                  return CategoryTile(
                    category: category,
                    onTap: () => controller.openCategory(category),
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