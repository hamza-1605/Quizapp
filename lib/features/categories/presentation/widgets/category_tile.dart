import 'package:flutter/material.dart';
import 'package:quiz_app/core/utils/color_utils.dart';
import 'package:quiz_app/features/categories/domain/entities/category.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.category, this.onTap});

  final Category category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final background = colorFromHex(category.color) ??
        Theme.of(context).colorScheme.primaryContainer;
    final isDark =
        ThemeData.estimateBrightnessForColor(background) == Brightness.dark;
    final initial =
        category.name.isEmpty ? '?' : category.name[0].toUpperCase();

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: background,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        child: Text(initial),
      ),
      title: Text(category.name),
    );
  }
}