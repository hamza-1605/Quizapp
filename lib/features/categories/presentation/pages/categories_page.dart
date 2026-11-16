import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/core/theme/app_colors.dart';
import 'package:quiz_app/core/widgets/app_scaffold.dart';
import 'package:quiz_app/features/categories/presentation/controllers/home_controller.dart';
import 'package:quiz_app/features/categories/presentation/widgets/category_card.dart';
import 'package:quiz_app/features/categories/presentation/widgets/round_mode_tile.dart';

class CategoriesPage extends GetView<HomeController> {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: SafeArea(
        child: Obx(
          () => ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
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
              // Temporary: these two move to their own page in the next step.
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 20, 28, 6),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'MIXED ROUNDS',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
      ),
    );
  }
}