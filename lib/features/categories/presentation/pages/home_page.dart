import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/features/categories/presentation/controllers/home_controller.dart';
import 'package:quiz_app/features/categories/presentation/widgets/category_tile.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz App')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.categories.isEmpty) {
          return const Center(child: Text('No categories yet'));
        }
        return ListView.builder(
          itemCount: controller.categories.length,
           itemBuilder: (context, index) {
            return CategoryTile(category: controller.categories[index]);
          },
        );
      }),
    );
  }
}