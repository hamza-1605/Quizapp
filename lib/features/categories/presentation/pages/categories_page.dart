import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/core/widgets/app_scaffold.dart';
import 'package:quiz_app/features/categories/presentation/controllers/home_controller.dart';
import 'package:quiz_app/features/categories/presentation/widgets/category_card.dart';

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
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              return CategoryCard(
                category: category,
                alignRight: index.isOdd,
                onTap: () => controller.openCategory(category),
              );
            },
          ),
        ),
      ),
    );
  }
}